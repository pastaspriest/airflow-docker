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

