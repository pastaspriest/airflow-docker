-- Таблица с ошибками 
CREATE TABLE IF NOT EXISTS ods.error(
	run_date date,
    table_name TEXT,
	filtered_rows JSON
);
------------------------------------------------Создание таблиц с обновлениями (чтобы было четко видно что на что обновили)
CREATE TABLE IF NOT EXISTS ddl.education_updates(
    old_education_name TEXT,
    new_education_name TEXT,
    old_education_id int4,
    grade_level int4
--    new_education_id SERIAL 
);

INSERT INTO ddl.education_updates(old_education_name, new_education_name, old_education_id, grade_level)
SELECT 
    education_name AS old_education_name
,   CASE WHEN education_id IN (76387, 148153, 148155, 148156, 175357,
                    175360, 175361, 175362, 175364, 175365, 177799, 177801,
                    177803, 177804, 177805, 177806, 188726) THEN 'Высшее'
         WHEN education_id IN (148157, 148158, 177798, 177802, 200362) THEN 'Среднее профессиональное'
         WHEN education_id IN (148161, 177800, 262859) THEN 'Среднее общее'
        ELSE 'Переподготовка' end AS new_education_name
,   education_id AS old_education_id
,   CASE WHEN education_id IN (76387, 148153, 148155, 148156, 175357,
                    175360, 175361, 175362, 175364, 175365, 177799, 177801,
                    177803, 177804, 177805, 177806, 188726) THEN 3
         WHEN education_id IN (148157, 148158, 177798, 177802, 200362) THEN 2
         WHEN education_id IN (148161, 177800, 262859) THEN 1
        ELSE 4 end AS grade_level
FROM ods.education;
-------------------------------------------------- Создание таблицы изменений грейдов, мб положить в создание слоя
CREATE TABLE IF NOT EXISTS ddl.grade_updates(
    old_grade_name TEXT,
    new_grade_name TEXT,
    old_grade_id int4,
    grade_level int4,
    new_grade_id int4
);

CREATE TEMP TABLE IF NOT EXISTS tt_grade_manipulation AS 
select 'Novice' as grade_name;

insert into tt_grade_manipulation
values 
('Junior'),
('Middle'),
('Senior'),
('Expert'),
('Знаком'),
('Знаком и могу применить'),
('Знаком, могу применить и реализовать');

alter table tt_grade_manipulation add column grade_id Serial;

INSERT INTO ddl.grade_updates(old_grade_name, new_grade_name, old_grade_id, grade_level, new_grade_id)
select
	old_grade_name
,	new_grade_name
,	old_grade_id
,	grade_encoding
,   tt.grade_id AS new_grade_id
from (SELECT 
    grade_name as old_grade_name
,    CASE WHEN grade_name = 'Использовал на проекте' THEN 'Junior'
        ELSE grade_name end AS new_grade_name
,   grade_id as old_grade_id
,   CASE WHEN grade_name = 'Novice' THEN 1
        WHEN grade_name = 'Junior' THEN 2
        WHEN grade_name = 'Использовал на проекте' THEN 2
        WHEN grade_name = 'Middle' THEN 3
        WHEN grade_name = 'Senior' THEN 4
        WHEN grade_name = 'Expert' THEN 5
        ELSE 0 END AS grade_encoding
FROM ods.grade) as g
LEFT JOIN tt_grade_manipulation as tt
ON g.new_grade_name = tt.grade_name;

INSERT INTO ddl.grade_updates(old_grade_name, new_grade_name, old_grade_id, grade_level, new_grade_id)
select
	old_grade_name
,	new_grade_name
,	old_grade_id
,	grade_encoding
,   tt.grade_id AS new_grade_id
from 
(SELECT 
    industry_level_name as old_grade_name
,    CASE WHEN industry_level_name = 'Я знаю специфику отрасли' THEN 'Знаком'
        WHEN industry_level_name = 'Я знаю специфику отрасли и переложил это на систему' THEN 'Знаком и могу применить'
        WHEN industry_level_name = 'Я знаю специфику отрасли, могу переложить на систему, убедить клиента и реализовать' THEN 'Знаком, могу применить и реализовать'
        ELSE industry_level_name end AS new_grade_name
,   industry_level_id as old_grade_id
,   CASE WHEN industry_level_name = 'Я знаю специфику отрасли' THEN 1
        WHEN industry_level_name = 'Я знаю специфику отрасли и переложил это на систему' THEN 2
        WHEN industry_level_name = 'Я знаю специфику отрасли, могу переложить на систему, убедить клиента и реализовать' THEN 3
        ELSE 0 END AS grade_encoding
FROM ods.industry_level) as ind
LEFT JOIN tt_grade_manipulation as tt
ON ind.new_grade_name = tt.grade_name;

INSERT INTO ddl.grade_updates(old_grade_name, new_grade_name, old_grade_id, grade_level, new_grade_id)
select
	old_grade_name
,	new_grade_name
,	old_grade_id
,	grade_encoding
,   tt.grade_id AS new_grade_id
from 
(SELECT 
    subject_level_name as old_grade_name
,    CASE WHEN subject_level_name = 'Я знаю предметную область' THEN 'Знаком'
        WHEN subject_level_name = 'Я знаю все особенности предметной области и могу переложить это на систему' THEN 'Знаком и могу применить'
        WHEN subject_level_name = 'Я знаю специфику предметной области, могу переложить на систему, убедить клиента и реализовать' THEN 'Знаком, могу применить и реализовать'
        ELSE subject_level_name end AS new_grade_name
,   subject_level_id as old_grade_id
,   CASE WHEN subject_level_name = 'Я знаю предметную область' THEN 1
        WHEN subject_level_name = 'Я знаю все особенности предметной области и могу переложить это на систему' THEN 2
        WHEN subject_level_name = 'Я знаю специфику предметной области, могу переложить на систему, убедить клиента и реализовать' THEN 3
        ELSE 0 END AS grade_encoding
FROM ods.subject_level) as sub
LEFT JOIN tt_grade_manipulation as tt
ON sub.new_grade_name = tt.grade_name;

INSERT INTO ddl.grade(grade_name, grade_id, grade_level)
    SELECT DISTINCT new_grade_name, new_grade_id, grade_level
    FROM ddl.grade_updates
    WHERE new_grade_id <= 5
    ORDER BY new_grade_id ASC;

INSERT INTO ddl.subject_industry_level(subject_industry_level_name, subject_industry_level_id, subject_industry_level_grade)
    SELECT DISTINCT new_grade_name, new_grade_id, grade_level
    FROM ddl.grade_updates
    WHERE new_grade_id BETWEEN 6 AND 8
    ORDER BY new_grade_id ASC;

DROP table tt_grade_manipulation;
----------------------------------------------------------- Таблицы с обновлением грейдов уже есть, ниже только очистка

CREATE TEMP TABLE IF NOT EXISTS tt_active_employees AS -- выделяем работающих сотрудников
    SELECT distinct employee_id
    FROM ODS.employee
    WHERE activity = 'Да';
------------------------------------------------- 
--  Таблицы database и employee_database
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT bd_name, bd_id
    FROM ODS.database
    WHERE bd_name IS NOT NULL AND bd_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, bd_id, grade_id, COALESCE(date, update_day) AS date, employee_database_id
    FROM ODS.employee_database
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND bd_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_database_id IS NOT NULL;
UPDATE tt_temp_table_2 SET date = '2021-02-01'::date WHERE date = '2221-02-01';
UPDATE tt_temp_table_2 SET date = '2023-07-20'::date WHERE date = '2123-07-20';
UPDATE tt_temp_table_2 SET date = '2019-04-01'::date WHERE date = '2119-04-01';
DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'database' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."database" 
        WHERE bd_id NOT IN (SELECT bd_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_database' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_database" 
        WHERE employee_database_id NOT IN (SELECT employee_database_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_bd_id SERIAL;

INSERT INTO DDL.database(bd_name, bd_id)
    SELECT bd_name, new_bd_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_database(employee_id, bd_id, grade_id, date) 
    SELECT employee_id, t1.new_bd_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.bd_id = t2.bd_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;


-------------------------------------------------
--  Таблицы programming_language и employee_programming_language
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT programming_language_name, programming_language_id
    FROM ODS.programming_language
    WHERE programming_language_name IS NOT NULL AND programming_language_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, programming_language_id, grade_id, COALESCE(date, update_day) AS date, employee_programming_language_id
    FROM ODS.employee_programming_language
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND programming_language_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_programming_language_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'programming_language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."programming_language" 
        WHERE programming_language_id NOT IN (SELECT programming_language_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_programming_language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_programming_language" 
        WHERE employee_programming_language_id NOT IN (SELECT employee_programming_language_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_programming_language_id SERIAL;

INSERT INTO DDL.programming_language(programming_language_name, programming_language_id)
    SELECT programming_language_name, new_programming_language_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_programming_language(employee_id, programming_language_id, grade_id, date) 
    SELECT employee_id, t1.new_programming_language_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.programming_language_id = t2.programming_language_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы industry и employee_industry
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT industry_name, industry_id
    FROM ODS.industry
    WHERE industry_name IS NOT NULL AND industry_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, industry_id, industry_level_id, COALESCE(date, update_day) AS date, employee_industry_id
    FROM ODS.employee_industry
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND industry_id IS NOT NULL AND industry_level_id IS NOT NULL
        AND employee_industry_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'industry' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."industry" 
        WHERE industry_id NOT IN (SELECT industry_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_industry' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_industry" 
        WHERE employee_industry_id NOT IN (SELECT employee_industry_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_industry_id SERIAL;

INSERT INTO DDL.industry(industry_name, industry_id)
    SELECT industry_name, new_industry_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_industry(employee_id, industry_id, industry_level_id, date) 
    SELECT employee_id, t1.new_industry_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.industry_id = t2.industry_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.industry_level_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы subject и employee_subject
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT subject_name, subject_id
    FROM ODS.subject
    WHERE subject_name IS NOT NULL AND subject_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, subject_id, subject_level_id, COALESCE(date, update_day) AS date, employee_subject_id
    FROM ODS.employee_subject
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND subject_id IS NOT NULL AND subject_level_id IS NOT NULL
        AND employee_subject_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'subject' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."subject" 
        WHERE subject_id NOT IN (SELECT subject_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_subject' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_subject" 
        WHERE employee_subject_id NOT IN (SELECT employee_subject_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_subject_id SERIAL;

INSERT INTO DDL.subject(subject_name, subject_id)
    SELECT subject_name, new_subject_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_subject(employee_id, subject_id, subject_level_id, date) 
    SELECT employee_id, t1.new_subject_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.subject_id = t2.subject_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.subject_level_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы education и employee_education
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT DISTINCT new_education_name
    FROM ddl.education_updates
    WHERE new_education_name IS NOT NULL;
    
CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, education_id,
        CASE WHEN year = 0 THEN extract(year from update_day)
            ELSE year END AS year,
        employee_education_id
    FROM ODS.employee_education
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND education_id IS NOT NULL
        AND employee_education_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE year IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'education' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."education" 
        WHERE education_id NOT IN (SELECT education_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_education' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_education" 
        WHERE employee_education_id NOT IN (SELECT employee_education_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_education_id SERIAL;

INSERT INTO DDL.education(education_name, education_id, education_grade)
    SELECT t1.new_education_name, new_education_id, eu.grade_level
    FROM tt_temp_table_1 AS t1
    LEFT JOIN (select distinct new_education_name, grade_level from ddl.education_updates) AS eu
    ON t1.new_education_name = eu.new_education_name;

INSERT INTO DDL.employee_education(employee_id, education_id, year) 
    SELECT employee_id, t1.new_education_id, year 
    FROM tt_temp_table_2 AS t2
    LEFT JOIN ddl.education_updates AS eu                             ---- Очень сомнительная конструкция 
    ON t2.education_id = eu.old_education_id
    LEFT JOIN tt_temp_table_1 AS t1
    ON t1.new_education_name = eu.new_education_name;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы instrument и employee_instrument
-------------------------------------------------

 CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT instrument_name, instrument_id
    FROM ODS.instrument
    WHERE instrument_name IS NOT NULL AND instrument_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, instrument_id, grade_id, COALESCE(date, update_day) AS date, employee_instrument_id
    FROM ODS.employee_instrument
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND instrument_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_instrument_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'instrument' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."instrument" 
        WHERE instrument_id NOT IN (SELECT instrument_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_instrument' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_instrument" 
        WHERE employee_instrument_id NOT IN (SELECT employee_instrument_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_instrument_id SERIAL;

INSERT INTO DDL.instrument(instrument_name, instrument_id)
    SELECT instrument_name, new_instrument_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_instrument(employee_id, instrument_id, grade_id, date) 
    SELECT employee_id, t1.new_instrument_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.instrument_id = t2.instrument_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы platform и employee_platform
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT platform_name, platform_id
    FROM ODS.platform
    WHERE platform_name IS NOT NULL AND platform_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, platform_id, grade_id, COALESCE(date, update_day) AS date, employee_platform_id
    FROM ODS.employee_platform
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND platform_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_platform_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'platform' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."platform" 
        WHERE platform_id NOT IN (SELECT platform_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_platform' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_platform" 
        WHERE employee_platform_id NOT IN (SELECT employee_platform_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_platform_id SERIAL;

INSERT INTO DDL.platform(platform_name, platform_id)
    SELECT platform_name, new_platform_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_platform(employee_id, platform_id, grade_id, date) 
    SELECT employee_id, t1.new_platform_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.platform_id = t2.platform_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы ide и employee_ide
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT ide_name, ide_id
    FROM ODS.ide
    WHERE ide_name IS NOT NULL AND ide_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, ide_id, grade_id, COALESCE(date, update_day) AS date, employee_ide_id
    FROM ODS.employee_ide
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND ide_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_ide_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'ide' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."ide" 
        WHERE ide_id NOT IN (SELECT ide_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_ide' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_ide" 
        WHERE employee_ide_id NOT IN (SELECT employee_ide_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_ide_id SERIAL;

INSERT INTO DDL.ide(ide_name, ide_id)
    SELECT ide_name, new_ide_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_ide(employee_id, ide_id, grade_id, date) 
    SELECT employee_id, t1.new_ide_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.ide_id = t2.ide_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы technology и employee_technology
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT technology_name, technology_id
    FROM ODS.technology
    WHERE technology_name IS NOT NULL AND technology_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, technology_id, grade_id, COALESCE(date, update_day) AS date, employee_technology_id
    FROM ODS.employee_technology
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND technology_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_technology_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'technology' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."technology" 
        WHERE technology_id NOT IN (SELECT technology_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_technology' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_technology" 
        WHERE employee_technology_id NOT IN (SELECT employee_technology_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_technology_id SERIAL;

INSERT INTO DDL.technology(technology_name, technology_id)
    SELECT technology_name, new_technology_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_technology(employee_id, technology_id, grade_id, date) 
    SELECT employee_id, t1.new_technology_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.technology_id = t2.technology_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы system_type и employee_system_type
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT system_type_name, system_type_id
    FROM ODS.system_type
    WHERE system_type_name IS NOT NULL AND system_type_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, system_type_id, grade_id, COALESCE(date, update_day) AS date, employee_system_type_id
    FROM ODS.employee_system_type
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND system_type_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_system_type_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'system_type' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."system_type" 
        WHERE system_type_id NOT IN (SELECT system_type_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_system_type' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_system_type" 
        WHERE employee_system_type_id NOT IN (SELECT employee_system_type_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_system_type_id SERIAL;

INSERT INTO DDL.system_type(system_type_name, system_type_id)
    SELECT system_type_name, new_system_type_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_system_type(employee_id, system_type_id, grade_id, date) 
    SELECT employee_id, t1.new_system_type_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.system_type_id = t2.system_type_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы framework и employee_framework
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT framework_name, framework_id
    FROM ODS.framework
    WHERE framework_name IS NOT NULL AND framework_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, framework_id, grade_id, COALESCE(date, update_day) AS date, employee_framework_id
    FROM ODS.employee_framework
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND framework_id IS NOT NULL AND grade_id IS NOT NULL
        AND employee_framework_id IS NOT NULL;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'framework' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."framework" 
        WHERE framework_id NOT IN (SELECT framework_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_framework' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_framework" 
        WHERE employee_framework_id NOT IN (SELECT employee_framework_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_framework_id SERIAL;

INSERT INTO DDL.framework(framework_name, framework_id)
    SELECT framework_name, new_framework_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_framework(employee_id, framework_id, grade_id, date) 
    SELECT employee_id, t1.new_framework_id, g.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.framework_id = t2.framework_id
    LEFT JOIN ddl.grade_updates AS g
    ON t2.grade_id = g.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы language и employee_language
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT language_name, language_id
    FROM ODS.language
    WHERE language_name IS NOT NULL AND language_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT employee_id, language_id, language_level_id, employee_language_id
    FROM ODS.employee_language
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND language_id IS NOT NULL AND language_level_id IS NOT NULL
        AND employee_language_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_3 AS
    SELECT language_level_name, language_level_id
    ,   CASE WHEN language_level_name LIKE 'A2%' THEN 2
            WHEN language_level_name LIKE 'B1%' THEN 3
            WHEN language_level_name LIKE 'B2%' THEN 4
            WHEN language_level_name LIKE 'C1%' THEN 5
            WHEN language_level_name LIKE 'C2%' THEN 6
            ELSE 1 END AS language_level_grade
    FROM ODS.language_level
    WHERE language_level_name IS NOT NULL AND language_level_id IS NOT NULL;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."language" 
        WHERE language_id NOT IN (SELECT language_id FROM tt_temp_table_1)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_language" 
        WHERE employee_language_id NOT IN (SELECT employee_language_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'language_level' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."language_level" 
        WHERE language_level_id NOT IN (SELECT language_level_id FROM tt_temp_table_3)) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_language_id SERIAL;
ALTER TABLE tt_temp_table_3 ADD COLUMN new_language_level_id SERIAL;

INSERT INTO DDL.language(language_name, language_id)
    SELECT language_name, new_language_id FROM tt_temp_table_1;

INSERT INTO DDL.language_level(language_level_name, language_level_id, language_level_grade)
    SELECT language_level_name, new_language_level_id, language_level_grade FROM tt_temp_table_3;

INSERT INTO DDL.employee_language(employee_id, language_id, language_level_id) 
    SELECT employee_id, t1.new_language_id, t3.new_language_level_id 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
    ON t1.language_id = t2.language_id
    LEFT JOIN tt_temp_table_3 AS t3
    ON t2.language_level_id = t3.language_level_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;
DROP table tt_temp_table_3;

-------------------------------------------------
--  Таблица resume (общим решением не переносится в ddl)
-------------------------------------------------

--CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
--    SELECT employee_id, resume_id
--    FROM ODS.resume
--    WHERE employee_id IS NOT NULL AND resume_id IS NOT NULL;

--INSERT INTO ods.error(run_date, table_name,	filtered_rows)
--SELECT 
--    current_date AS run_date
--,   'resume' AS table_name
--,    row_to_json(t) filtered_rows 
--   FROM 
--    (SELECT * FROM ods."resume" 
--        WHERE resume_id NOT IN (SELECT resume_id FROM tt_temp_table_1)) t;

--INSERT INTO DDL.resume(employee_id, resume_id)
--    SELECT * FROM tt_temp_table_1;

-------------------------------------------------
--  Таблицa employee
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT employee_id, department, activity, name, surname, position
    FROM ODS.employee
    WHERE employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL AND activity IS NOT NULL AND position IS NOT NULL
        AND position <> '-';

INSERT INTO ods.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee" 
        WHERE employee_id NOT IN (SELECT employee_id FROM tt_temp_table_1)
            AND employee_id IN (select employee_id from tt_active_employees)) t;

INSERT INTO DDL.employee(employee_id, department, activity, name, surname, position) 
    SELECT *
    FROM tt_temp_table_1;

DROP table tt_temp_table_1;
-- удаление временной таблицы с работающими сотрудниками
DROP table tt_active_employees;