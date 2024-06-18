1.-----
SELECT COUNT(p.id)
FROM stackoverflow.posts as p 
INNER JOIN stackoverflow.post_types as pt on p.post_type_id=pt.id
WHERE pt.type='Question' AND (p.favorites_count>=100 OR p.score>300)
2.-----
SELECT ROUND(AVG(total))
FROM (SELECT CAST(p.creation_date AS DATE) AS dates, 
             COUNT(p.id) AS total
      FROM stackoverflow.posts AS p 
      INNER JOIN stackoverflow.post_types AS pt ON p.post_type_id=pt.id
      WHERE pt.type='Question' AND CAST(p.creation_date AS DATE)>='2008-11-01' AND CAST(p.creation_date AS DATE)<='2008-11-18'
      GROUP BY dates) as total
3.-----
SELECT COUNT(DISTINCT b.user_id)
FROM stackoverflow.users AS u
RIGHT JOIN stackoverflow.badges AS b ON u.id=b.user_id
WHERE CAST(u.creation_date AS DATE) = CAST(b.creation_date AS DATE)
4.-----
SELECT COUNT(DISTINCT id)
FROM (
     SELECT p.id
     FROM stackoverflow.users AS u
     LEFT JOIN stackoverflow.posts AS p ON u.id=p.user_id
     INNER JOIN stackoverflow.votes AS v ON p.id=v.post_id
     WHERE u.display_name='Joel Coehoorn'
     GROUP BY p.id
     HAVING COUNT(v.id)>=1) AS t1
5.-----
SELECT *,
       ROW_NUMBER() OVER(ORDER BY id DESC) AS rank
FROM stackoverflow.vote_types
ORDER BY id
6.-----
SELECT u.id,
       COUNT(v.id)
FROM stackoverflow.users AS u
INNER JOIN stackoverflow.votes AS v ON u.id=v.user_id
INNER JOIN stackoverflow.vote_types AS vt ON v.vote_type_id=vt.id
WHERE vt.name='Close'
GROUP BY u.id
ORDER BY COUNT(v.id) DESC, u.id DESC
LIMIT 10
7.-----
SELECT *,
       DENSE_RANK() OVER(ORDER BY total DESC)
FROM (SELECT u.id,
             COUNT(b.id) AS total
      FROM stackoverflow.users AS u
      INNER JOIN stackoverflow.badges AS b ON u.id=b.user_id
      WHERE CAST(b.creation_date AS DATE)>='2008-11-15' AND CAST(b.creation_date AS DATE)<='2008-12-15'
      GROUP BY u.id) as t1
ORDER BY  total DESC, id
LIMIT 10
8.-----
SELECT title,
       user_id,
       score,
       ROUND(AVG(score) OVER(PARTITION BY user_id))
FROM stackoverflow.posts
WHERE title IS NOT NULL AND score<>0
9.-----
SELECT title
FROM stackoverflow.posts
WHERE user_id IN (SELECT u.id
                  FROM stackoverflow.users AS u
                  INNER JOIN stackoverflow.badges AS b ON u.id=b.user_id
                  GROUP BY u.id
                  HAVING COUNT(b.id)>1000) AND title IS NOT NULL
10.-----
SELECT id,
       views,
       CASE
           WHEN views>=350 THEN 1
           WHEN views<350 AND views>=100 THEN 2
           WHEN views<100 THEN 3
       END
FROM stackoverflow.users
WHERE location LIKE '%Canada%' AND views > 0
11.-----
WITH t1 AS (SELECT id,
                   views,
                   CASE
                       WHEN views>=350 THEN 1
                       WHEN views<350 AND views>=100 THEN 2
                       WHEN views<100 THEN 3
                   END AS users_group
             FROM stackoverflow.users
             WHERE location LIKE '%Canada%' AND views > 0)
SELECT id,
       users_group,
       views
FROM t1
WHERE views IN (SELECT MAX(views)
             FROM t1
            GROUP BY users_group)
ORDER BY views DESC, id
12.-----
SELECT *,
       SUM(cnt_user) OVER(ORDER BY days) AS total
FROM (SELECT EXTRACT(DAY FROM creation_date) AS days, 
             COUNT(id) AS cnt_user     
      FROM stackoverflow.users
      WHERE EXTRACT(YEAR FROM creation_date)=2008 AND EXTRACT(MONTH FROM creation_date)=11
      GROUP BY days) AS t1
13.-----
WITH t1 AS (SELECT user_id,
                     creation_date,
                     ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY creation_date) AS rang
              FROM stackoverflow.posts)
SELECT u.id,
       t2.creation_date - u.creation_date
FROM stackoverflow.users AS u
INNER JOIN (SELECT user_id,
                   creation_date
            FROM t1
            WHERE rang=1) AS t2 ON u.id=t2.user_id

1.-----
SELECT CAST(DATE_TRUNC('month', creation_date) AS DATE),
       SUM(views_count) AS total
FROM stackoverflow.posts
WHERE EXTRACT(YEAR FROM creation_date)=2008
GROUP BY DATE_TRUNC('month', creation_date)
ORDER BY total DESC
2.-----
SELECT u.display_name,
       COUNT(DISTINCT p.user_id)  
FROM stackoverflow.posts AS p
INNER JOIN stackoverflow.users AS u ON p.user_id=u.id
INNER JOIN stackoverflow.post_types AS pt ON p.post_type_id=pt.id
WHERE p.creation_date::DATE  <= u.creation_date::DATE + INTERVAL '1 month' AND p.creation_date::DATE >= u.creation_date::DATE AND pt.type LIKE '%Answer%'
GROUP BY u.display_name
HAVING COUNT(p.id)>100
ORDER BY u.display_name
3.-----
WITH t1 AS (SELECT u.id       
            FROM stackoverflow.users AS u
            INNER JOIN stackoverflow.posts AS p ON u.id=p.user_id
            WHERE CAST(DATE_TRUNC('month', u.creation_date) AS DATE) = '2008-09-01' 
                AND CAST(DATE_TRUNC('month', p.creation_date) AS DATE) ='2008-12-01'
            GROUP BY u.id     
            HAVING COUNT(p.id) > 0)
SELECT CAST(DATE_TRUNC('month', p.creation_date) AS DATE) AS months,
       COUNT(p.id)
FROM stackoverflow.posts AS p
WHERE EXTRACT(YEAR FROM p.creation_date)=2008 AND p.user_id IN (SELECT *
                                                                FROM t1)            
GROUP BY months
ORDER BY months DESC
4.-----
SELECT user_id,
       creation_date,
       views_count,
       SUM(views_count) OVER(PARTITION BY user_id ORDER BY creation_date)
FROM stackoverflow.posts
ORDER BY user_id
5.-----
WITH t1 AS (SELECT user_id,
                   COUNT(DISTINCT CAST(DATE_TRUNC('day', creation_date) AS DATE)) as days
            FROM stackoverflow.posts
            WHERE CAST(DATE_TRUNC('day', creation_date) AS DATE) BETWEEN '2008-12-01' AND '2008-12-07'
            GROUP BY user_id)
SELECT ROUND(AVG(days))
FROM t1
6.-----
WITH t1 AS (SELECT EXTRACT(month FROM creation_date) AS months,
                   COUNT(id) AS cnt_post
            FROM stackoverflow.posts
            WHERE CAST(DATE_TRUNC('month', creation_date) AS DATE) BETWEEN '2008-09-01' AND '2008-12-31'
            GROUP BY months
            )
SELECT *,
       ROUND(((cnt_post::numeric / LAG(cnt_post) OVER())-1)*100.0, 2)
FROM t1
7.-----
WITH t2 AS (SELECT user_id,
                   EXTRACT(week FROM creation_date) AS weeks,
                   creation_date,
                   row_number() OVER (PARTITION BY EXTRACT(week FROM creation_date) ORDER BY creation_date DESC) AS rang
            FROM stackoverflow.posts
            WHERE user_id = (SELECT user_id
                             FROM stackoverflow.posts
                             GROUP BY user_id
                             HAVING COUNT(id)=(SELECT MAX(count)
                                               FROM (SELECT COUNT(id)
                                                     FROM stackoverflow.posts
                                                     GROUP BY user_id) AS t1
                                              )
                            ) AND CAST(DATE_TRUNC('month', creation_date) AS DATE)='2008-10-01'   
            )
SELECT weeks,
       creation_date
FROM t2
WHERE rang=1
