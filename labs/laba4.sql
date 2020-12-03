SET SERVEROUTPUT ON;

1. Создать процедуру, которая копирует строки с информацией об оборудовании указанного вида во вспомогательную таблицу и подсчитывает количество деталей,
 произведенных на данном оборудовании.
CREATE OR REPLACE PROCEDURE count_details_on_specific_equipment (
    eq_name in VARCHAR2,
    start_date in date,
    end_date in date default sysdate
 ) IS
    i int := 0;
    equipment_details equipment%ROWTYPE;
    cursor curs is
        select TC.volume, Eq.type, TC.working_date FROM Technology_card TC
        JOIN Schedule S ON TC.id_s = S.id_s
        JOIN Equipment Eq ON S.id_e = Eq.id_e
        WHERE Eq.type = eq_name AND TC.working_date BETWEEN start_date AND end_date;

    c curs%ROWTYPE;
BEGIN
SELECT * INTO equipment_details FROM equipment Eqd WHERE Eqd.type = eq_name;
dbms_output.put_line('Данные оборудования и количество обработанных деталей на '||eq_name||':');
dbms_output.put_line('Оборудование: '||eq_name||', Мощность: '||equipment_details.capacity||', Дата получения: '||equipment_details.recieving_date);

    open curs;
    fetch curs into c;
    while curs%FOUND
        loop
        dbms_output.put_line((i+1)||'. Дата: '||c.working_date||' Количество обработанных деталей: '||c.volume);
        i:= i + 1;
        fetch curs into c;
        end loop;
    close curs;
end count_details_on_specific_equipment;
/

execute count_details_on_specific_equipment('mechanical', TO_DATE('2018/01/01 10:00:00', 'yyyy/mm/dd hh24:mi:ss'))


2. Создать функцию, возвращающую количество рабочих в бригаде. Входной параметр функции – id бригады. Если в бригаде менее трех человек,
то обновить количество до пяти человек.

CREATE OR REPLACE FUNCTION countOfEmployeesInTeam(id in Integer)
    return integer
is
    result integer;
    begin
    select count (*) INTO result FROM Employee E WHERE E.id_t = id;
    IF result = 0 THEN RAISE NO_DATA_FOUND;
    ELSE return result;
    END IF;

    exception WHEN NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('В бригаде нет людей'); return result;
end countOfEmployeesInTeam;
/

DECLARE
amount integer;
BEGIN
amount := countOfEmployeesInTeam(1);
DBMS_OUTPUT.PUT_LINE(amount);
END;
/

3. Создать локальную программу, изменив код ранее написанной процедуры или функции.
CREATE OR REPLACE FUNCTION getEmployeesCountInfo
    RETURN VARCHAR2
    IS
        FUNCTION countOfEmployeesInTeam2
        return integer
        IS result integer;
        BEGIN
            SELECT COUNT (*) INTO result FROM Employee;
            return result;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE ('Сотудников нет');
        END countOfEmployeesInTeam2;

    BEGIN
        IF countOfEmployeesInTeam2 > 10 THEN
            return 'Сотрудников больше 10';
        ELSE return 'Сотрудников меньше 10';
        END IF;
    END getEmployeesCountInfo;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(getEmployeesCountInfo());
END;
/

4.	Написать перегруженные программы, используя для этого ранее созданную процедуру или функцию.
CREATE OR REPLACE FUNCTION countOfEmployeesInTeam (team_name VARCHAR2)
    return INTEGER
IS
    result INTEGER;
    ex EXCEPTION;
    is_exists INTEGER;

BEGIN
    SELECT COUNT (*) INTO is_exists FROM Team WHERE Team.name = team_name;

    IF is_exists = 0 THEN
        RAISE ex;
    ELSE
        SELECT COUNT (*) INTO result FROM Employee E WHERE E.id_t = (
            SELECT id_t FROM Team WHERE Team.name = team_name
        );
        RETURN result;
    END IF;

    EXCEPTION
        WHEN ex THEN DBMS_OUTPUT.PUT_LINE('Команды с именем '||team_name||' не существует');
    RETURN 0;
END;
/

DECLARE
amount integer;
BEGIN
amount := countOfEmployeesInTeam('best team');
DBMS_OUTPUT.PUT_LINE(amount);
END;
/

5. Объеденить в пакет
CREATE OR REPLACE PACKAGE operations AS
PROCEDURE count_details_on_specific_equipment (
    eq_name in VARCHAR2,
    start_date in date,
    end_date in date default sysdate
 );
FUNCTION countOfEmployeesInTeam (id in Integer)
    return integer;
FUNCTION getEmployeesCountInfo
    RETURN VARCHAR2;
FUNCTION countOfEmployeesInTeam (team_name VARCHAR2)
    return INTEGER;
end operations;
/

CREATE OR REPLACE PACKAGE BODY operations AS
PROCEDURE count_details_on_specific_equipment (
    eq_name in VARCHAR2,
    start_date in date,
    end_date in date default sysdate
 ) IS
    i int := 0;
    equipment_details equipment%ROWTYPE;
    cursor curs is
        select TC.volume, Eq.type, TC.working_date FROM Technology_card TC
        JOIN Schedule S ON TC.id_s = S.id_s
        JOIN Equipment Eq ON S.id_e = Eq.id_e
        WHERE Eq.type = eq_name AND TC.working_date BETWEEN start_date AND end_date;

    c curs%ROWTYPE;
BEGIN
SELECT * INTO equipment_details FROM equipment Eqd WHERE Eqd.type = eq_name;
dbms_output.put_line('Данные оборудования и количество обработанных деталей на '||eq_name||':');
dbms_output.put_line('Оборудование: '||eq_name||', Мощность: '||equipment_details.capacity||', Дата получения: '||equipment_details.recieving_date);

    open curs;
    fetch curs into c;
    while curs%FOUND
        loop
        dbms_output.put_line((i+1)||'. Дата: '||c.working_date||' Количество обработанных деталей: '||c.volume);
        i:= i + 1;
        fetch curs into c;
        end loop;
    close curs;
end count_details_on_specific_equipment;
FUNCTION countOfEmployeesInTeam(id in Integer)
    return integer
is
    result integer;
    begin
    select count (*) INTO result FROM Employee E WHERE E.id_t = id;
    return result;

    exception WHEN NO_DATA_FOUND then dbms_output.put_line('В бригаде нет людей');
end countOfEmployeesInTeam;
FUNCTION getEmployeesCountInfo
    RETURN VARCHAR2
    IS
        FUNCTION countOfEmployeesInTeam2
        return integer
        IS result integer;
        BEGIN
            SELECT COUNT (*) INTO result FROM Employee;
            return result;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE ('Сотудников нет');
        END countOfEmployeesInTeam2;

    BEGIN
        IF countOfEmployeesInTeam2 > 10 THEN
            return 'Сотрудников больше 10';
        ELSE return 'Сотрудников меньше 10';
        END IF;
    END getEmployeesCountInfo;
    FUNCTION countOfEmployeesInTeam (team_name VARCHAR2)
    return INTEGER
IS
    result INTEGER;
    ex EXCEPTION;
    is_exists INTEGER;

BEGIN
    SELECT COUNT (*) INTO is_exists FROM Team WHERE Team.name = team_name;

    IF is_exists = 0 THEN
        RAISE ex;
    ELSE
        SELECT COUNT (*) INTO result FROM Employee E WHERE E.id_t = (
            SELECT id_t FROM Team WHERE Team.name = team_name
        );
        RETURN result;
    END IF;

    EXCEPTION
        WHEN ex THEN DBMS_OUTPUT.PUT_LINE('Команды с именем '||team_name||' не существует');
    RETURN 0;
END;
end operations;
/

6. Проверить работу
begin
operations.count_details_on_specific_equipment('mechanical', TO_DATE('2018/01/01 10:00:00', 'yyyy/mm/dd hh24:mi:ss'));
DBMS_OUTPUT.put_line(operations.countOfEmployeesInTeam('best team'));
DBMS_OUTPUT.put_line(operations.countOfEmployeesInTeam('not_existing_team'));
DBMS_OUTPUT.put_line(operations.countOfEmployeesInTeam(1));
DBMS_OUTPUT.put_line(operations.countOfEmployeesInTeam(4));
end;
/


