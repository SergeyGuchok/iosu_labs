// Создание таблицы, содержащей данные об оффисах
CREATE TABLE Branch (bno INTEGER NOT NULL, street VARCHAR2(30), city VARCHAR2(15), tel_no VARCHAR2(13) UNIQUE, PRIMARY KEY(bno));

// Создание таблицы, содержащей данные о сотрудниках
CREATE TABLE Staff (
sno INTEGER NOT NULL, fname VARCHAR2(15), lname VARCHAR2(15), address VARCHAR2(30), tel_no VARCHAR2(13) UNIQUE,
position CHAR, sex VARCHAR2(6) CHECK (sex = 'male' OR sex = 'female'), dob DATE, salary INTEGER, bno INTEGER, PRIMARY KEY(sno), FOREIGN KEY (bno) REFERENCES Branch
);

// Создание таблицы, содержащей данные об объектах недвижимости
CREATE TABLE Property_for_rent (
pno INTEGER NOT NULL, street VARCHAR2(15), city VARCHAR2(15), type CHAR CHECK (type = 'h' OR type = 'f'), rooms INTEGER, rent INTEGER, ono INTEGER, sno INTEGER,
bno INTEGER, PRIMARY KEY(pno), FOREIGN KEY (ono) REFERENCES Owner, FOREIGN KEY (sno) REFERENCES Staff, FOREIGN KEY (bno) REFERENCES Branch
);

// Создание таблицы, содержащей данные о владельцах недвижимости
CREATE TABLE Owner (
ono INTEGER NOT NULL, fname VARCHAR2(15), lname VARCHAR2(15), address VARCHAR2(30), tel_no VARCHAR2(13) UNIQUE, PRIMARY KEY (ono)
);

// Создание таблицы, содержащей данные о арендаторах
CREATE TABLE Renter (
rno INTEGER NOT NULL, fname VARCHAR2(15), lname VARCHAR2(15), address VARCHAR2(30), tel_no VARCHAR2(13) UNIQUE,
pref_type CHAR CHECK (pref_type = 'h' OR pref_type = 'f'), max_rent INTEGER, bno INTEGER, PRIMARY KEY(rno), FOREIGN KEY (bno) REFERENCES Branch
);

// Создание таблицы, содержащей данне о просмотрах недвижимости
CREATE TABLE Viewving (
rno INTEGER, pno INTEGER, date_o DATE, comment_o LONG, FOREIGN KEY (rno) REFERENCES Renter, FOREIGN KEY (pno) REFERENCES Property_for_rent
);
ALTER TABLE Viewving ADD CONSTRAINT pk_viewving PRIMARY KEY (rno, pno);



// Добавление данных в таблицу Branch (отделение / оффис)
INSERT INTO Branch (bno, street, city, tel_no) VALUES (1, 'Partizanskaya, 15', 'Minsk', '+375336622432');

// Добавление данных в таблицу Staff (сотрудники)
INSERT INTO Staff (sno, fname, lname, address, tel_no, position, sex, dob, salary, bno) VALUES (1, 'Siarhei', 'Huchok', 'Minsk, Kedishko 5', '+375336349157', '1', 'male', TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'), 3000, 1);

// Добавление данных в табилцу Renter
INSERT INTO Renter (rno, fname, lname, address, tel_no, pref_type, max_rent, bno) VALUES (1, 'Guscha', 'Dzianis', 'Minsk, Pervomayskaya, 5', '+375333664561', 'h', 5000, 1);

// Добавление данных в табилцу Owner
INSERT INTO Owner (ono, fname, lname, address, tel_no) VALUES (1, 'Siarhei', 'Huchok', 'Minsk, Kedishko, 5', '+375336349157');

// Добавление данных в таблицу Property_for_rent
INSERT INTO Property_for_rent (pno, street, city, type, rooms, rent, ono, sno, bno) VALUES (1, 'Drujbi', 'Minsk', 'h', 2, 1000, 1, 1, 1);

// Добавление данных в таблицу Viewving
INSERT INTO Viewving (rno, pno, date_o, comment_o) VALUES (1, 1, TO_DATE('2020/09/02 17:00:00', 'yyyy/mm/dd hh24:mi:ss'), 'I checked that!');

// Создание синонима
CREATE SYNONYM object FOR Property_for_rent;

// Создание последовательности
CREATE SEQUENCE Staff_seq MINVALUE 10 START WITH 10 INCREMENT BY 5 CACHE 20;


// СВОИ ТАБЛИЦЫ
// Создание таблицы Technology Card
CREATE TABLE Technology_card (
id_c INTEGER NOT NULL, id_s INTEGER, working_date DATE, id_d INTEGER, volume integer, is_manufactured CHAR CHECK (is_manufactured = 'y' OR is_manufactured = 'n'),
PRIMARY KEY (id_c), FOREIGN KEY (id_s) REFERENCES Schedule, FOREIGN KEY (id_d) REFERENCES Detail
);

// Создание таблицы Детали
CREATE TABLE Detail (id_d INTEGER NOT NULL, detail_size VARCHAR2(10), quality VARCHAR2(10) CHECK (quality = 'good' OR quality = 'normal' OR quality = 'bad'), name VARCHAR2(20), PRIMARY KEY (id_d));

// Создание таблицы Schedule
CREATE TABLE Schedule (id_s INTEGER NOT NULL, start_time DATE, end_time DATE, load INTEGER CHECK (load = 1 OR load = 0.5), id_e INTEGER, id_p INTEGER, id_t INTEGER, PRIMARY KEY (id_s),
FOREIGN KEY (id_e) REFERENCES Equipment, FOREIGN KEY (id_p) REFERENCES Process, FOREIGN KEY (id_t) REFERENCES Team);

// Создание таблицы Team
CREATE TABLE Team (id_t INTEGER NOT NULL, name VARCHAR2(20), PRIMARY KEY (id_t));

// Создание таблицы Employee
CREATE TABLE Employee (id_empl INTEGER NOT NULL, name VARCHAR2(10), title VARCHAR2(20), load INTEGER, birth_date DATE, employment_date DATE, age VARCHAR2(3), phone_number VARCHAR2(13) UNIQUE,
id_t INTEGER, PRIMARY KEY (id_empl), FOREIGN KEY (id_t) REFERENCES Team);

// Создание таблицы Process
CREATE TABLE Process (id_p INTEGER NOT NULL, type VARCHAR(20), PRIMARY KEY (id_p));

// Создание таблицы Equipment
CREATE TABLE Equipment (id_e INTEGER NOT NULL, working_time INTEGER CHECK (working_time <= 10), type VARCHAR2(10), recieving_date DATE, capacity INTEGER, PRIMARY KEY (id_e));

// Создание последовательности для расписания
CREATE SEQUENCE Schedule_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 CACHE 20;

// Создание индекса для таблицы Employee
CREATE INDEX employee_index ON Employee

// Создание функции генерации следующего значения
CREATE FUNCTION get_schedule_id_value RETURN NUMBER IS
BEGIN RETURN Schedule_seq.nextval;
END;
/4

// INSERT ALL
INSERT ALL
	INTO Schedule VALUES (get_schedule_id_value, TO_DATE('2020/09/02 17:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/09/02 22:00:00', 'yyyy/mm/dd hh24:mi:ss'), 0.5, 1, 1, 1)
	INTO Schedule VALUES (get_schedule_id_value, TO_DATE('2020/09/02 17:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/09/02 22:00:00', 'yyyy/mm/dd hh24:mi:ss'), 1, 1, 1, 1)
	SELECT * FROM dual;


// Создание таблицы с auto generated id
CREATE TABLE Auto_generated_table (t_id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    name VARCHAR2(10),
    surname VARCHAR2(10)
);
