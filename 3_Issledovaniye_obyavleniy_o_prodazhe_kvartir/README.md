## Исследовательский анализ данных. Исследование объявлений о продаже квартир

### Задача
На основе архива объявлений о продаже квартир в Санкт-Петербурге и соседних населённых пунктах за несколько лет необходимо определить рыночную стоимость объектов недвижимости:
- изучить параметры объектов и построить гистограммы для каждого из этих параметров, удалить редкие и выбивающиеся значения
- изучить, как быстро продавались квартиры (столбец days_exposition)
- изучить сколько времени обычно занимает продажа
- определить факторы, которые больше всего влияют на общую (полную) стоимость объекта
- изучить, зависит ли цена от общей площади, жилой площади, площади кухни, количества комнат, этажа, на котором расположена квартира (первый, последний, другой), даты размещения (день недели, месяц, год)
- построить графики, которые покажут зависимость цены от указанных выше параметров
- выделить населённые пункты с самой высокой и низкой стоимостью квадратного метра.

### Данные
Архив объявлений о продаже квартир в Санкт-Петербурге и соседних населённых пунктах за несколько лет (real_estate_data.csv):
- airports_nearest — расстояние до ближайшего аэропорта в метрах (м)
- balcony — число балконов
- ceiling_height — высота потолков (м)
- cityCenters_nearest — расстояние до центра города (м)
- days_exposition — сколько дней было размещено объявление (от публикации до снятия)
- first_day_exposition — дата публикации
- floor — этаж
- floors_total — всего этажей в доме
- is_apartment — апартаменты (булев тип)
- kitchen_area — площадь кухни в квадратных метрах (м²)
- last_price — цена на момент снятия с публикации
- living_area — жилая площадь в квадратных метрах (м²)
- locality_name — название населённого пункта
- open_plan — свободная планировка (булев тип)
- parks_around3000 — число парков в радиусе 3 км
- parks_nearest — расстояние до ближайшего парка (м)
- ponds_around3000 — число водоёмов в радиусе 3 км
- ponds_nearest — расстояние до ближайшего водоёма (м)
- rooms — число комнат
- studio — квартира-студия (булев тип)
- total_area — общая площадь квартиры в квадратных метрах (м²)
- total_images — число фотографий квартиры в объявлении

### Используемые библиотеки
pandas, matplotlib