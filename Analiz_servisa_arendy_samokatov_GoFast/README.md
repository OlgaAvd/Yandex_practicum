##	Статистический анализ данных. Анализ сервиса аренды самокатов GoFast

### Задача
На основе данных, предоставленных популярным сервисом аренды самокатов GoFast, о некоторых пользователях из нескольких городов, а также об их поездках необходимо описать и визуализировать информацию:
- частота встречаемости городов
- соотношение пользователей с подпиской и без подписки
- возраст пользователей
- расстояние, которое пользователь преодолел за одну поездку
- продолжительность поездок

Затем необходимо объединить данные в один датафрейм:
- визуализировать общую информацию
- найти суммарное расстояние, количество поездок и суммарное время для каждого пользователя за каждый месяц
- найти помесячную выручку, которую принёс каждый пользователь

Проверить гипотезы:
- тратят ли пользователи с подпиской больше времени на поездки
- среднее расстояние, которое проезжают пользователи с подпиской за одну поездку, не превышает 3130 метров
- будет ли помесячная выручка от пользователей с подпиской по месяцам выше, чем выручка от пользователей без подписки
- какое минимальное количество промокодов нужно разослать, чтобы вероятность не выполнить план была примерно 5 %.

С помощью аппроксимации постройте примерный график распределения и оцените вероятность того, что уведомление откроют не более 399,5 тыс. пользователей.

### Данные
- данные о пользователях (users_go.csv)
- данные о поездках (rides_go.csv)
- данные о подписках (subscriptions_go.csv)

### Используемые библиотеки
pandas, numpy, matplotlib, scipy, stats, math