// Заполнение данными таблиц ЛР
INSERT INTO Branch VALUES (2, 'Vasnecova, 10', 'Minsk', '+375336621221')
INSERT INTO Branch VALUES (3, 'Kuybeshiva, 25', 'Minsk', '+375443212278')
INSERT INTO Branch VALUES (4, 'Kedishko, 41', 'Minsk', '+375291111111')
INSERT INTO Staff VALUES (3, 'Petr', 'Ivashenko', 'Minsk, Peramogi 10', '+375336688205', '1', 'male', TO_DATE('2000/10/11 21:02:44', 'yyyy/mm/dd hh24:mi:ss'), 5000, 4)
INSERT INTO Staff VALUES (4, 'Oleg', 'Valenkov', 'Minsk, Drujbi 21', '+375336688121', '3', 'male', TO_DATE('1998/12/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'), 1000, 2)
INSERT INTO Renter VALUES (2, 'Kovalev', 'Andrei', 'Minsk, Vishnevskaya, 21', '+375332222222', 'f', 2000, 2)
INSERT INTO Renter VALUES (3, 'Kurilo', 'Alex', 'Minsk, Mogilevskata, 10', '+375291111000', 'f', 1000, 3)
INSERT INTO Owner VALUES (3, 'Kentov', 'Maksim', 'Minsk, Dvenatsatogo, 12', '+375111111111')
INSERT INTO Owner VALUES (4, 'Siarhei', 'Huchok', 'Minsk, Kedishko, 5', '+375999999999')
INSERT INTO Property_for_rent VALUES (2, 'Kuleshova', 'Minsk', 'h', 4, 10000, 2, 3, 2)
INSERT INTO Property_for_rent VALUES (3, 'Kalvariyskaya', 'Minsk', 'h', 1, 2100, 3, 2, 1)
INSERT INTO Property_for_rent VALUES (5, 'Kalvariyskaya', 'Grodno', 'h', 3, 3100, 2, 3, 2)
INSERT INTO Property_for_rent VALUES (6, 'Kupalovskaya', 'Grodno', 'h', 2, 3500, 1, 1, 3)
INSERT INTO Viewving VALUES (2, 1, TO_DATE('2020/09/02 17:00:00', 'yyyy/mm/dd hh24:mi:ss'), 'That was hella good!')
INSERT INTO Viewving VALUES (3, 2, TO_DATE('2020/09/02 17:00:00', 'yyyy/mm/dd hh24:mi:ss'), 'Didn`t like :(')

// Заполнение данными своей БД
INSERT INTO Detail VALUES (1, 'big', 'good', 'bolt');
INSERT INTO Detail VALUES (2, 'normal', 'normal', 'gayka');
INSERT INTO Detail VALUES (3, 'small', 'bad', 'list');
INSERT INTO Equipment VALUES (1, 5, 'mechanical', TO_DATE('2020/05/05 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), 200);
INSERT INTO Equipment VALUES (2, 10, 'automatic', TO_DATE('2005/02/01 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), 100);
INSERT INTO Equipment VALUES (3, 10, 'automatic', TO_DATE('2018/12/10 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), 500);
INSERT INTO Process VALUES (2, 'clean');
INSERT INTO Process VALUES (3, 'kick');
INSERT INTO Team VALUES (2, 'not the best team');
INSERT INTO Employee VALUES (1,
'Sergey', 'engineer', 1, TO_DATE('2000/02/27 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/02/27 10:00:00', 'yyyy/mm/dd hh24:mi:ss'),
'20', '+375336349157', 2);
INSERT INTO Employee VALUES (2,
'Andrei', 'worker', 1, TO_DATE('2001/10/10 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/05/12 10:00:00', 'yyyy/mm/dd hh24:mi:ss'),
'20', '+375336231123', 1);
INSERT INTO Employee VALUES (3,
'Oleg', 'security', 1, TO_DATE('1998/10/10 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2019/05/12 10:00:00', 'yyyy/mm/dd hh24:mi:ss'),
'22', '+375331111123', null);
INSERT INTO Technology_card VALUES (1, 21, TO_DATE('2020/09/21 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), 2, 200, 'y');
INSERT INTO Technology_card VALUES (2, 22, TO_DATE('2020/09/22 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), 1, 400, 'y');
INSERT INTO Technology_card VALUES (3, 22, TO_DATE('2020/09/23 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), 2, 300, 'n');


// Определить, сколькими арендаторами и сколько объектов было осмотрено в течение последнего года.
SELECT
    count (DISTINCT rno) as renters_amount,
    count (DISTINCT pno) as Properties_amount
    FROM Viewving
    WHERE date_o >= TO_DATE('2020/04/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss');

// Создать список сотрудников, предлагающих объекты недвижимости в Минске.
SELECT DISTINCT fname, lname, tel_no
FROM Staff S, Property_for_rent P
WHERE P.sno=S.sno AND city = 'Minsk';

// Определить суммарную рентную стоимость объектов в Минске и объектов в Гродно. Вывести город и сумму.
SELECT city, SUM(rent) as total_rent FROM Property_for_rent WHERE city IN ('Minsk', 'Grodno') GROUP BY city;

// Вывести информацию о владельцах неминских квартир, количество квартир у которых превышает количество квартир любого минского владельца.
SELECT O.lname, O.fname, O.tel_no, COUNT(P.ono) FROM Owner O, Property_for_rent P
WHERE O.ono=P.ono and P.city != 'Minsk'
GROUP BY O.lname, O.fname, O.tel_no
HAVING COUNT(P.ono) >= all
(SELECT COUNT(P_S.ono) FROM owner O_S, Property_for_rent P_S
WHERE P_S.ono=O_S.ono AND P_S.city = 'Minsk'
GROUP BY(P_S.ono));


// Обновить одной командой информацию о максимальной рентной стоимости объектов, уменьшив стоимость квартир на 5 %, а стоимость домов увеличив на 7 %.
UPDATE Property_for_rent
SET rent = CASE
    WHEN (type = 'h')  THEN (1.07*rent)
    WHEN (type = 'f')  THEN (0.95*rent)
    ELSE (1*rent)
    END;

// Параметрический запрос поиска деталей высокого качества
SELECT id_d, detail_size, name FROM Detail WHERE quality = &good;

// Условный запрос (вывод команд, в которых меньше пяти человек)
SELECT T.name, COUNT (Em.id_t) FROM Team T, Employee Em
WHERE Em.id_t = T.id_T
GROUP BY T.name
HAVING COUNT(Em.id_t) <= 5;

// Запрос с использованием условия по полю с типом дата (вывод технологических кард моложе полу года)
SELECT id_s, working_date, volume, is_manufactured
FROM Technology_card
WHERE EXTRACT (MONTH FROM working_date) > 4;

// Итоговоый запрос (количество обработанных деталей хорошего качество за последние пол года)
SELECT TO_CHAR(working_date, 'q') as quarter, SUM(volume) as volume FROM Technology_card GROUP BY TO_CHAR(working_date, 'q') ORDER BY quarter;

// Запрос с внутренним соединением таблицы (Вывод данных сотрудников и название команды в которой они работают)
SELECT Employee.name as employee_name, title, load, birth_date, age, phone_number, Team.name as team_name FROM Employee JOIN Team ON Employee.id_t = Team.id_t;

// Запрос с внешним соединением таблицы (Вывод расписания со всеми данными) ??
SELECT Employee.name as employee_name, title, load, birth_date, age, phone_number, Team.name as team_name FROM Employee LEFT JOIN Team ON Employee.id_t = Team.id_t;

// C использованием предиката IN с подзапросом;
SELECT * FROM Employee WHERE Employee.id_t IN (SELECT id_t FROM Team WHERE name = 'best team');

// С использование NOT EXISTS (Вывод деталей, не используемых в технологических картах)
SELECT quality, name FROM Detail WHERE NOT EXISTS (SELECT * FROM Technology_card WHERE Technology_card.id_d = Detail.id_d);

// Юнион запрос
SELECT detail_size, quality, name FROM Detail WHERE quality = 'good' UNION SELECT detail_size, quality, name FROM Detail WHERE quality = 'normal';


