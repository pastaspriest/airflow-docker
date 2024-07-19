CREATE SCHEMA IF NOT EXISTS DM;

CREATE TABLE IF NOT EXISTS DM.dim_date (
	date_key SERIAL,
	date date,
	calendar_year int4
);

CREATE TABLE IF NOT EXISTS DM.dim_skill_level (
	skill_level_key SERIAL,
	skill_level_type int4,  -- (от 1 до 4 - по единицам оценивания)
    skill_level_id int4,
	skill_grade int4,		-- важность навыка, больше - лучше
	grade_name TEXT
	-- next_grade_level int4 добавить, нужен
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
	name TEXT,
	surname TEXT
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
--language -- ???
--education -- ???

INSERT INTO DM.dim_skills(skill_name, skill_id, skill_type, grade_type)
SELECT bd_name AS skill_name
, 	bd_id AS skill_id
,	1 AS skill_type
,	1 AS grade_type
FROM ddl.database
UNION
SELECT instrument_name AS skill_name
,	instrument_id AS skill_id
,	2 AS skill_type
,	1 AS grade_type
FROM ddl.instrument
UNION
SELECT industry_name AS skill_name
,	industry_id AS skill_id
,	3 AS skill_type
,	2 As grade_type
FROM ddl.industry
UNION
SELECT subject_name AS skill_name
, 	subject_id AS skill_id
, 	4 AS skill_type
,	2 As grade_type 
FROM ddl.subject        -- Оцениваются по своим измерениям
UNION
SELECT platform_name AS skill_name
, 	platform_id AS skill_id
, 	5 AS skill_type
,	1 As grade_type 
FROM ddl.platform
UNION
SELECT ide_name AS skill_name
, 	ide_id AS skill_id
, 	6 AS skill_type
,	1 AS grade_type 
FROM ddl.ide
UNION
SELECT technology_name AS skill_name
, 	technology_id AS skill_id
, 	7 AS skill_type
,	1 AS grade_type 
FROM ddl.technology
UNION
SELECT system_type_name AS skill_name
, 	system_type_id AS skill_id
, 	8 AS skill_type
, 	1 AS grade_type 
FROM ddl.system_type
UNION
SELECT framework_name AS skill_name
, 	framework_id AS skill_id
, 	9 AS skill_type
, 	1 AS grade_type 
FROM ddl.framework
UNION
SELECT programming_language_name AS skill_name
, 	programming_language_id AS skill_id
, 	10 AS skill_type
, 	1 AS grade_type 
FROM ddl.programming_language
UNION
SELECT language_name AS skill_name
, 	language_id AS skill_id
, 	11 AS skill_type
, 	4 AS grade_type 
FROM ddl.language
UNION
SELECT education_name AS skill_name
, 	education_id AS skill_id
, 	12 AS skill_type
, 	3 AS grade_type 
FROM ddl.education;

-- employee
INSERT INTO DM.dim_employee (employee_id, position, department, name, surname)
SELECT employee_id, position FROM ddl.employee;

-- '2221-02-01', '2123-07-20', '2119-04-01'
-- дата 31 декабря x года, x год начиная с 2021 и заканчивая сейчас ??? (+ сегодня ???)
-- INSERT INTO  DM.dim_date (date,	calendar_year)
-- SELECT dd::date as date, extract(year from dd) as calendar_year
-- FROM generate_series
--         ( '2021-12-31'::date 
--         , NOW()::date
--         , '1 year'::interval) dd
-- union
-- SELECT NOW()::date as date, extract(year from NOW()) as calendar_year
-- ORDER BY date;
-- instrument
-- industry
-- subject
-- platform
-- ide
-- technology
-- system_type
-- framework
-- programming_language
--language -- ???
--education

--у языков и education NOW()::date
--INSERT INTO  DM.dim_date (date,	calendar_year)

SELECT DISTINCT date AS date, calendar_year
FROM (
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_database
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_instrument
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_industry
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_subject
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_platform
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_ide
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_technology
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_system_type
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_framework
UNION
SELECT date, extract(year from date) as calendar_year
FROM ddl.employee_programming_language
UNION
SELECT NOW()::date AS date, extract(year from NOW()) as calendar_year   -- мб тут поставить определенную default дату ??
FROM ddl.employee_language
UNION
SELECT NOW()::date AS date, extract(year from NOW()) as calendar_year
FROM ddl.employee_education) AS all_dates;

-- нужно обязательно пересоздавать даты перед кубом !!!

-- Вопрос по измерениям (grade)

INSERT INTO  DM.dim_skill_level (skill_level_type, skill_level_id, skill_grade, grade_name)
SELECT 1 AS skill_level_type
,	grade_id AS skill_level_id
,	grade_level AS skill_grade
,	grade_name As grade_name
FROM ddl.grade
UNION
SELECT 2 AS skill_level_type
,	subject_industry_level_id AS skill_level_id
,	subject_industry_level_grade AS skill_grade
,	subject_industry_level_name As grade_name
FROM ddl.subject_industry_level
UNION
SELECT 3 AS skill_level_type
,	education_id AS skill_level_id
,	education_grade AS skill_grade
,	education_name As grade_name
FROM ddl.education
UNION
SELECT 4 AS skill_level_type
,	language_level_id AS skill_level_id
,	language_level_grade AS skill_grade
,	language_level_name As grade_name
FROM ddl.language_level
ORDER BY skill_level_type, skill_grade;

--DM.fact_empl_skills (employee_key, skill_key, date_key, skill_level_key,
-- 	avg_skill_grade_employee numeric,
-- 	avg_skill_grade_position numeric,
-- 	count_skills_by_position int4,
-- 	next_skill_grade int4,                   -- ???
-- 	count_skill_per_year_employee int4,
-- 	sum_skill_per_year_employee int4
-- );

-- instrument
-- industry
-- subject
-- platform
-- ide
-- technology
-- system_type
-- framework
-- programming_language
--language -- ???
--education
----------------------------- fact_table
INSERT INTO DM.fact_empl_skills (employee_key, skill_key, date_key,	skill_level_key) -- database
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_database as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.bd_id and skill_type = 1  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union  -- instrument
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_instrument as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.instrument_id and skill_type = 2  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union  -- industry
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_industry as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.industry_id and skill_type = 3  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.industry_level_id and skill_level_type = 2
union -- subject
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_subject as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.subject_id and skill_type = 4  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.subject_level_id and skill_level_type = 2
union -- platform
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_platform as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.platform_id and skill_type = 5  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union -- ide
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_ide as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.ide_id and skill_type = 6  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union -- technology
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_technology as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.technology_id and skill_type = 7  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union -- system_type
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_system_type as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.system_type_id and skill_type = 8  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union -- framework
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_framework as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.framework_id and skill_type = 9  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union -- programming_language
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_programming_language as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.programming_language_id and skill_type = 10  
	left join dm.dim_date dd
	on dd.date = ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1
union -- language
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_language as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.language_id and skill_type = 11  
	left join dm.dim_date dd
	on dd.date = NOW()::date --ed.date                      
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.language_level_id and skill_level_type = 4
union -- education
select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_education as ed
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             
	left join dm.dim_skills ds  
	on ds.skill_id = ed.education_id and skill_type = 12  
	left join dm.dim_date dd
	on dd.date = NOW()::date --ed.date                     ----- МБ заменить на статичную дату 
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.education_id and skill_level_type = 3;

DELETE FROM DM.fact_empl_skills WHERE employee_key IS NULL;
--------------------------------------------------------------------------
-- select ed.employee_id, ed.bd_id, ed.grade_id, g.grade_level, ed.date, de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key from ddl.employee_database as ed
-- 	left join ddl.grade as g
-- 	on ed.grade_id = g.grade_id -- ???
-- 	left join dm.dim_employee de
-- 	on de.employee_id = ed.employee_id             -- первый ключ 
-- 	left join dm.dim_skills ds  
-- 	on ds.skill_id = ed.bd_id and skill_type = 1   -- второй ключ
-- 	left join dm.dim_date dd
-- 	on dd.date = '2023-12-31'                      -- тут вопросы, третий ключ
-- 	left join dm.dim_skill_level dsl
-- 	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1        -- четвертый ключ
-- where ed.date < '2023-12-31'
-- order by ed.employee_id, ed.bd_id;

------------ копия с group by


-- current_skill_level

UPDATE DM.fact_empl_skills AS fes 
SET current_skill_level = inner_table.current_skill_level
FROM (select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
, 	dd.calendar_year
,	dsl.skill_grade
,	MAX(dsl.skill_grade) over(partition by employee_key, skill_key) as current_skill_level -- , calendar_year
from dm.fact_empl_skills fes
left join dm.dim_date as dd
on fes.date_key = dd.date_key
left join dm.dim_skill_level as dsl
on fes.skill_level_key = dsl.skill_level_key) AS inner_table
WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;

-- max_skill_grade_employee
-- похожая метрика, но rolling_max по календарному году ??  (мб получать максимум из нее)
 
UPDATE DM.fact_empl_skills AS fes 
SET max_skill_grade_employee = inner_table.max_skill_grade_employee
FROM (select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
, 	dd.calendar_year
,	dsl.skill_grade
,	MAX(dsl.skill_grade) over(partition by employee_key, skill_key order by dd.date ASC) as max_skill_grade_employee -- , calendar_year
from dm.fact_empl_skills fes
left join dm.dim_date as dd
on fes.date_key = dd.date_key
left join dm.dim_skill_level as dsl
on fes.skill_level_key = dsl.skill_level_key) AS inner_table
WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;

--count_skills (по годам count где уровень скилла = max_skill_grade_employee)

UPDATE DM.fact_empl_skills AS fes 
SET count_skills = inner_table.count_skills
FROM (
	select 	curr_max.employee_key, curr_max.skill_key, curr_max.date_key, curr_max.skill_level_key
	,	SUM(curr_max.is_current_max) OVER(partition by curr_max.employee_key, dd.calendar_year) as count_skills
	from (
		select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
		,	case when dsl.skill_grade = fes.max_skill_grade_employee then 1
				else 0 end as is_current_max
		from dm.fact_empl_skills fes  					-- 1 когда текущий уровень навыка - максимальный за год
		left join dm.dim_skill_level as dsl
		on fes.skill_level_key = dsl.skill_level_key) as curr_max

	left join dm.dim_date as dd
	on curr_max.date_key = dd.date_key) AS inner_table

WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;


-- avg_skill_grade_employee
-- (по скиллам одной категории сейчас), считаю через current_skill_level

UPDATE DM.fact_empl_skills AS fes 
SET avg_skill_grade_employee = inner_table.avg_skill_grade_employee
FROM (
	select ag.employee_key, ag.skill_key, ag.date_key, ag.skill_level_key
	,	ROUND(ag.avg_grade, 3) as avg_skill_grade_employee
	from (
		select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
		,	AVG(fes.current_skill_level) over(partition by fes.employee_key, ds.skill_type) as avg_grade 
		from dm.fact_empl_skills fes
		left join dm.dim_skills ds
		on fes.skill_key = ds.skill_key) as ag) AS inner_table
WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;

-- avg_skill_grade_position (похожая, но среднее по категориям для каждой позиции)

UPDATE DM.fact_empl_skills AS fes 
SET avg_skill_grade_position = inner_table.avg_skill_grade_position
FROM (
	select ag.employee_key, ag.skill_key, ag.date_key, ag.skill_level_key
	,	ROUND(ag.avg_grade, 3) as avg_skill_grade_position
	from (
		select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
		,	AVG(fes.current_skill_level) over(partition by de.position, ds.skill_type) as avg_grade 
		from dm.fact_empl_skills fes
		left join dm.dim_skills ds
		on fes.skill_key = ds.skill_key
		left join dm.dim_employee de
		on fes.employee_key = de.employee_key) as ag) AS inner_table
WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;

--count_skill_per_year_employee
-- (Для каждого года сколько раз человек улучшился по всем скиллам - в шт.)

UPDATE DM.fact_empl_skills AS fes 
SET count_skill_per_year_employee = inner_table.count_skill_per_year_employee
FROM (
	select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
		,	COUNT(*) over(partition by fes.employee_key, dd.calendar_year) as count_skill_per_year_employee 
		from dm.fact_empl_skills fes
		left join dm.dim_date as dd
		on fes.date_key = dd.date_key) AS inner_table
WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;

-- avg_department_position_grade
-- средний грейд по должности внутри департамента

UPDATE DM.fact_empl_skills AS fes 
SET avg_department_position_grade = inner_table.avg_department_position_grade
FROM (
		select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
		,	AVG(dsl.skill_grade) over (partition by de.department, de.position) as avg_department_position_grade
		from dm.fact_empl_skills fes
		left join dm.dim_skill_level dsl
		on fes.skill_level_key = dsl.skill_level_key
		left join dm.dim_employee de 
		on fes.employee_key = de.employee_key ) AS inner_table
WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;

-- count_skill_department
-- Для каждого года сколько раз люди одной должности внутри одного департамента улучшили свои навыки по всем скиллам - в шт.

UPDATE DM.fact_empl_skills AS fes 
SET count_skill_department = inner_table.count_skill_department
FROM (
		select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
		,	COUNT(*) over(partition by dd.calendar_year, de.department, de.position) as count_skill_department 
		from dm.fact_empl_skills fes
		left join dm.dim_date as dd
		on fes.date_key = dd.date_key
		left join dm.dim_employee de
		on fes.employee_key = de.employee_key ) AS inner_table
WHERE fes.employee_key = inner_table.employee_key 
	and fes.skill_key = inner_table.skill_key 
	and fes.date_key = inner_table.date_key 
	and fes.skill_level_key = inner_table.skill_level_key;



-- -- avg__now
-- --count_skills_by_position
-- --по каждому сотруднику в разрезе должности считается сколько раз встретился тот или иной навык
-- -- ( например MySQL) для графика 2
-- -- обновление уровня скилла не должно считаться за 2 записи ??
-- select fes.employee_key, fes.skill_key, fes.date_key, fes.skill_level_key
-- , 	de.position
-- ,	ds.skill_name
-- --,	MAX(dsl.skill_grade) over(partition by employee_key, calendar_year, skill_key) as current_skill_level
-- from dm.fact_empl_skills fes
-- left join dm.dim_employee as de
-- on fes.employee_key = de.employee_key
-- left join dm.dim_skills as ds
-- on fes.skill_key = ds.skill_key

-- avg_skill_grade_emploee
-- вычисляется как среднее по грейдам владения определенных навыков по сотруднику
-- в какой момент ?


-- avg_skill_grade_position
-- вычисляется как среднее по грейдам владения определенных навыков по должностям









select de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key, Max(grade_level) from ddl.employee_database as ed
	left join ddl.grade as g
	on ed.grade_id = g.grade_id -- ???
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             -- первый ключ 
	left join dm.dim_skills ds  
	on ds.skill_id = ed.bd_id and skill_type = 1   -- второй ключ
	left join dm.dim_date dd
	on dd.date = '2023-12-31'                      -- тут вопросы, третий ключ
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and skill_level_type = 1        -- четвертый ключ
where ed.date < '2023-12-31'
group by de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key

-- Вариант метрики ??
select *
from (select ed.employee_id, ed.bd_id, ed.grade_id, g.grade_level, ed.date, de.employee_key, ds.skill_key, dd.date_key, dsl.skill_level_key,
	MAX(g.grade_level) over(partition by ed.employee_id, ed.bd_id) from ddl.employee_database as ed
	left join ddl.grade as g
	on ed.grade_id = g.grade_id -- ???
	left join dm.dim_employee de
	on de.employee_id = ed.employee_id             -- первый ключ 
	left join dm.dim_skills ds  
	on ds.skill_id = ed.bd_id and skill_type = 1   -- второй ключ
	left join dm.dim_date dd
	on dd.date = '2023-12-31'                      -- тут вопросы, третий ключ
	left join dm.dim_skill_level dsl
	on dsl.skill_level_id = ed.grade_id and dm.skill_level_type = 1        -- четвертый ключ
where ed.date < '2023-12-31'
order by ed.employee_id, ed.bd_id) as max_skills
where employee_id = 3631;  -- 3631   3631    4015   4031   4267