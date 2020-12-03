// создать представление с информацией об офисах в Бресте
CREATE OR REPLACE VIEW Brest_Branch AS SELECT * FROM Branch WHERE city = 'Brest';

// создать представление  с информацией об объектах недвижимости минимальной стоимости
CREATE OR REPLACE VIEW Min_Price_Property AS SELECT * FROM Property_for_rent WHERE rent = (SELECT MIN(rent) FROM Property_for_rent);

// создать представление с информацией о количестве сделанных осмотров с комментариями
CREATE OR REPLACE VIEW Views_with_comments AS SELECT count(*) as Total From Viewving WHERE comment_o IS NOT NULL;

// создать представление со сведениями об отделениях с максимальным количеством работающих сотрудников
CREATE OR REPLACE VIEW max_employees_branch AS SELECT * FROM Branch WHERE bno IN (
SELECT bno FROM (SELECT bno, count(*) FROM staff GROUP BY bno HAVING count(*) = (SELECT MAX(num) FROM (SELECT bno, count(*) as num FROM staff GROUP BY bno)))
);

// со сведениями об арендаторах, желающих арендовать 3-комнатные квартиры в тех же городах (поле city), где они проживают (поле address); ?? substring //regexp
CREATE OR REPLACE VIEW same_city_rent AS SELECT DISTINCT R.fname, R.lname, R.tel_no, R.address FROM Renter R
JOIN Viewving V ON V.rno = R.rno
JOIN Property_for_rent PFR ON PFR.pno = V.pno WHERE exists (
SELECT city FROM Property_for_rent PFR WHERE SUBSTR(R.address, 1, LENGTH(PFR.city)) = PFR.city AND PFR.rooms = 3
);

// с информацией о сотрудниках и объектах, которые они предлагают в аренду в текущем квартале;
CREATE OR REPLACE VIEW staff_property_quarter AS SELECT DISTINCT S.fname, S.lname, S.dob, S.tel_no, S.position, PFR.city, PFR.street, PFR.rooms
FROM Staff S JOIN Branch B ON B.bno = S.bno
JOIN Property_for_rent PFR ON PFR.bno = B.bno
JOIN Viewving V ON V.pno = PFR.pno
WHERE TO_CHAR(V.date_o, 'q') = TO_CHAR(SYSDATE, 'q');

// с информацией о владельцах, чьи дома или квартиры осматривались потенциальными арендаторами более двух раз;
CREATE OR REPLACE VIEW Owners_property_2_views AS SELECT DISTINCT O.fname, O.lname, O.tel_no, O.address FROM Owner O
JOIN Property_for_rent PFR ON O.ono = PFR.ono
JOIN Viewving V ON PFR.pno = V.pno AND PFR.pno IN (SELECT pno FROM Viewving GROUP BY pno HAVING COUNT(rno) > 2);

// с информацией о собственниках с одинаковыми именами.
CREATE OR REPLACE VIEW Owners_with_same_name AS
SELECT lname, fname, tel_no FROM OWNER
WHERE fname IN (SELECT fname FROM OWNER GROUP BY fname HAVING COUNT(fname)>1);

// Горизонатльное изменяемое представление // with check option
CREATE OR REPLACE VIEW Employees_view AS SELECT * FROM Employee E where E.id_t in (SELECT id_t FROM Team) WITH CHECK OPTION;
Проверка
INSERT INTO Employee VALUES (4, 'Sergey', 'engineer', 1, TO_DATE('2000/02/27 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/02/27 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), '+375331119157', 2);
INSERT INTO Employee VALUES (5, 'Andrei', 'engineer', 1, TO_DATE('2000/02/27 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/02/27 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), '+22522219111', 10);


// вертикальное или смешанное необновляемое представление
CREATE OR REPLACE VIEW report AS SELECT S.start_time, S.end_time, T.name, P.type FROM Team T JOIN
Schedule S ON S.id_t = T.id_t JOIN
Process P on S.id_p = P.id_p;

// обновляемое представление для работы
CREATE OR REPLACE VIEW report_update AS SELECT * FROM Schedule
WHERE TO_CHAR(SYSDATE, 'HH24') < 18
AND TO_CHAR(SYSDATE, 'HH24') > 10
AND TO_CHAR(SYSDATE, 'DY') IN ('ПН','ВТ','СР','ЧТ','ПТ');
