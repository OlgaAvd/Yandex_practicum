1.-----
SELECT *
FROM company
WHERE status = 'closed'
2.-----
SELECT SUM(funding_total)
FROM company
WHERE country_code = 'USA' AND category_code = 'news'
GROUP BY name
ORDER BY SUM(funding_total) DESC
3.-----
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash' AND EXTRACT(YEAR FROM acquired_at) BETWEEN 2011 AND 2013
4.-----
SELECT first_name, last_name, network_username AS network_username
FROM people
WHERE network_username LIKE 'Silver%'
5.-----
SELECT *
FROM people
WHERE network_username LIKE '%money%' AND last_name LIKE 'K%'
6.-----
SELECT country_code,
              SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC
7.-----
SELECT funded_at,
              MIN(raised_amount),
              MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) <> 0 AND MIN(raised_amount) <> MAX(raised_amount)
8.-----
SELECT *,
     CASE
        WHEN invested_companies < 20 THEN 'low_activity'
        WHEN invested_companies >= 20 AND invested_companies < 100 THEN 'middle_activity'
        WHEN invested_companies >= 100 THEN 'high_activity' 
     END
FROM fund
9.-----
SELECT 
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds)) AS avg
FROM fund
GROUP BY activity
ORDER BY avg;
10.-----
SELECT country_code,
       MIN(invested_companies),
       MAX(invested_companies),
       AVG(invested_companies)
FROM fund
WHERE EXTRACT(YEAR FROM founded_at) BETWEEN 2010 AND 2012
GROUP BY country_code
HAVING MIN(invested_companies) <> 0
ORDER BY AVG(invested_companies) DESC, country_code
LIMIT 10
11.-----
SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p
LEFT OUTER JOIN education AS e ON p.id=e.person_id
12.-----
SELECT c.name,
       COUNT(DISTINCT instituition)
FROM company AS c
LEFT OUTER JOIN people AS p ON c.id=p.company_id
LEFT OUTER JOIN education AS e ON p.id=e.person_id
GROUP BY c.id
ORDER BY COUNT(DISTINCT instituition) DESC
LIMIT 5
13.-----
SELECT DISTINCT c.name
FROM company AS c
LEFT OUTER JOIN funding_round AS fr ON c.id=fr.company_id
WHERE status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1
14.-----
SELECT DISTINCT p.id
FROM people AS p

WHERE p.company_id IN (SELECT DISTINCT c.id
                      FROM company AS c
                      LEFT OUTER JOIN funding_round AS fr ON c.id=fr.company_id
                      WHERE status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1)
15.-----
SELECT DISTINCT p.id,
                e.instituition
FROM people AS p
INNER JOIN education AS e ON p.id=e.person_id
WHERE p.company_id IN (SELECT DISTINCT c.id
                      FROM company AS c
                      LEFT OUTER JOIN funding_round AS fr ON c.id=fr.company_id
                      WHERE status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1)
16.-----
SELECT DISTINCT p.id,
              --  e.instituition
                COUNT( e.instituition)
FROM people AS p
INNER JOIN education AS e ON p.id=e.person_id
WHERE p.company_id IN (SELECT DISTINCT c.id
                      FROM company AS c
                      LEFT OUTER JOIN funding_round AS fr ON c.id=fr.company_id
                      WHERE status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1)
GROUP BY p.id    
17.-----
SELECT AVG(list.count)
FROM
    (SELECT DISTINCT p.id,
            COUNT( e.instituition)
    FROM people AS p
    INNER JOIN education AS e ON p.id=e.person_id
    WHERE p.company_id IN (SELECT DISTINCT c.id
                          FROM company AS c
                          LEFT OUTER JOIN funding_round AS fr ON c.id=fr.company_id
                          WHERE status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1)
    GROUP BY p.id) AS list     
18.-----
SELECT AVG(educ.count)
FROM (SELECT p.id,
             COUNT(e.id)
      FROM people AS p
      INNER JOIN education AS e ON p.id=e.person_id
      WHERE p.company_id=(SELECT id
                          FROM company
                          WHERE name = 'Socialnet')
      GROUP BY p.id) AS educ    
19.-----
WITH
fr AS (SELECT *
       FROM funding_round
       WHERE EXTRACT(YEAR FROM CAST(funded_at AS TIMESTAMP)) BETWEEN 2012 AND 2013),
c AS (SELECT *
     FROM company
     WHERE milestones > 6)       

SELECT f.name AS name_of_fund,
       c.name AS name_of_company,
       fr.raised_amount AS amount
FROM investment AS i
INNER JOIN c AS c ON i.company_id=c.id
INNER JOIN fund AS f ON i.fund_id=f.id
INNER JOIN  fr ON i.funding_round_id=fr.id
20.-----
SELECT c1.name,
       a.price_amount,
       c2.name,
       c2.funding_total,
       ROUND(a.price_amount / c2.funding_total)
FROM acquisition AS a
LEFT OUTER JOIN company AS c1 ON a.acquiring_company_id=c1.id
LEFT OUTER JOIN company AS c2 ON a.acquired_company_id=c2.id
WHERE a.price_amount <> 0 AND c2.funding_total <> 0
ORDER BY  a.price_amount DESC,  c2.name
LIMIT 10
21.-----
WITH
c AS (SELECT *
      FROM company
      WHERE category_code = 'social'),
      
fr AS (SELECT *
      FROM funding_round
      WHERE EXTRACT(YEAR FROM funded_at) BETWEEN 2010 AND 2013)
      
SELECT c.name,
       EXTRACT(MONTH FROM funded_at)
FROM c
INNER JOIN fr ON c.id=fr.company_id
WHERE fr.raised_amount <> 0
22.-----
WITH
count_invest AS (SELECT EXTRACT(MONTH FROM funded_at) AS month,
                        COUNT(DISTINCT f.id) AS count_fund
                 FROM investment AS i
                 INNER JOIN funding_round AS fr ON i.funding_round_id=fr.id
                 INNER JOIN fund AS f ON i.fund_id=f.id
                 WHERE f.country_code = 'USA' AND EXTRACT(YEAR FROM fr.funded_at) BETWEEN 2010 AND 2013
                 GROUP BY month),

count_company AS (SELECT EXTRACT(MONTH FROM a.acquired_at) AS month,
                         COUNT(a.acquired_company_id) AS count_company,
                         SUM(a.price_amount) AS amount
                  FROM acquisition AS a
                  WHERE EXTRACT(YEAR FROM a.acquired_at)  BETWEEN 2010 AND 2013
                  GROUP BY month)
                  
SELECT count_invest.month,
       count_invest.count_fund,
       count_company.count_company,
       count_company.amount
FROM count_invest
INNER JOIN count_company ON count_invest.month=count_company.month
23.-----
WITH
     inv_2011 AS (SELECT country_code,
                         AVG(funding_total) AS avg_2011
                  FROM company
                  WHERE EXTRACT(YEAR FROM founded_at) = 2011
                  GROUP BY country_code),
     inv_2012 AS (SELECT country_code,
                         AVG(funding_total) AS avg_2012
                  FROM company
                  WHERE EXTRACT(YEAR FROM founded_at) = 2012
                  GROUP BY country_code),            
     inv_2013 AS (SELECT country_code,
                         AVG(funding_total) AS avg_2013
                  FROM company
                  WHERE EXTRACT(YEAR FROM founded_at) = 2013
                  GROUP BY country_code)
                  
SELECT inv_2011.country_code,
       inv_2011.avg_2011,
       inv_2012.avg_2012,
       inv_2013.avg_2013
FROM inv_2011
INNER JOIN inv_2012 ON inv_2011.country_code=inv_2012.country_code
INNER JOIN inv_2013 ON inv_2011.country_code=inv_2013.country_code
ORDER BY inv_2011.avg_2011 DESC
