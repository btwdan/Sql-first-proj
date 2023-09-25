-- Создание таблиц --

CREATE TABLE orderpz (
    order_num SERIAL PRIMARY KEY,
    name_or VARCHAR(150),
    kolvo NUMERIC(20)
);

CREATE TABLE menu (
    id_menu SERIAL PRIMARY KEY,
    name_bl VARCHAR(150),
    price NUMERIC(4)
);

CREATE TABLE employment (
    passport SERIAL PRIMARY KEY,
    data_tr DATE,
    FIO_emp VARCHAR(109),
    medical_certificate NUMERIC(11)
);

CREATE TABLE cheque (
    num_cheque SERIAL PRIMARY KEY,
    summa NUMERIC(10),
    data_ch DATE,
    order_num INTEGER,
    CONSTRAINT o_ch FOREIGN KEY (order_num) REFERENCES orderpz(order_num)
);

CREATE TABLE accountant (
    pasport_bukh SERIAL PRIMARY KEY,
    FIO_bukh VARCHAR(100),
    data_priem DATE,
    num_cheque INTEGER,
    CONSTRAINT c_a FOREIGN KEY (num_cheque) REFERENCES cheque(num_cheque)
);

CREATE TABLE client (
    bonus_order SERIAL PRIMARY KEY,
    payment VARCHAR(30),
    order_num INTEGER,
    CONSTRAINT o_c FOREIGN KEY (order_num) REFERENCES orderpz(order_num)
);

CREATE TABLE orderpz_menu (
    order_nume INTEGER,
    id_menue INTEGER,
    CONSTRAINT o_m FOREIGN KEY (order_nume) REFERENCES orderpz (order_num),
    CONSTRAINT d_o_m FOREIGN KEY (id_menue) REFERENCES menu (id_menu),
    CONSTRAINT pr PRIMARY KEY (order_nume, id_menue)
);

CREATE TABLE order_employment (
    order_numer INTEGER,
    passportr INTEGER,
    CONSTRAINT e_em FOREIGN KEY (order_numer) REFERENCES orderpz (order_num),
    CONSTRAINT d_o_em FOREIGN KEY (passportr) REFERENCES employment (passport),
    CONSTRAINT pri PRIMARY KEY (order_numer, passportr)
);


-- Заполнение таблиц

--  Заполнение таблицы orderpz
INSERT INTO orderpz (name_or, kolvo) VALUES
    ('Заказ по русски', 5),
    ('Заказ по иностраному', 10),
    ('Заморский заказ', 7);

--  Заполнение таблицы menu
INSERT INTO menu (name_bl, price) VALUES
    ('Pizza peperoni', 399.89),
    ('Pizza with meat', 478.99),
    ('Pizza with sausage', 349.39),
    ('Pizza hawai', 409.87),
    ('Pizza nutella', 445.45),
    ('Pizza with mashrooms', 323.23),
    ('Pizza vegatariana', 570.99),
    ('pizza margorita', 330.99);

--  Заполнение таблицы employment
INSERT INTO employment (data_tr, FIO_emp, medical_certificate) VALUES
    ('2023-09-20', 'Sazonov Daniil Timurovich', 12345678901),
    ('2023-12-21', 'Tikhonov Artur Eduardovich', 23456789012),
    ('2023-10-21', 'Gofurov Islombek Elmurod-ugly', 23456789013),
    ('2023-11-21', 'Minegareev Timur Ruslanovich', 23456789014),
    ('2023-08-22', 'Abdulin Raul Rustemovich', 34567890125);

--  Заполнение таблицы cheque
INSERT INTO cheque (summa, data_ch, order_num) VALUES
    (50.00, '2023-09-20', 7),
    (50.00, '2023-09-21', 8),
    (50.00, '2023-01-24', 9),
    (50.00, '2023-02-20', 7),
    (50.00, '2023-06-29', 8),
    (50.00, '2023-09-17', 9),
    (50.00, '2023-09-16', 7),
    (50.00, '2023-10-14', 8),
    (50.00, '2023-09-20', 9),
    (50.00, '2023-11-12', 7),
    (50.00, '2023-09-22', 8),
    (75.50, '2023-12-24', 9),
    (30.25, '2023-09-22', 8);

--  Заполнение таблицы accountant
INSERT INTO accountant (FIO_bukh, data_priem, num_cheque) VALUES
    ('Shermatov Aminjon Shawkatovich', '2023-09-20', 40),
    ('Ivanov Ivan Ivanovich', '2023-09-21', 52),
    ('Bugalterov Bugalter Bugalterovich', '2023-09-22', 43);

--  Заполнение таблицы client
INSERT INTO client (payment, order_num) VALUES
    ('Наличные', 7),
    ('Карта', 8),
    ('Карта', 9);

-- Заполнение таблицы orderpz_menu
INSERT INTO orderpz_menu (order_nume, id_menue) VALUES
    (7, 17),
    (7, 18),
    (8, 19),
    (8, 20),
    (9, 21),
    (9, 22);

-- Заполнение таблицы order_employment
INSERT INTO order_employment (order_numer, passportr) VALUES
    (7, 11),
    (7, 12),
    (8, 14),
    (8, 13),
    (9, 13),
    (9, 14),
    (7, 15),
    (9, 11);

-- Запросы --

select * from orderpz;
select * from menu;
select * from employment;
select * from cheque;
select * from accountant;
select * from Client;
select * from orderpz_menu;
select * from order_employment;

-- Операции с ценами
select sum(price) from menu;
select min(price) from menu;
select max(price) from menu;
select avg(price) from menu;
select round(avg(price)) from menu;

-- Список всех заказов с информацией о блюдах и сумме заказа:
SELECT op.order_num, op.name_or, SUM(m.price * op.kolvo) as total_price
FROM orderpz op
JOIN orderpz_menu om ON op.order_num = om.order_nume
JOIN menu m ON om.id_menue = m.id_menu
GROUP BY op.order_num, op.name_or;

-- Средний чек по заказам:
SELECT op.order_num, op.name_or, AVG(c.summa) as avg_cheque
FROM orderpz op
JOIN cheque c ON op.order_num = c.order_num
GROUP BY op.order_num, op.name_or;

-- Список сотрудников с количеством заказов и общей суммой заказов:
SELECT e.FIO_emp, COUNT(oe.order_numer) as total_orders, SUM(m.price * op.kolvo) as total_price
FROM employment e
JOIN order_employment oe ON e.passport = oe.passportr
JOIN orderpz op ON oe.order_numer = op.order_num
JOIN orderpz_menu om ON op.order_num = om.order_nume
JOIN menu m ON om.id_menue = m.id_menu
GROUP BY e.FIO_emp;

-- Список клиентов с общей суммой потраченных денег:
SELECT c.payment, SUM(m.price * op.kolvo) as total_spent
FROM Client c
JOIN orderpz op ON c.order_num = op.order_num
JOIN orderpz_menu om ON op.order_num = om.order_nume
JOIN menu m ON om.id_menue = m.id_menu
GROUP BY c.payment;

-- Средняя сума по всем заказам: 
SELECT ROUND(AVG(c.summa)) as average_cheque
FROM cheque c;

-- Представления -- 

-- Представление для заказов с блюдами и их стоимостью:
CREATE VIEW order_menu_view AS
SELECT o.order_num, o.name_or, m.name_bl, m.price
FROM orderpz_menu om
JOIN orderpz o ON om.order_nume = o.order_num
JOIN menu m ON om.id_menue = m.id_menu;

-- Представление для чеков с суммой и датой заказа:
CREATE VIEW cheque_view AS
SELECT c.num_cheque, c.summa, c.data_ch, o.name_or
FROM cheque c
JOIN orderpz o ON c.order_num = o.order_num;

-- Представление для сотрудников с их данными:
CREATE VIEW employment_view AS
SELECT passport, data_tr, FIO_emp, medical_certificate
FROM employment;

-- Представление для данных о клиентах и связанных с ними заказах:
CREATE VIEW client_order_view AS
SELECT c.bonus_order, c.payment, o.name_or
FROM Client c
JOIN orderpz o ON c.order_num = o.order_num;

-- Представление для связи заказов с сотрудниками:
CREATE VIEW order_employment_view AS
SELECT oe.order_numer, e.FIO_emp
FROM order_employment oe
JOIN employment e ON oe.passportr = e.passport;

-- Процедуры --

-- Хранимая процедура для добавления нового заказа:
CREATE OR REPLACE PROCEDURE add_order (
    name_or_param varchar(150),
    kolvo_param numeric(20)
)
AS $$
BEGIN
    INSERT INTO orderpz (name_or, kolvo)
    VALUES (name_or_param, kolvo_param);
END;
$$ LANGUAGE plpgsql;
-- Пример испльзования:
CALL add_order('Новый заказ', 25);


-- Хранимая процедура для удаления заказа по номеру заказа:
CREATE OR REPLACE PROCEDURE delete_order (
    order_num_param numeric(10)
)
AS $$
BEGIN
    DELETE FROM orderpz
    WHERE order_num = order_num_param;
END;
$$ LANGUAGE plpgsql;
-- Пример использования:
CALL delete_order(3);


-- Хранимая процедура для добавления нового блюда в меню:
CREATE OR REPLACE PROCEDURE add_menu_item (
    name_bl_param varchar(150),
    price_param numeric(4)
)
AS $$
BEGIN
    INSERT INTO menu (name_bl, price)
    VALUES (name_bl_param, price_param);
END;
$$ LANGUAGE plpgsql;
-- Пример использования:
CALL add_menu_item('Новое блюдо', 300);


-- Хранимая процедура для удаления блюда из меню по его ID:
CREATE OR REPLACE PROCEDURE delete_menu_item (
    id_menu_param numeric(10)
)
AS $$
BEGIN
    DELETE FROM menu
    WHERE id_menu = id_menu_param;
END;
$$ LANGUAGE plpgsql;
-- Пример использования:
CALL delete_menu_item(4);


-- Хранимая процедура для добавления нового сотрудника:
CREATE OR REPLACE PROCEDURE add_employee (
    passport_param numeric(30),
    data_tr_param date,
    FIO_emp_param varchar(109),
    medical_certificate_param numeric(11)
)
AS $$
BEGIN
    INSERT INTO employment (passport, data_tr, FIO_emp, medical_certificate)
    VALUES (passport_param, data_tr_param, FIO_emp_param, medical_certificate_param);
END;
$$ LANGUAGE plpgsql;
-- Пример использования:
CALL add_employee(3456789012, '2023-09-25', 'Новый Сотрудник', 12345678901);


-- Хранимая процедура для удаления сотрудника по его паспорту:
CREATE OR REPLACE PROCEDURE delete_employee (
    passport_param numeric(30)
)
AS $$
BEGIN
    DELETE FROM employment
    WHERE passport = passport_param;
END;
$$ LANGUAGE plpgsql;
-- Пример использвания:
CALL delete_employee(2345673929);

-- Курсоры --

-- Курсор для вывода информации о заказах
CREATE OR REPLACE FUNCTION get_order_info() RETURNS SETOF orderpz AS $$
DECLARE
    order_record orderpz%ROWTYPE;
BEGIN
    FOR order_record IN SELECT * FROM orderpz LOOP
        RETURN NEXT order_record;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- Пример использования курсора для заказов
SELECT * FROM get_order_info();

-- Курсор для вывода информации о чеках
CREATE OR REPLACE FUNCTION get_cheque_info() RETURNS SETOF cheque AS $$
DECLARE
    cheque_record cheque%ROWTYPE;
BEGIN
    FOR cheque_record IN SELECT * FROM cheque LOOP
        RETURN NEXT cheque_record;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- Пример использования курсора для чеков
SELECT * FROM get_cheque_info();

-- Курсор для вывода информации о сотрудниках
CREATE OR REPLACE FUNCTION get_employment_info() RETURNS SETOF employment AS $$
DECLARE
    employment_record employment%ROWTYPE;
BEGIN
    FOR employment_record IN SELECT * FROM employment LOOP
        RETURN NEXT employment_record;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- Пример использования курсора для сотрудников
SELECT * FROM get_employment_info();

-- Курсор для вывода информации о меню
CREATE OR REPLACE FUNCTION get_menu_info() RETURNS SETOF menu AS $$
DECLARE
    menu_record menu%ROWTYPE;
BEGIN
    FOR menu_record IN SELECT * FROM menu LOOP
        RETURN NEXT menu_record;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- Пример использования курсора для меню
SELECT * FROM get_menu_info();

-- Тригеры --

-- Триггер для автоматического обновления суммы в чеке при добавлении нового заказа.
CREATE OR REPLACE FUNCTION update_cheque_summa()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE cheque
    SET summa = (
        SELECT COALESCE(SUM(price), 0)
        FROM orderpz_menu om
        JOIN menu m ON om.id_menue = m.id_menu
        WHERE om.order_nume = NEW.order_num
    )
    WHERE num_cheque = NEW.order_num;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_cheque_summa_trigger
AFTER INSERT ON orderpz_menu
FOR EACH ROW
EXECUTE FUNCTION update_cheque_summa();
