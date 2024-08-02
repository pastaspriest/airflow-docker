-- Все обновления в грейдах прописаны в таблице stg.udpated_grades (аналитики расписали, мы занесли в бд 1 раз и используем)

-- Формирую таблицу с "переводом", старыми id и номером таблицы
INSERT into ddl.grade_updates(old_grade_name, new_grade_name, grade_level, old_grade_id, grade_type)
-- education
select 
	old_grade
,	new_grade
,	grade_level
,	education_id as old_id
,	1 as grade_type
from stg.updated_grades ug
right join ods.education e
	on ug.old_grade = e.education_name
union all
-- grade
select 
	old_grade
,	new_grade
,	grade_level
,	grade_id as old_id
,	2 as grade_type
from stg.updated_grades ug
right join ods.grade g
	on ug.old_grade = g.grade_name
union all
-- industry
select 
	old_grade
,	new_grade
,	grade_level
,	industry_level_id as old_id
,	3 as grade_type
from stg.updated_grades ug
right join ods.industry_level il
	on ug.old_grade = il.industry_level_name
union all
-- subject
select 
	old_grade
,	new_grade
,	grade_level
,	subject_level_id as old_id
,	4 as grade_type
from stg.updated_grades ug
right join ods.subject_level sl
	on ug.old_grade = sl.subject_level_name
union all
--language
select 
	language_level_name as old_grade
,	substring(language_level_name, '..') as new_grade
,	CASE WHEN language_level_name LIKE 'A2%' THEN 2
            WHEN language_level_name LIKE 'B1%' THEN 3
            WHEN language_level_name LIKE 'B2%' THEN 4
            WHEN language_level_name LIKE 'C1%' THEN 5
            WHEN language_level_name LIKE 'C2%' THEN 6
            ELSE 1 END AS grade_level
,	language_level_id as old_id
,	5 as grade_type
from ODS.language_level
order by grade_type asc, grade_level asc;


-- Заполнение таблиц с грейдами 

INSERT INTO ddl.grade(grade_name, grade_id, grade_level)
    SELECT distinct on (new_grade_name) new_grade_name, new_grade_id, grade_level
    FROM ddl.grade_updates
    WHERE grade_type = 2
    ORDER BY new_grade_name ASC;

INSERT INTO ddl.subject_industry_level(subject_industry_level_name, subject_industry_level_id, subject_industry_level_grade)
    SELECT DISTINCT ON (new_grade_name) new_grade_name, new_grade_id, grade_level
    FROM ddl.grade_updates
    WHERE grade_type in (3, 4)
    ORDER BY new_grade_name ASC;

INSERT INTO ddl.education(education_name, education_id, education_grade)
    SELECT 
        DISTINCT ON (new_grade_name)
	    new_grade_name
    ,   new_grade_id
    ,   grade_level
    FROM ddl.grade_updates
    WHERE grade_type = 1
    ORDER BY new_grade_name, new_grade_id asc;

INSERT INTO ddl.language_level(language_level_name, language_level_id, language_level_grade)      
    SELECT DISTINCT on (new_grade_name) new_grade_name, new_grade_id, grade_level
    FROM ddl.grade_updates
    WHERE grade_type = 5
    ORDER BY new_grade_name ASC;

-- Очистка основных таблиц

CREATE TEMP TABLE IF NOT EXISTS tt_active_employees AS -- выделяем работающих сотрудников
    SELECT distinct employee_id
    FROM ODS.employee
    WHERE activity = 'Да';
------------------------------------------------- 
--  Таблицы database и employee_database
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (bd_id, bd_name)
        bd_name
    ,   bd_id
    FROM ODS.database
    WHERE bd_name IS NOT NULL AND bd_id IS NOT NULL
    ORDER BY bd_id, bd_name;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, bd_id, gu.new_grade_id)
        employee_id
    ,   bd_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_database_id
    FROM ODS.employee_database as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND bd_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_database_id IS NOT NULL
    ORDER BY employee_id, bd_id, gu.new_grade_id, date ASC;

UPDATE tt_temp_table_2 SET date = '2021-02-01'::date WHERE date = '2221-02-01';
UPDATE tt_temp_table_2 SET date = '2023-07-20'::date WHERE date = '2123-07-20';
UPDATE tt_temp_table_2 SET date = '2019-04-01'::date WHERE date = '2119-04-01';
DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'database' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."database" 
        WHERE bd_id NOT IN (SELECT bd_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_database' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_database" 
        WHERE employee_database_id NOT IN (SELECT employee_database_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_bd_id SERIAL;

INSERT INTO DDL.database(bd_name, bd_id)
SELECT bd_name, new_bd_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_database(employee_id, bd_id, grade_id, date) 
SELECT employee_id, t1.new_bd_id, t2.new_grade_id, date 
FROM tt_temp_table_2 AS t2
INNER JOIN tt_temp_table_1 AS t1
    ON t1.bd_id = t2.bd_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;


-------------------------------------------------
--  Таблицы programming_language и employee_programming_language
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (programming_language_id, programming_language_name)
        programming_language_name
    ,   programming_language_id
    FROM ODS.programming_language
    WHERE programming_language_name IS NOT NULL AND programming_language_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, programming_language_id, gu.new_grade_id)
        employee_id
    ,   programming_language_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_programming_language_id
    FROM ODS.employee_programming_language as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND programming_language_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_programming_language_id IS NOT NULL
    ORDER BY employee_id, programming_language_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'programming_language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."programming_language" 
        WHERE programming_language_id NOT IN (SELECT programming_language_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_programming_language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_programming_language" 
        WHERE employee_programming_language_id NOT IN (SELECT employee_programming_language_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_programming_language_id SERIAL;

INSERT INTO DDL.programming_language(programming_language_name, programming_language_id)
SELECT programming_language_name, new_programming_language_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_programming_language(employee_id, programming_language_id, grade_id, date) 
SELECT employee_id, t1.new_programming_language_id, t2.new_grade_id, date 
FROM tt_temp_table_2 AS t2
INNER JOIN tt_temp_table_1 AS t1
    ON t1.programming_language_id = t2.programming_language_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы industry и employee_industry
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (industry_id, industry_name)
        industry_name
    ,   industry_id
    FROM ODS.industry
    WHERE industry_name IS NOT NULL AND industry_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, industry_id, gu.new_grade_id)
        employee_id
    ,   industry_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_industry_id
    FROM ODS.employee_industry as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.industry_level_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND industry_id IS NOT NULL 
        AND industry_level_id IS NOT NULL
        AND employee_industry_id IS NOT NULL
    ORDER BY employee_id, industry_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'industry' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."industry" 
        WHERE industry_id NOT IN (SELECT industry_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_industry' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_industry" 
        WHERE employee_industry_id NOT IN (SELECT employee_industry_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_industry_id SERIAL;

INSERT INTO DDL.industry(industry_name, industry_id)
SELECT industry_name, new_industry_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_industry(employee_id, industry_id, industry_level_id, date) 
SELECT employee_id, t1.new_industry_id, t2.new_grade_id, date 
FROM tt_temp_table_2 AS t2
INNER JOIN tt_temp_table_1 AS t1
    ON t1.industry_id = t2.industry_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы subject и employee_subject
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (subject_id, subject_name)
        subject_name
    ,   subject_id
    FROM ODS.subject
    WHERE subject_name IS NOT NULL AND subject_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, subject_id, gu.new_grade_id)
        employee_id
    ,   subject_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_subject_id
    FROM ODS.employee_subject as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.subject_level_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND subject_id IS NOT NULL 
        AND subject_level_id IS NOT NULL
        AND employee_subject_id IS NOT NULL
    ORDER BY employee_id, subject_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'subject' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."subject" 
        WHERE subject_id NOT IN (SELECT subject_id FROM tt_temp_table_1)) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
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
    SELECT employee_id, t1.new_subject_id, new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.subject_id = t2.subject_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы education и employee_education
-------------------------------------------------
    
CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, eu.new_grade_id)
        employee_id
    ,   eu.new_grade_id
    ,   CASE WHEN year = 0 THEN extract(year from update_day)
            ELSE year END AS year
    ,   employee_education_id
    FROM ODS.employee_education t2
    LEFT JOIN ddl.grade_updates AS eu                           
        ON t2.education_id = eu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND education_id IS NOT NULL
        AND employee_education_id IS NOT NULL
    ORDER BY employee_id, eu.new_grade_id, year ASC;

DELETE FROM tt_temp_table_2 WHERE year IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_education' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (SELECT * FROM ods."employee_education" 
        WHERE employee_education_id NOT IN (SELECT employee_education_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)) t;

INSERT INTO DDL.employee_education(employee_id, education_id, year) 
    SELECT employee_id, new_grade_id, year 
    FROM tt_temp_table_2 AS t2;;

DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы instrument и employee_instrument
-------------------------------------------------

 CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (instrument_id, instrument_name)
        instrument_name
    ,   instrument_id
    FROM ODS.instrument
    WHERE instrument_name IS NOT NULL AND instrument_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, instrument_id, gu.new_grade_id)
        employee_id
    ,   instrument_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_instrument_id
    FROM ODS.employee_instrument as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND instrument_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_instrument_id IS NOT NULL
    ORDER BY employee_id, instrument_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'instrument' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."instrument" 
        WHERE instrument_id NOT IN (SELECT instrument_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_instrument' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_instrument" 
        WHERE employee_instrument_id NOT IN (SELECT employee_instrument_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_instrument_id SERIAL;

INSERT INTO DDL.instrument(instrument_name, instrument_id)
    SELECT instrument_name, new_instrument_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_instrument(employee_id, instrument_id, grade_id, date) 
    SELECT employee_id, t1.new_instrument_id, t2.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.instrument_id = t2.instrument_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы platform и employee_platform
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (platform_id, platform_name)
        platform_name, platform_id
    FROM ODS.platform
    WHERE platform_name IS NOT NULL AND platform_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, platform_id, gu.new_grade_id)
        employee_id
    ,   platform_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_platform_id
    FROM ODS.employee_platform as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND platform_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_platform_id IS NOT NULL
    ORDER BY employee_id, platform_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'platform' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."platform" 
        WHERE platform_id NOT IN (SELECT platform_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_platform' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_platform" 
        WHERE employee_platform_id NOT IN (SELECT employee_platform_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_platform_id SERIAL;

INSERT INTO DDL.platform(platform_name, platform_id)
    SELECT platform_name, new_platform_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_platform(employee_id, platform_id, grade_id, date) 
    SELECT employee_id, t1.new_platform_id, t2.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.platform_id = t2.platform_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы ide и employee_ide
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (ide_id, ide_name)
        ide_name, ide_id
    FROM ODS.ide
    WHERE ide_name IS NOT NULL AND ide_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, ide_id, gu.new_grade_id)
        employee_id
    ,   ide_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_ide_id
    FROM ODS.employee_ide as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND ide_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_ide_id IS NOT NULL
    ORDER BY employee_id, ide_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'ide' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."ide" 
        WHERE ide_id NOT IN (SELECT ide_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_ide' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_ide" 
        WHERE employee_ide_id NOT IN (SELECT employee_ide_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_ide_id SERIAL;

INSERT INTO DDL.ide(ide_name, ide_id)
    SELECT ide_name, new_ide_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_ide(employee_id, ide_id, grade_id, date) 
    SELECT employee_id, t1.new_ide_id, t2.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.ide_id = t2.ide_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы technology и employee_technology
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (technology_id, technology_name)
        technology_name
    ,   technology_id
    FROM ODS.technology
    WHERE technology_name IS NOT NULL AND technology_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, technology_id, gu.new_grade_id)
        employee_id
    ,   technology_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_technology_id
    FROM ODS.employee_technology as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND technology_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_technology_id IS NOT NULL
    ORDER BY employee_id, technology_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'technology' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."technology" 
        WHERE technology_id NOT IN (SELECT technology_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_technology' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_technology" 
        WHERE employee_technology_id NOT IN (SELECT employee_technology_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_technology_id SERIAL;

INSERT INTO DDL.technology(technology_name, technology_id)
    SELECT technology_name, new_technology_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_technology(employee_id, technology_id, grade_id, date) 
    SELECT employee_id, t1.new_technology_id, t2.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.technology_id = t2.technology_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы system_type и employee_system_type
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (system_type_id, system_type_name)
        system_type_name
    ,   system_type_id
    FROM ODS.system_type
    WHERE system_type_name IS NOT NULL AND system_type_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, system_type_id, gu.new_grade_id)
        employee_id
    ,   system_type_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_system_type_id
    FROM ODS.employee_system_type as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND system_type_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_system_type_id IS NOT NULL
    ORDER BY employee_id, system_type_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'system_type' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."system_type" 
        WHERE system_type_id NOT IN (SELECT system_type_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_system_type' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_system_type" 
        WHERE employee_system_type_id NOT IN (SELECT employee_system_type_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_system_type_id SERIAL;

INSERT INTO DDL.system_type(system_type_name, system_type_id)
    SELECT system_type_name, new_system_type_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_system_type(employee_id, system_type_id, grade_id, date) 
    SELECT employee_id, t1.new_system_type_id, t2.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.system_type_id = t2.system_type_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы framework и employee_framework
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (framework_id, framework_name)
        framework_name
    ,   framework_id
    FROM ODS.framework
    WHERE framework_name IS NOT NULL AND framework_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, framework_id, gu.new_grade_id)
        employee_id
    ,   framework_id
    ,   gu.new_grade_id
    ,   COALESCE(date, update_day) AS date
    ,   employee_framework_id
    FROM ODS.employee_framework as t2
    LEFT JOIN ddl.grade_updates AS gu
        ON t2.grade_id = gu.old_grade_id
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND framework_id IS NOT NULL 
        AND grade_id IS NOT NULL
        AND employee_framework_id IS NOT NULL
    ORDER BY employee_id, framework_id, gu.new_grade_id, date ASC;

DELETE FROM tt_temp_table_2 WHERE date IS NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'framework' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."framework" 
        WHERE framework_id NOT IN (SELECT framework_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_framework' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_framework" 
        WHERE employee_framework_id NOT IN (SELECT employee_framework_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

ALTER TABLE tt_temp_table_1 ADD COLUMN new_framework_id SERIAL;

INSERT INTO DDL.framework(framework_name, framework_id)
    SELECT framework_name, new_framework_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_framework(employee_id, framework_id, grade_id, date) 
    SELECT employee_id, t1.new_framework_id, t2.new_grade_id, date 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.framework_id = t2.framework_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицы language и employee_language
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT ON (language_id, language_name)
        language_name
    ,   language_id
    FROM ODS.language
    WHERE language_name IS NOT NULL AND language_id IS NOT NULL;

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_2 AS
    SELECT 
        DISTINCT ON (employee_id, language_id, language_level_id)
        employee_id
    ,   language_id
    ,   language_level_id
    ,   employee_language_id
    FROM ODS.employee_language
    WHERE 1=1
        AND employee_id IN (select employee_id from tt_active_employees)
        AND employee_id IS NOT NULL 
        AND language_id IS NOT NULL 
        AND language_level_id IS NOT NULL
        AND employee_language_id IS NOT NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."language" 
        WHERE language_id NOT IN (SELECT language_id FROM tt_temp_table_1)
    ) t;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee_language' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee_language" 
        WHERE employee_language_id NOT IN (SELECT employee_language_id FROM tt_temp_table_2) -- employee работает, но строки нет
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;


ALTER TABLE tt_temp_table_1 ADD COLUMN new_language_id SERIAL;

INSERT INTO DDL.language(language_name, language_id)
    SELECT language_name, new_language_id FROM tt_temp_table_1;

INSERT INTO DDL.employee_language(employee_id, language_id, language_level_id) 
    SELECT employee_id, t1.new_language_id, t3.new_grade_id 
    FROM tt_temp_table_2 AS t2
    INNER JOIN tt_temp_table_1 AS t1
        ON t1.language_id = t2.language_id
    LEFT JOIN DDL.grade_updates AS t3
        ON t2.language_level_id = t3.old_grade_id;

DROP table tt_temp_table_1;
DROP table tt_temp_table_2;

-------------------------------------------------
--  Таблицa employee
-------------------------------------------------

CREATE TEMP TABLE IF NOT EXISTS tt_temp_table_1 AS
    SELECT 
        DISTINCT t1.employee_id
    ,   fd.department
    ,   t1.activity
    ,   g.full_name as fullname
    ,   UPPER(LEFT(t1.position, 1)) || RIGHT(t1.position, LENGTH(t1.position) - 1) as position
    ,   dp.pic_url AS picture_url
    FROM ODS.employee as t1
    LEFT JOIN stg.generated_names as g
        ON t1.employee_id = g.employee_id
    LEFT JOIN stg.fixed_departments fd
	    ON t1.department = fd.old_department_name
    LEFT JOIN stg.department_pictures as dp
        ON fd.department = dp.department
    WHERE 1=1
        AND t1.employee_id IN (select employee_id from tt_active_employees)
        AND t1.employee_id IS NOT NULL 
        AND t1.activity IS NOT NULL 
        AND t1.position IS NOT NULL
        AND t1.position <> '-'
        AND g.full_name IS NOT NULL;

INSERT INTO stg.error(run_date, table_name,	filtered_rows)
SELECT 
    current_date AS run_date
,   'employee' AS table_name
,    row_to_json(t) filtered_rows 
    FROM 
    (
        SELECT * FROM ods."employee" 
        WHERE 1=1
            AND employee_id NOT IN (SELECT employee_id FROM tt_temp_table_1)
            AND employee_id IN (select employee_id from tt_active_employees)
    ) t;

INSERT INTO DDL.employee(employee_id, department, activity, fullname, position, picture_url) 
    SELECT 
        employee_id
    ,   department
    ,   activity
    ,   fullname
    ,   position
    ,   picture_url
    FROM tt_temp_table_1 as t1;
    

DROP table tt_temp_table_1;
-- удаление временной таблицы с работающими сотрудниками
DROP table tt_active_employees;