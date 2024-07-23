CREATE SCHEMA IF NOT EXISTS DM;

CREATE TABLE IF NOT EXISTS DM.dim_date (
	date_key SERIAL,
	date date,
	calendar_year int4
);

CREATE TABLE IF NOT EXISTS DM.generated_names(  -- Должна появится раньше (мб в stg)
	employee_id int4,
	full_name text
);
-- ПРОТЕСТИТЬ ВСЕ ЧЕРЕЗ EXPLAIN, записать для защиты от вопросов

CREATE TABLE IF NOT EXISTS DM.dim_skill_level (
	skill_level_key SERIAL,
	skill_level_type int4,  -- (от 1 до 4 - по единицам оценивания)
    skill_level_id int4,
	skill_grade int4,		-- важность навыка, больше - лучше
	grade_name TEXT,
	next_grade_level TEXT 	-- название следующего навыка
);

CREATE TABLE IF NOT EXISTS DM.dim_skills (
	skill_key SERIAL,
	skill_id int4,
    skill_name Text,
    skill_type int4, -- (от 1 до 12 - по таблице)
	grade_type int4  -- (от 1 до 4 - по единицам оценивания)
);

CREATE TABLE IF NOT EXISTS DM.dim_employee (
	employee_key SERIAL,
	employee_id int4,
    position TEXT,
	department TEXT, 
	fullname TEXT    -- fullname отдельной колонкой дополнительно или только так
);

CREATE TABLE IF NOT EXISTS DM.fact_empl_skills (
	employee_key int4,
	skill_key int4,
	date_key int4,
	skill_level_key int4,
	count_skills int4,
	current_skill_level int4,              -- мб не current, а на момент конца года
	max_skill_grade_employee int4,
	avg_skill_grade_employee numeric,
	avg_skill_grade_position numeric,
	count_skill_per_year_employee int4,   -- ??
	avg_department_position_grade numeric,
	count_skill_department int4
);
-- database
-- instrument
-- industry
-- subject
-- platform
-- ide
-- technology
-- system_type
-- framework
-- programming_language
--language 
--education

INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT 
	bd_name AS skill_name
, 	bd_id AS skill_id
,	1 AS skill_type
,	1 AS grade_type
FROM ddl.database
UNION
SELECT 
	instrument_name AS skill_name
,	instrument_id AS skill_id
,	2 AS skill_type
,	1 AS grade_type
FROM ddl.instrument
UNION
SELECT 
	industry_name AS skill_name
,	industry_id AS skill_id
,	3 AS skill_type
,	2 AS grade_type
FROM ddl.industry
UNION
SELECT 
	subject_name AS skill_name
, 	subject_id AS skill_id
, 	4 AS skill_type
,	2 AS grade_type 
FROM ddl.subject
UNION
SELECT 
	platform_name AS skill_name
, 	platform_id AS skill_id
, 	5 AS skill_type
,	1 AS grade_type 
FROM ddl.platform
UNION
SELECT 
	ide_name AS skill_name
, 	ide_id AS skill_id
, 	6 AS skill_type
,	1 AS grade_type 
FROM ddl.ide
UNION
SELECT 
	technology_name AS skill_name
, 	technology_id AS skill_id
, 	7 AS skill_type
,	1 AS grade_type 
FROM ddl.technology
UNION
SELECT 
	system_type_name AS skill_name
, 	system_type_id AS skill_id
, 	8 AS skill_type
, 	1 AS grade_type 
FROM ddl.system_type
UNION
SELECT 
	framework_name AS skill_name
, 	framework_id AS skill_id
, 	9 AS skill_type
, 	1 AS grade_type 
FROM ddl.framework
UNION
SELECT 
	programming_language_name AS skill_name
, 	programming_language_id AS skill_id
, 	10 AS skill_type
, 	1 AS grade_type 
FROM ddl.programming_language
UNION
SELECT 
	language_name AS skill_name
, 	language_id AS skill_id
, 	11 AS skill_type
, 	4 AS grade_type 
FROM ddl.language
UNION
SELECT 
	education_name AS skill_name
, 	education_id AS skill_id
, 	12 AS skill_type
, 	3 AS grade_type 
FROM ddl.education;

-- employee          --- сделать вставку раньше (в одс)
INSERT INTO DM.dim_employee (employee_id, position, department, fullname)
SELECT e.employee_id, position, fd.department, full_name FROM ddl.employee AS e
LEFT JOIN public.generated_names AS g
ON e.employee_id = g.employee_id
left join public.fixed_departments fd
on e.department = fd.old_department_name;  -- TEMP JOIN;

-- dim_date
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
SELECT '2001-09-26'::date AS date, extract(year from '2001-09-26'::date) AS calendar_year   -- стоит default дата для единообразия, не используется далее
FROM ddl.employee_language					
UNION
SELECT '2001-09-26'::date AS date, extract(year from '2001-09-26'::date) AS calendar_year
FROM ddl.employee_education) AS all_dates;

-- union Execution Time: 0.283 ms
INSERT INTO  DM.dim_skill_level (skill_level_type, grade_name, skill_level_id, skill_grade, next_grade_level)
-- grade
SELECT 
	1 AS skill_level_type
,	grade_name
,	grade_id
,	grade_level
,	lead(grade_name, 1, 'Max level') over (order by grade_level) AS next_grade_level
FROM ddl.grade
UNION
-- subject_industry_level
SELECT 
	2 AS skill_level_type
,	subject_industry_level_name
,	subject_industry_level_id
,	subject_industry_level_grade
,	lead(subject_industry_level_name, 1, 'Max level') over (order by subject_industry_level_grade) AS next_grade_level
FROM ddl.subject_industry_level
UNION
-- education
SELECT 
	3 AS skill_level_type
,	education_name
,	education_id
,	education_grade
,	lead(education_name, 1, 'Max level') over (order by education_grade) AS next_grade_level
FROM ddl.education
UNION
-- language_level
SELECT  
	4 AS skill_level_type
,	substring(language_level_name, '..') AS language_level_name
,	language_level_id
,	language_level_grade
,	lead(substring(language_level_name, '..'), 1, 'Max level') over (order by language_level_grade) AS next_grade_level
FROM ddl.language_level
ORDER BY skill_level_type, grade_level;

-- UNION
--Planning Time: 1.887 ms
--Execution Time: 14.127 ms

-- INSERT (внутри функции)
--Planning Time: 0.021 ms
--Execution Time: 10.124 ms

-- fact_table
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key) -- database
-- database
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_database AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.bd_id and skill_type = 1  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union
-- instrument
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_instrument AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.instrument_id and skill_type = 2  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union  
-- industry
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_industry AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.industry_id and skill_type = 3  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.industry_level_id and skill_level_type = 2
union 
-- subject
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_subject AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.subject_id and skill_type = 4  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.subject_level_id and skill_level_type = 2
union 
-- platform
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_platform AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.platform_id and skill_type = 5  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union 
-- ide
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_ide AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.ide_id and skill_type = 6  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union 
-- technology
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_technology AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.technology_id and skill_type = 7  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union 
-- system_type
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_system_type AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.system_type_id and skill_type = 8  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union 
-- framework
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_framework AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.framework_id and skill_type = 9  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union 
-- programming_language
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_programming_language AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.programming_language_id and skill_type = 10  
	left join dm.dim_date dd
		on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union 
-- language
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_language AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.language_id and skill_type = 11  
	left join dm.dim_date dd
		on dd.date = '2001-09-26'::date                     		-- Дата должна соответствовать заданной в dim_date
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.language_level_id and skill_level_type = 4
union 
-- education
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_education AS ed
	left join dm.dim_employee de
		on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
		on ds.skill_id = ed.education_id and skill_type = 12  
	left join dm.dim_date dd
		on dd.date = '2001-09-26'::date                   		   -- Дата должна соответствовать заданной в dim_date
	left join dm.dim_skill_level dsl
		on dsl.skill_level_id = ed.education_id and skill_level_type = 3;

DELETE FROM DM.fact_empl_skills WHERE employee_key IS NULL;    



UPDATE DM.fact_empl_skills AS fes 
SET current_skill_level = inner_table.current_skill_level
FROM (
	SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key
	,	MAX(dsl.skill_grade) OVER (PARTITION BY employee_key, skill_key) AS current_skill_level -- , calendar_year
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
-- похожая метрика, но rolling_max по дате ??  (мб получать максимум из нее)
-- надо ли добавть rows between current and ...
 
UPDATE DM.fact_empl_skills AS fes 
SET max_skill_grade_employee = inner_table.max_skill_grade_employee
FROM (
	SELECT 
		fes.employee_key
	, 	fes.skill_key
	, 	fes.date_key
	, 	fes.skill_level_key
	,	MAX(dsl.skill_grade) OVER (PARTITION BY employee_key, skill_key ORDER BY dd.date ASC) AS max_skill_grade_employee -- , calendar_year
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

--count_skills (по годам count где уровень скилла = max_skill_grade_employee)

-- мб через count + (partition .. order by) ??

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
-- (по скиллам одной категории сейчас), считаю через current_skill_level

UPDATE DM.fact_empl_skills AS fes 
SET avg_skill_grade_employee = inner_table.avg_skill_grade_employee
FROM (
	SELECT 
		ag.employee_key
	, 	ag.skill_key
	, 	ag.date_key
	, 	ag.skill_level_key
	,	ROUND(ag.avg_grade, 3) AS avg_skill_grade_employee
	FROM (
		SELECT 
			fes.employee_key
		, 	fes.skill_key
		, 	fes.date_key
		, 	fes.skill_level_key
		,	AVG(fes.current_skill_level) OVER (PARTITION BY fes.employee_key, ds.skill_type) AS avg_grade 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_skills ds
			ON fes.skill_key = ds.skill_key
	) AS ag
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;

-- avg_skill_grade_position (похожая, но среднее по категориям для каждой позиции)

UPDATE DM.fact_empl_skills AS fes 
SET avg_skill_grade_position = inner_table.avg_skill_grade_position
FROM (
	SELECT 
		ag.employee_key
	, 	ag.skill_key
	, 	ag.date_key
	, 	ag.skill_level_key
	,	ROUND(ag.avg_grade, 3) AS avg_skill_grade_position
	FROM (
		SELECT 
			fes.employee_key
		, 	fes.skill_key
		, 	fes.date_key
		, 	fes.skill_level_key
		,	AVG(fes.current_skill_level) OVER (PARTITION BY de.position, ds.skill_type) AS avg_grade 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_skills ds
			ON fes.skill_key = ds.skill_key
		LEFT JOIN dm.dim_employee de
			ON fes.employee_key = de.employee_key
	) AS ag 
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;

--count_skill_per_year_employee
-- (Для каждого года сколько раз человек улучшился по всем скиллам - в шт.)

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

-- avg_department_position_grade
-- средний грейд по должности внутри департамента

UPDATE DM.fact_empl_skills AS fes 
SET avg_department_position_grade = inner_table.avg_department_position_grade
FROM (	
	SELECT 
		ag.employee_key
	,	ag.skill_key
	, 	ag.date_key
	, 	ag.skill_level_key
	,	ROUND(ag.avg_department_position_grade, 3) AS avg_department_position_grade
	FROM (
		SELECT 
			fes.employee_key
		, 	fes.skill_key
		, 	fes.date_key
		, 	fes.skill_level_key
		,	AVG(dsl.skill_grade) OVER (PARTITION BY de.department, de.position) AS avg_department_position_grade
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_skill_level dsl
			ON fes.skill_level_key = dsl.skill_level_key
		LEFT JOIN dm.dim_employee de 
			ON fes.employee_key = de.employee_key
	) AS ag 
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;

-- count_skill_department
-- Для каждого года сколько раз люди одной должности внутри одного департамента улучшили свои навыки по всем скиллам - в шт.

UPDATE DM.fact_empl_skills AS fes 
SET count_skill_department = inner_table.count_skill_department
FROM (
		SELECT 
			fes.employee_key
		, 	fes.skill_key
		, 	fes.date_key
		, 	fes.skill_level_key
		,	COUNT(*) OVER (PARTITION BY dd.calendar_year, de.department, de.position) AS count_skill_department 
		FROM dm.fact_empl_skills fes
		LEFT JOIN dm.dim_date AS dd
			ON fes.date_key = dd.date_key
		LEFT JOIN dm.dim_employee de
			ON fes.employee_key = de.employee_key 
) AS inner_table
WHERE 1=1
	AND fes.employee_key = inner_table.employee_key 
	AND fes.skill_key = inner_table.skill_key 
	AND fes.date_key = inner_table.date_key 
	AND fes.skill_level_key = inner_table.skill_level_key;