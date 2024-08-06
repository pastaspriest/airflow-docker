-- Заполнение dim_skills (таблица со всеми навыками)

-- database 1
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	bd_name AS skill_name
, 	bd_id AS skill_id
,	1 AS skill_type
,	1 AS grade_type
FROM ddl.database;

-- instrument 2
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	instrument_name AS skill_name
,	instrument_id AS skill_id
,	2 AS skill_type
,	1 AS grade_type
FROM ddl.instrument;

-- industry 3
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	industry_name AS skill_name
,	industry_id AS skill_id
,	3 AS skill_type
,	2 AS grade_type
FROM ddl.industry;

-- subject 4
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	subject_name AS skill_name
, 	subject_id AS skill_id
, 	4 AS skill_type
,	2 AS grade_type 
FROM ddl.subject;

-- platform 5
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	platform_name AS skill_name
, 	platform_id AS skill_id
, 	5 AS skill_type
,	1 AS grade_type 
FROM ddl.platform;

-- ide 6
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	ide_name AS skill_name
, 	ide_id AS skill_id
, 	6 AS skill_type
,	1 AS grade_type 
FROM ddl.ide;

-- technology 7
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	technology_name AS skill_name
, 	technology_id AS skill_id
, 	7 AS skill_type
,	1 AS grade_type 
FROM ddl.technology;

-- system_type 8
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	system_type_name AS skill_name
, 	system_type_id AS skill_id
, 	8 AS skill_type
, 	1 AS grade_type 
FROM ddl.system_type;

-- framework 9
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	framework_name AS skill_name
, 	framework_id AS skill_id
, 	9 AS skill_type
, 	1 AS grade_type 
FROM ddl.framework;

-- programming_language 10
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	programming_language_name AS skill_name
, 	programming_language_id AS skill_id
, 	10 AS skill_type
, 	1 AS grade_type 
FROM ddl.programming_language;

--language  11
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	language_name AS skill_name
, 	language_id AS skill_id
, 	11 AS skill_type
, 	4 AS grade_type 
FROM ddl.language;

--education 12
INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	education_name AS skill_name
, 	education_id AS skill_id
, 	12 AS skill_type
, 	3 AS grade_type 
FROM ddl.education;

-- Заполнение dim_employee (таблица со всеми сотрудниками + сгенерированные имена и исправ) 

INSERT INTO DM.dim_employee (employee_id, position, department, fullname, picture_url)
SELECT e.employee_id, e.position, e.department, e.fullname, e.picture_url FROM ddl.employee AS e;


-- Заполнение dim_date (таблица со всеми днями изучения навыков)
-- Тут через union чтобы все дни были уникальными
INSERT INTO  DM.dim_date (date,	calendar_year)
SELECT DISTINCT date AS date, calendar_year
FROM (
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_database
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_instrument
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_industry
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_subject
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_platform
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_ide
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_technology
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_system_type
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_framework
UNION
SELECT date, extract(year from date) AS calendar_year
FROM ddl.employee_programming_language
UNION
SELECT '2001-09-26'::date AS date, extract(year from '2001-09-26'::date) AS calendar_year -- стоит default дата для единообразия, не используется далее
) AS all_dates;   
--FROM ddl.employee_language					
--UNION
--SELECT '2001-09-26'::date AS date, extract(year from '2001-09-26'::date) AS calendar_year
--FROM ddl.employee_education


-- Заполнение dim_date (таблица со всеми уровнями навыков)

-- grade 1
INSERT INTO DM.dim_skill_level (skill_level_type, grade_name, skill_level_id, skill_grade, next_grade_level)
SELECT 
	1 AS skill_level_type
,	grade_name
,	grade_id
,	grade_level
,	lead(grade_name, 1, 'Max level') over (order by grade_level) AS next_grade_level
FROM ddl.grade;

-- subject_industry_level 2
INSERT INTO DM.dim_skill_level (skill_level_type, grade_name, skill_level_id, skill_grade, next_grade_level)
SELECT 
	2 AS skill_level_type
,	subject_industry_level_name
,	subject_industry_level_id
,	subject_industry_level_grade
,	lead(subject_industry_level_name, 1, 'Max level') over (order by subject_industry_level_grade) AS next_grade_level
FROM ddl.subject_industry_level;

-- education 3
INSERT INTO DM.dim_skill_level (skill_level_type, grade_name, skill_level_id, skill_grade, next_grade_level)
SELECT 
	3 AS skill_level_type
,	education_name
,	education_id
,	education_grade
,	lead(education_name, 1, 'Max level') over (order by education_grade) AS next_grade_level
FROM ddl.education;

-- language_level 4
INSERT INTO DM.dim_skill_level (skill_level_type, grade_name, skill_level_id, skill_grade, next_grade_level)
SELECT  
	4 AS skill_level_type
,	substring(language_level_name, '..') AS language_level_name
,	language_level_id
,	language_level_grade
,	lead(substring(language_level_name, '..'), 1, 'Max level') over (order by language_level_grade) AS next_grade_level
FROM ddl.language_level;


-- Заполнение DM.fact_empl_skills

-- database (skill_type = 1, skill_level_type = 1) 
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_database AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.bd_id and skill_type = 1  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;

-- instrument (skill_type = 2, skill_level_type = 1)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_instrument AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.instrument_id and skill_type = 2  
	left join dm.dim_date dd
		on dd.date = ed.date  
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;           
	-- left join dm.dim_skill_level dsl
	-- 	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1;

-- industry (skill_type = 3, skill_level_type = 2)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_industry AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.industry_id and skill_type = 3  
	left join dm.dim_date dd
		on dd.date = ed.date
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.industry_level_id and dsl.skill_level_type = 2;                
	-- left join dm.dim_skill_level dsl
	-- 	on dsl.skill_level_id = ed.industry_level_id and skill_level_type = 2;

-- subject (skill_type = 4, skill_level_type = 2)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_subject AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.subject_id and skill_type = 4  
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.subject_level_id and dsl.skill_level_type = 2      
	left join dm.dim_date dd
		on dd.date = ed.date;

-- platform (skill_type = 5, skill_level_type = 1)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_platform AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.platform_id and skill_type = 5  
	left join dm.dim_date dd
		on dd.date = ed.date
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;                      
	-- left join dm.dim_skill_level dsl
	-- 	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1;

-- ide (skill_type = 6, skill_level_type = 1)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_ide AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.ide_id and skill_type = 6  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;

-- technology (skill_type = 7, skill_level_type = 1)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_technology AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.technology_id and skill_type = 7  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;

-- system_type (skill_type = 8, skill_level_type = 1)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_system_type AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.system_type_id and skill_type = 8  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;

-- framework (skill_type = 9, skill_level_type = 1)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_framework AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.framework_id and skill_type = 9  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;

-- programming_language (skill_type = 10, skill_level_type = 1)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_programming_language AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.programming_language_id and skill_type = 10  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.grade_id and dsl.skill_level_type = 1;

-- language (skill_type = 11, skill_level_type = 4)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_language AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.language_id and skill_type = 11  
	left join dm.dim_date dd
		on dd.date = '2001-09-26'::date                     		-- Дата должна соответствовать заданной в dim_date
	left join dm.dim_skill_level as dsl
		on dsl.skill_level_id = ed.language_level_id and dsl.skill_level_type = 4;
	-- left join dm.dim_skill_level dsl
	-- 	on dsl.skill_level_id = ed.language_level_id and skill_level_type = 4;

-- education (skill_type = 12, skill_level_type = 3)
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_education AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id               
	left join dm.dim_date dd
		on dd.date = '2001-09-26'::date                   		   -- Дата должна соответствовать заданной в dim_date
	left join dm.dim_skill_level dsl
	 	on dsl.skill_level_id = ed.education_id and skill_level_type = 3
	left join dm.dim_skills ds  
		on ds.skill_id = ed.education_id and skill_type = 12;
	-- left join dm.dim_skill_level dsl
	-- 	on dsl.skill_level_id = ed.education_id and skill_level_type = 3;

-- Для сотрудников без записей в таблицах (не заполнили или неверно заполнили и мы не перенесли в ddl)
-- Выдаем дефолтное значение образования 
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key)
SELECT 
	employee_key
,	(SELECT skill_key FROM dm.dim_skills WHERE skill_name = 'Среднее общее')
,	(SELECT date_key FROM dm.dim_date WHERE "date" = '2001-09-26')                -- Дата должна соответствовать заданной в dim_date
,	(SELECT skill_level_key FROM dm.dim_skill_level WHERE grade_name = 'Среднее общее')
FROM (
	SELECT DISTINCT employee_key
	FROM dm.dim_employee de 
	EXCEPT
	SELECT DISTINCT employee_key
	FROM dm.fact_empl_skills fes
) as missing_emp;

-- Неравномерно очищаются данные в таблицах, любой пропуск считаем ошибкой

DELETE FROM DM.fact_empl_skills WHERE employee_key IS NULL;
--DELETE FROM DM.fact_empl_skills WHERE skill_key IS NULL;
-- DELETE FROM DM.fact_empl_skills WHERE date_key IS NULL;     
-- DELETE FROM DM.fact_empl_skills WHERE skill_level_key IS NULL;


-- Заполнение 2 куба

insert into dm.dim_year(calendar_year)
values (extract(year from now()::date) - 1),
	(extract(year from now()::date) - 2);

insert into dm.dim_department(department, department_count)
SELECT e.department, count(*) as department_count
FROM ddl.employee AS e
group by e.department;

insert into dm.dim_position(position, position_count)
SELECT e.position, count(*) as position_count
FROM ddl.employee AS e
group by e.position;

insert into dm.fact_pos_year(position_key, department_key, year_key, skill_key)
select 
	dp.position_key
,	dd.department_key
,	dy.year_key
,	pos_22.skill_key
from (
	select 
		distinct on (de."position", de.department, dd.calendar_year, fes.skill_key)
		de."position" 
	,	de.department 
	,	dd.calendar_year 
	,	fes.skill_key 
	from dm.fact_empl_skills fes
	left join dm.dim_employee de
		on fes.employee_key = de.employee_key
	left join dm.dim_date dd 
		on fes.date_key = dd.date_key
	where dd.calendar_year <= extract(year from now()::date) - 2
) as pos_22              -- для 2022 года
left join dm.dim_department dd
	on pos_22.department = dd.department
left join dm.dim_position dp 
	on pos_22.position = dp.position
left join dm.dim_year dy 
	on 2022 = dy.calendar_year;

insert into dm.fact_pos_year(position_key, department_key, year_key, skill_key)
select 
	dp.position_key
,	dd.department_key
,	dy.year_key
,	pos_23.skill_key
from (
	select 
		distinct on (de."position",	de.department,	dd.calendar_year, fes.skill_key)
		de."position" 
	,	de.department 
	,	dd.calendar_year 
	,	fes.skill_key 
	from dm.fact_empl_skills fes
	left join dm.dim_employee de
		on fes.employee_key = de.employee_key
	left join dm.dim_date dd 
		on fes.date_key = dd.date_key
	where dd.calendar_year <= extract(year from now()::date) - 1
) as pos_23             
left join dm.dim_department dd
	on pos_23.department = dd.department
left join dm.dim_position dp 
	on pos_23.position = dp.position
left join dm.dim_year dy 
	on 2023 = dy.calendar_year;



---------------------------------------------------
-- Расчет метрик
---------------------------------------------------

-- current_skill_level
-- Уровень навыка человека по каждому из навыков на текущий момент
-- (считаем что максимальный достигнутый уровень навыка сохраняется навсегда)
-- рассчете avg_skill_grade_... (employee, position, department)

-- Создание новой пустой колонки
ALTER TABLE DM.fact_empl_skills ADD COLUMN current_skill_level int4;

-- Заполнение current_skill_level
UPDATE DM.fact_empl_skills AS fes 
SET current_skill_level = inner_table.current_skill_level
FROM (
	SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key
	,	MAX(dsl.skill_grade) OVER (PARTITION BY employee_key, skill_key) AS current_skill_level
	FROM dm.fact_empl_skills fes
	LEFT JOIN dm.dim_date AS dd
		ON fes.date_key = dd.date_key
	LEFT JOIN dm.dim_skill_level AS dsl
		ON fes.skill_level_key = dsl.skill_level_key
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;

-- max_skill_grade_employee
-- максимальный уровень навыка человека в год записи - rolling_max по годам
-- (каким был максимальный достигнутый уровень навыка человека в x году по каждому из навыков)
-- Применяется в Гистограмме на 1 листе и при рассчете метрик

-- Создание новой пустой колонки
ALTER TABLE DM.fact_empl_skills ADD COLUMN max_skill_grade_employee int4;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET max_skill_grade_employee = inner_table.max_skill_grade_employee
FROM (
	SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key
	,	MAX(dsl.skill_grade) OVER (PARTITION BY employee_key, skill_key 
										ORDER BY dd.calendar_year asc rows between UNBOUNDED PRECEDING AND CURRENT ROW) AS max_skill_grade_employee -- , calendar_year
	FROM dm.fact_empl_skills fes
	LEFT JOIN dm.dim_date AS dd
		ON fes.date_key = dd.date_key
	LEFT JOIN dm.dim_skill_level AS dsl
		ON fes.skill_level_key = dsl.skill_level_key
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;


-- count_skills 
-- Число новых навыков и навыков с улучшеным уровнем в конкретном году
-- (по годам count где уровень скилла = max_skill_grade_employee)

-- Создание новой пустой колонки
ALTER TABLE DM.fact_empl_skills ADD COLUMN count_skills int4;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET count_skills = inner_table.count_skills
FROM (
	SELECT 	
		curr_max.employee_key
	, 	curr_max.skill_key
	, 	curr_max.date_key
	, 	curr_max.skill_level_key
	,	SUM(curr_max.is_current_max) OVER(PARTITION BY curr_max.employee_key, dd.calendar_year) AS count_skills
	FROM (
		SELECT 
			fes.employee_key
		, 	fes.skill_key
		, 	fes.date_key
		, 	fes.skill_level_key
		,	CASE WHEN dsl.skill_grade = fes.max_skill_grade_employee THEN 1
				ELSE 0 END AS is_current_max
		FROM dm.fact_empl_skills fes  					-- 1 когда текущий уровень навыка - максимальный за год
		LEFT JOIN dm.dim_skill_level AS dsl
			ON fes.skill_level_key = dsl.skill_level_key
	) AS curr_max
	LEFT JOIN dm.dim_date AS dd
		ON curr_max.date_key = dd.date_key
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;


-- avg_skill_grade_employee
-- Среднее значение среди уровней навыков человека в одной из 12 доступных областей
-- Считаем только по существующим навыкам 
-- Применяется в радаре

-- Создание новой пустой колонки
ALTER TABLE DM.fact_empl_skills ADD COLUMN avg_skill_grade_employee numeric;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET avg_skill_grade_employee = inner_table.avg_skill_grade_employee
FROM (
	SELECT 
		ag.employee_key
	, 	ag.skill_key
	, 	ag.date_key
	, 	ag.skill_level_key
	,	ag.avg_grade AS avg_skill_grade_employee  -- ROUND(  , 1) 
	FROM DM.fact_empl_skills AS fes
	LEFT JOIN (
		SELECT 
			fes.employee_key
		, 	fes.skill_key
		, 	fes.date_key
		, 	fes.skill_level_key
		,	AVG(fes.current_skill_level) OVER (PARTITION BY fes.employee_key, ds.skill_type) AS avg_grade 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_skills ds
			ON fes.skill_key = ds.skill_key
		LEFT JOIN dm.dim_skill_level dsl
			ON fes.skill_level_key = dsl.skill_level_key 
		WHERE dsl.skill_grade = fes.current_skill_level  -- проверка что уровень навыка - высший за все время
	) AS ag
		ON fes.employee_key = ag.employee_key
		AND fes.skill_key = ag.skill_key
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key ;
	--AND fes.date_key = inner_table.date_key 
	--AND fes.skill_level_key = inner_table.skill_level_key;



-- avg_skill_grade_position 
-- Среднее значение среди уровней навыков сотрудников внутри одной должности в одной из 12 доступных областей
-- Применяется в радаре

-- Создание новой пустой колонки
ALTER TABLE DM.fact_empl_skills ADD COLUMN avg_skill_grade_position numeric;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET avg_skill_grade_position = inner_table.avg_skill_grade_position
FROM (
	SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key 
	,	ag.avg_grade AS avg_skill_grade_position  -- ROUND(  , 1)
	FROM DM.fact_empl_skills AS fes
	left join dm.dim_employee de
		on fes.employee_key = de.employee_key
	left join dm.dim_skills ds
		on fes.skill_key = ds.skill_key 
	left join (
		SELECT 
			DE."position" 
		,	ds.skill_type
		,	AVG(fes.current_skill_level) AS avg_grade  -- OVER (PARTITION BY de.position, ds.skill_type) AS avg_grade 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_skills ds
			ON fes.skill_key = ds.skill_key
		LEFT JOIN dm.dim_employee de
			ON fes.employee_key = de.employee_key
		LEFT JOIN dm.dim_skill_level dsl
			ON fes.skill_level_key = dsl.skill_level_key
		WHERE dsl.skill_grade = fes.current_skill_level
		GROUP BY de.position, ds.skill_type
	) AS ag
		on de.position = ag.position
			and ds.skill_type = ag.skill_type
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;


-- avg_skill_grade_department
-- Среднее значение среди уровней навыков сотрудников внутри одного департамента в одной из 12 доступных областей
-- Применяется в радаре

-- Создание новой пустой колонки
ALTER TABLE DM.fact_empl_skills ADD COLUMN avg_skill_grade_department numeric;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET avg_skill_grade_department = inner_table.avg_skill_grade_department
FROM (
	SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key 
	,	ag.avg_grade AS avg_skill_grade_department  -- ROUND(  , 1)
	FROM DM.fact_empl_skills AS fes
	left join dm.dim_employee de
		on fes.employee_key = de.employee_key
	left join dm.dim_skills ds
		on fes.skill_key = ds.skill_key 
	left join (
		SELECT 
			DE.department
		,	ds.skill_type
		,	AVG(fes.current_skill_level) AS avg_grade-- OVER (PARTITION BY de.department, ds.skill_type) AS avg_grade 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_skills ds
			ON fes.skill_key = ds.skill_key
		LEFT JOIN dm.dim_employee de
			ON fes.employee_key = de.employee_key
		LEFT JOIN dm.dim_skill_level dsl
			ON fes.skill_level_key = dsl.skill_level_key
		WHERE dsl.skill_grade = fes.current_skill_level
		GROUP BY de.department, ds.skill_type
	) AS ag
		on de.department = ag.department
		and ds.skill_type = ag.skill_type
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;


-- count_skill_per_year_employee
-- (Для каждого года сколько раз человек улучшился по всем скиллам - в шт.) 
-- Применяется в облаке тэгов и при расчете метрик KPI на первой странице

-- Создание новой пустой колонки
ALTER TABLE DM.fact_empl_skills ADD COLUMN count_skill_per_year_employee int4;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET count_skill_per_year_employee = inner_table.count_skill_per_year_employee
FROM (
	SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key
	,	COUNT(*) OVER (PARTITION BY fes.employee_key, dd.calendar_year) AS count_skill_per_year_employee 
	FROM dm.fact_empl_skills fes
	LEFT JOIN dm.dim_date AS dd
		ON fes.date_key = dd.date_key
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;


-- new_skills_current
-- new_skills_last
-- improvement_percent
 
-- Число навыков изученных человеком в прошлом и позапрошлом годах, процент увеличения
-- Применяются в блоке KPI с первой страницы

ALTER TABLE DM.fact_empl_skills ADD COLUMN improvement_percent numeric;
ALTER TABLE DM.fact_empl_skills ADD COLUMN new_skills_current int4;
ALTER TABLE DM.fact_empl_skills ADD COLUMN new_skills_last int4;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET new_skills_current = imp.new_skills_current,
	new_skills_last = imp.new_skills_last,
	improvement_percent = imp.improvement_percent
FROM (
	SELECT 
		de.employee_key
	,	COALESCE(m1.minus_one, 0) AS new_skills_current
	,	COALESCE(m2.minus_two, 0) AS new_skills_last
	,	100 * round((COALESCE(m1.minus_one::numeric, 0) -
			COALESCE(m2.minus_two::numeric, 0)) / COALESCE(m2.minus_two::numeric,
			COALESCE(m1.minus_one::numeric, 1)), 3) AS improvement_percent
	FROM dm.dim_employee de
	LEFT JOIN (
		SELECT 
			DISTINCT ON (fes.employee_key, dd.calendar_year)
			fes.employee_key
		,	dd.calendar_year
		,	count_skill_per_year_employee AS minus_one
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date dd
			ON fes.date_key = dd.date_key
		WHERE dd.calendar_year = extract('year' FROM NOW()) - 1
	) AS m1
		ON de.employee_key = m1.employee_key
	LEFT JOIN(
		select 
			DISTINCT ON (fes.employee_key, dd.calendar_year)
			fes.employee_key
		,	dd.calendar_year
		,	count_skill_per_year_employee AS minus_two
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date dd
			ON fes.date_key = dd.date_key
		WHERE dd.calendar_year = extract('year' FROM NOW()) - 2
	) AS m2
		ON de.employee_key = m2.employee_key
) AS imp
	WHERE fes.employee_key = imp.employee_key;

-- skill_popularity
-- Число записей о навыке для каждой из должностей за все время
-- Для сортировки в блоке "Область развития"

ALTER TABLE DM.fact_empl_skills ADD COLUMN skill_popularity int4;

-- Заполнение
UPDATE DM.fact_empl_skills AS fes 
SET skill_popularity = inner_table.skill_popularity
FROM (
SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key
	,	COUNT(*) over (partition by fes.skill_key, de.position) as skill_popularity
from dm.fact_empl_skills fes
left JOIN dm.dim_employee de
		ON fes.employee_key = de.employee_key
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;


--------------------------------------
-- Метрики для второго куба
--------------------------------------

-- Годовой прирост грейдов
-- count_novice_department

alter table dm.fact_pos_year add column count_novice_department int4;

UPDATE dm.fact_pos_year AS fpy 
SET count_novice_department = all_cols.count_novice_department
FROM (
select
	fpy.position_key 
,	fpy.department_key 
,	fpy.year_key 
,	fpy.skill_key 
,	coalesce(nov.count_novice_department, 0) as count_novice_department
from dm.fact_pos_year fpy
left join dm.dim_position dp
	on fpy.position_key = dp.position_key 
left join dm.dim_department dd2 
	on fpy.department_key = dd2.department_key 
left join dm.dim_year dy 
	on fpy.year_key = dy.year_key 
left join(
		SELECT 
			de.department
		, 	de.position
		, 	fes.skill_key
		,	dd.calendar_year
		,	COUNT(*) OVER (PARTITION BY dd.calendar_year, de.department, de.position, fes.skill_key) AS count_novice_department 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date AS dd
			ON fes.date_key = dd.date_key
		LEFT JOIN dm.dim_employee AS de
			ON fes.employee_key = de.employee_key
		left join dm.dim_skill_level dsl 
			on fes.skill_level_key = dsl.skill_level_key 
		WHERE fes.max_skill_grade_employee = 1
			and dsl.skill_grade = max_skill_grade_employee
) as nov
	on dp.position = nov.position
	and dd2.department = nov.department
	and fpy.skill_key = nov.skill_key
	and dy.calendar_year = nov.calendar_year
) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;



-- count_junior_department

alter table dm.fact_pos_year add column count_junior_department int4;

UPDATE dm.fact_pos_year AS fpy 
SET count_junior_department = all_cols.count_junior_department
FROM (
select
	fpy.position_key 
,	fpy.department_key 
,	fpy.year_key 
,	fpy.skill_key 
,	coalesce(nov.count_junior_department, 0) as count_junior_department
from dm.fact_pos_year fpy
left join dm.dim_position dp
	on fpy.position_key = dp.position_key 
left join dm.dim_department dd2 
	on fpy.department_key = dd2.department_key 
left join dm.dim_year dy 
	on fpy.year_key = dy.year_key 
left join(
		SELECT 
			de.department
		, 	de.position
		, 	fes.skill_key
		,	dd.calendar_year
		,	COUNT(*) OVER (PARTITION BY dd.calendar_year, de.department, de.position, fes.skill_key) AS count_junior_department 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date AS dd
			ON fes.date_key = dd.date_key
		LEFT JOIN dm.dim_employee AS de
			ON fes.employee_key = de.employee_key
		left join dm.dim_skill_level dsl 
			on fes.skill_level_key = dsl.skill_level_key 
		WHERE fes.max_skill_grade_employee = 2
			and dsl.skill_grade = max_skill_grade_employee
) as nov
	on dp.position = nov.position
	and dd2.department = nov.department
	and fpy.skill_key = nov.skill_key
	and dy.calendar_year = nov.calendar_year
) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;


-- count_middle_department

alter table dm.fact_pos_year add column count_middle_department int4;

UPDATE dm.fact_pos_year AS fpy 
SET count_middle_department = all_cols.count_middle_department
FROM (
select
	fpy.position_key 
,	fpy.department_key 
,	fpy.year_key 
,	fpy.skill_key 
,	coalesce(nov.count_middle_department, 0) as count_middle_department
from dm.fact_pos_year fpy
left join dm.dim_position dp
	on fpy.position_key = dp.position_key 
left join dm.dim_department dd2 
	on fpy.department_key = dd2.department_key 
left join dm.dim_year dy 
	on fpy.year_key = dy.year_key 
left join(
		SELECT 
			de.department
		, 	de.position
		, 	fes.skill_key
		,	dd.calendar_year
		,	COUNT(*) OVER (PARTITION BY dd.calendar_year, de.department, de.position, fes.skill_key) AS count_middle_department 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date AS dd
			ON fes.date_key = dd.date_key
		LEFT JOIN dm.dim_employee AS de
			ON fes.employee_key = de.employee_key
		left join dm.dim_skill_level dsl 
			on fes.skill_level_key = dsl.skill_level_key 
		WHERE fes.max_skill_grade_employee = 3
			and dsl.skill_grade = max_skill_grade_employee
) as nov
	on dp.position = nov.position
	and dd2.department = nov.department
	and fpy.skill_key = nov.skill_key
	and dy.calendar_year = nov.calendar_year
) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;


-- count_senior_department

alter table dm.fact_pos_year add column count_senior_department int4;

UPDATE dm.fact_pos_year AS fpy 
SET count_senior_department = all_cols.count_senior_department
FROM (
select
	fpy.position_key 
,	fpy.department_key 
,	fpy.year_key 
,	fpy.skill_key 
,	coalesce(nov.count_senior_department, 0) as count_senior_department
from dm.fact_pos_year fpy
left join dm.dim_position dp
	on fpy.position_key = dp.position_key 
left join dm.dim_department dd2 
	on fpy.department_key = dd2.department_key 
left join dm.dim_year dy 
	on fpy.year_key = dy.year_key 
left join(
		SELECT 
			de.department
		, 	de.position
		, 	fes.skill_key
		,	dd.calendar_year
		,	COUNT(*) OVER (PARTITION BY dd.calendar_year, de.department, de.position, fes.skill_key) AS count_senior_department 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date AS dd
			ON fes.date_key = dd.date_key
		LEFT JOIN dm.dim_employee AS de
			ON fes.employee_key = de.employee_key
		left join dm.dim_skill_level dsl 
			on fes.skill_level_key = dsl.skill_level_key 
		WHERE fes.max_skill_grade_employee = 4
			and dsl.skill_grade = max_skill_grade_employee
) as nov
	on dp.position = nov.position
	and dd2.department = nov.department
	and fpy.skill_key = nov.skill_key
	and dy.calendar_year = nov.calendar_year
) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;




-- count_expert_department

alter table dm.fact_pos_year add column count_expert_department int4;

UPDATE dm.fact_pos_year AS fpy 
SET count_expert_department = all_cols.count_expert_department
FROM (
select
	fpy.position_key 
,	fpy.department_key 
,	fpy.year_key 
,	fpy.skill_key 
,	coalesce(nov.count_expert_department, 0) as count_expert_department
from dm.fact_pos_year fpy
left join dm.dim_position dp
	on fpy.position_key = dp.position_key 
left join dm.dim_department dd2 
	on fpy.department_key = dd2.department_key 
left join dm.dim_year dy 
	on fpy.year_key = dy.year_key 
left join(
		SELECT 
			de.department
		, 	de.position
		, 	fes.skill_key
		,	dd.calendar_year
		,	COUNT(*) OVER (PARTITION BY dd.calendar_year, de.department, de.position, fes.skill_key) AS count_expert_department 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date AS dd
			ON fes.date_key = dd.date_key
		LEFT JOIN dm.dim_employee AS de
			ON fes.employee_key = de.employee_key
		left join dm.dim_skill_level dsl 
			on fes.skill_level_key = dsl.skill_level_key 
		WHERE fes.max_skill_grade_employee = 5
			and dsl.skill_grade = max_skill_grade_employee
) as nov
	on dp.position = nov.position
	and dd2.department = nov.department
	and fpy.skill_key = nov.skill_key
	and dy.calendar_year = nov.calendar_year
) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;




-- сумма грейдов

-- все грейды за 2022, 2023 тут, раскладываем по колонкам из этой таблицы 
-- Присоединяем к департаменту, позиции, скиллу, году при нужной max_at

CREATE TEMP TABLE IF NOT EXISTS tt_grade_count AS
select   				-- 6 181
		max_22.skill_key
	,	de.position
	,	de.department
	,	max_at_2022 as max_at
	,	count(*) as total_grade_at_department
	,	2022 as calendar_year
	from (
		select
			fes.employee_key 
		,	fes.skill_key
		,	max(dsl.skill_grade) as max_at_2022
		from dm.fact_empl_skills fes
		left join dm.dim_skill_level dsl 
			on fes.skill_level_key = dsl.skill_level_key
		left join dm.dim_date dd 
			on fes.date_key = dd.date_key 
		where dd.calendar_year <= 2022
		group by fes.employee_key, fes.skill_key
	) as max_22
left join dm.dim_employee de 
	on max_22.employee_key = de.employee_key
group by de.department, de.position, max_22.skill_key, max_at_2022
union all
select                               -- Это присоединяем к департаменту, позиции, скиллу в 2023 году
	max_23.skill_key
,	de.position
,	de.department
,	max_at_2023 as max_at
,	count(*) as total_grade_at_department
,	2023 as calendar_year
from (
select
	fes.employee_key 
,	fes.skill_key
,	max(dsl.skill_grade) as max_at_2023
from dm.fact_empl_skills fes
left join dm.dim_skill_level dsl 
	on fes.skill_level_key = dsl.skill_level_key
left join dm.dim_date dd 
	on fes.date_key = dd.date_key 
where dd.calendar_year <= 2023
group by fes.employee_key, fes.skill_key
) as max_23
    left join dm.dim_employee de 
	    on max_23.employee_key = de.employee_key
    group by de.department, de.position, max_23.skill_key, max_at_2023;




-- 

alter table dm.fact_pos_year add column total_novice_department int4;
alter table dm.fact_pos_year add column total_junior_department int4;
alter table dm.fact_pos_year add column total_middle_department int4;
alter table dm.fact_pos_year add column total_senior_department int4;
alter table dm.fact_pos_year add column total_expert_department int4;

UPDATE dm.fact_pos_year AS fpy 
SET total_novice_department = all_cols.total_novice_department,
    total_junior_department = all_cols.total_junior_department,
    total_middle_department = all_cols.total_middle_department,
    total_senior_department = all_cols.total_senior_department,
    total_expert_department = all_cols.total_expert_department
FROM (
select       -- 6 129
	fpy.position_key 
,	fpy.department_key 
,	fpy.year_key 
,	fpy.skill_key 
,	coalesce(gc1.total_grade_at_department, 0) as total_novice_department
,	coalesce(gc2.total_grade_at_department, 0) as total_junior_department
,	coalesce(gc3.total_grade_at_department, 0) as total_middle_department
,	coalesce(gc4.total_grade_at_department, 0) as total_senior_department
,	coalesce(gc5.total_grade_at_department, 0) as total_expert_department
from dm.fact_pos_year fpy
left join dm.dim_position dp
	on fpy.position_key = dp.position_key 
left join dm.dim_department dd2 
	on fpy.department_key = dd2.department_key 
left join dm.dim_year dy 
	on fpy.year_key = dy.year_key 
left join tt_grade_count as gc1
	on dp.position = gc1.position
	and dd2.department = gc1.department
	and fpy.skill_key = gc1.skill_key
	and dy.calendar_year = gc1.calendar_year
	and gc1.max_at = 1
left join tt_grade_count as gc2
	on dp.position = gc2.position
	and dd2.department = gc2.department
	and fpy.skill_key = gc2.skill_key
	and dy.calendar_year = gc2.calendar_year
	and gc2.max_at = 2
left join tt_grade_count as gc3
	on dp.position = gc3.position
	and dd2.department = gc3.department
	and fpy.skill_key = gc3.skill_key
	and dy.calendar_year = gc3.calendar_year
	and gc3.max_at = 3
left join tt_grade_count as gc4
	on dp.position = gc4.position
	and dd2.department = gc4.department
	and fpy.skill_key = gc4.skill_key
	and dy.calendar_year = gc4.calendar_year
	and gc4.max_at = 4
left join tt_grade_count as gc5
	on dp.position = gc5.position
	and dd2.department = gc5.department
	and fpy.skill_key = gc5.skill_key
	and dy.calendar_year = gc5.calendar_year
	and gc5.max_at = 5
) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;

-- Удаляем временную таблицу
drop table tt_grade_count;

-- total_grades
-- Число грейдов / число людей

alter table dm.fact_pos_year add column total_grades numeric;    

UPDATE dm.fact_pos_year AS fpy 
SET total_grades = all_cols.total_grades
FROM (
select
	fpy.position_key
,	fpy.department_key
,	fpy.year_key
,	fpy.skill_key
,	(count_novice_department + count_junior_department + count_middle_department
	+ count_senior_department + count_expert_department)::numeric / dd.department_count as total_grades
from dm.fact_pos_year fpy
left join dm.dim_department dd 
	on fpy.department_key = dd.department_key 
left join dm.dim_position dp 
	on fpy.position_key = dp.position_key
) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;


-- pos_skill_level

alter table dm.fact_pos_year add column pos_skill_level numeric; 

UPDATE dm.fact_pos_year AS fpy 
SET pos_skill_level = all_cols.pos_skill_level
FROM (
select 
	fpy.position_key
,	fpy.department_key
,	fpy.year_key
,	fpy.skill_key
,	coalesce(ag.pos_level, 1) as pos_skill_level
from dm.fact_pos_year fpy
left join 
	(select 
	fpy.department_key, fpy.position_key,
	fpy.skill_key
,	(total_novice_department * 1
		+ total_junior_department * 2
		+ total_middle_department * 3
		+ total_senior_department * 4
		+ total_expert_department * 5)::numeric /  (total_novice_department
		+ total_junior_department
		+ total_middle_department
		+ total_senior_department
		+ total_expert_department) as pos_level -- / dd.department_count / dp.position_count
from dm.fact_pos_year fpy
left join dm.dim_year dy 
	on fpy.year_key = dy.year_key
left join dm.dim_department dd 
	on fpy.department_key = dd.department_key
left join dm.dim_position dp 
	on fpy.position_key = dp.position_key 
where dy.calendar_year = 2023
	and (total_novice_department
		+ total_junior_department
		+ total_middle_department
		+ total_senior_department
		+ total_expert_department) <> 0
) as ag
on fpy.position_key = ag.position_key
	and fpy.department_key = ag.department_key
	and fpy.skill_key = ag.skill_key
	) all_cols
WHERE 1=1
	and fpy.position_key = all_cols.position_key
	and fpy.department_key = all_cols.department_key
	and fpy.year_key = all_cols.year_key
	and fpy.skill_key= all_cols.skill_key;