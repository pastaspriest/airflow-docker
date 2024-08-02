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
	fullname TEXT, 
	picture_url TEXT
);

CREATE TABLE IF NOT EXISTS DM.fact_empl_skills (
	employee_key int4,
	skill_key int4, 
	date_key int4,	
	skill_level_key int4
);
-- 2 Куб

CREATE TABLE IF NOT EXISTS dm.dim_year(
	year_key serial,
	calendar_year int4
);

CREATE TABLE IF NOT EXISTS dm.dim_position(
	position_key serial,
	position TEXT,
	position_count int4 
);

CREATE TABLE IF NOT EXISTS dm.dim_department(
	department_key serial,
	department TEXT,
	department_count int4
);

CREATE TABLE IF NOT EXISTS dm.fact_pos_year(
	position_key int4,
    department_key int4,
	year_key int4,
	skill_key int4
);


-- после добавления всех метрик будет в виде:
-- CREATE TABLE IF NOT EXISTS DM.fact_empl_skills (
-- 	employee_key int4,
-- 	skill_key int4,
-- 	date_key int4,
-- 	skill_level_key int4,
-- 	count_skills int4,
-- 	current_skill_level int4,             
-- 	max_skill_grade_employee int4,
-- 	avg_skill_grade_employee numeric,
-- 	avg_skill_grade_position numeric,
-- 	count_skill_per_year_employee int4,   
-- 	avg_department_position_grade numeric,
-- 	count_skill_department int4
-- );