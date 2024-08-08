CREATE SCHEMA IF NOT EXISTS DDL;

CREATE TABLE IF NOT EXISTS DDL.database (
	bd_name TEXT,
	bd_id int4
);

CREATE TABLE IF NOT EXISTS DDL.instrument (
	instrument_name TEXT,
	instrument_id int4
);

CREATE TABLE IF NOT EXISTS DDL.industry (
	industry_name TEXT,
	industry_id int4
);

CREATE TABLE IF NOT EXISTS DDL.platform (
	platform_name TEXT,
	platform_id int4
);

CREATE TABLE IF NOT EXISTS DDL.subject (
	subject_name TEXT,
	subject_id int4
);

CREATE TABLE IF NOT EXISTS DDL.ide (
	ide_name TEXT,
	ide_id int4
);

CREATE TABLE IF NOT EXISTS DDL.technology (
	technology_name TEXT,
	technology_id int4
);

CREATE TABLE IF NOT EXISTS DDL.system_type (
	system_type_name TEXT,
	system_type_id int4
);

CREATE TABLE IF NOT EXISTS DDL.education (
	education_name TEXT,
	education_id int4,
	education_grade int4  -- Добаленная метрика для градации образования 
);

CREATE TABLE IF NOT EXISTS DDL.language_level (
	language_level_name TEXT,
	language_level_id int4,
	language_level_grade int4
);

CREATE TABLE IF NOT EXISTS DDL.subject_industry_level (
	subject_industry_level_name TEXT,
	subject_industry_level_id int4,
	subject_industry_level_grade int4
);

CREATE TABLE IF NOT EXISTS DDL.grade (
	grade_name TEXT,
	grade_id int4,
	grade_level int4
);

CREATE TABLE IF NOT EXISTS DDL.framework (
	framework_name TEXT,
	framework_id int4
);

CREATE TABLE IF NOT EXISTS DDL.programming_language (
	programming_language_name TEXT,
	programming_language_id int4
);

CREATE TABLE IF NOT EXISTS DDL.language (
	language_name TEXT,
	language_id int4
);

CREATE TABLE IF NOT EXISTS DDL.employee (
	employee_id int4,
	department TEXT,	-- Восстановить дерево / просто убрать точки
	activity TEXT,     	-- Использовать при расчете метрик (181 человек уволен, 302 работают)
	fullname TEXT,      -- Сгенерировали
	picture_url TEXT,   -- Сгенерировали
	position TEXT
);

CREATE TABLE IF NOT EXISTS DDL.employee_education (
	employee_id int4,
	education_id int4,
	year int4
);

CREATE TABLE IF NOT EXISTS DDL.employee_database (
	employee_id int4,
	bd_id int4,
	grade_id int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_instrument (
	employee_id int4,
	instrument_id int4,
	grade_id int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_industry (
	employee_id int4,
	industry_id int4,
	industry_level_id int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_platform (
	employee_id int4,
	platform_id int4,
	grade_id int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_ide (
	employee_id int4,
	ide_id int4,
	grade_id int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_subject (
	employee_id int4,
	subject_id int4,
	subject_level_id int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_technology (
	employee_id int4,
	technology_id int4,
	grade_id int4,
	date date
);



CREATE TABLE IF NOT EXISTS DDL.employee_language (
	employee_id int4,  
	language_id int4,
	language_level_id int4
);


CREATE TABLE IF NOT EXISTS DDL.employee_system_type (
	employee_id int4,
	system_type_id int4,
	grade_id int4,
	date date
);


CREATE TABLE IF NOT EXISTS DDL.employee_framework (
	employee_id int4,
	grade_id int4,
	framework_id int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_programming_language (
	employee_id int4,
	grade_id int4,
	programming_language_id int4,
	date date
);

-- Новая таблица с переводом старых грейдов в новые
CREATE TABLE IF NOT EXISTS ddl.grade_updates(
    old_grade_name TEXT,
    new_grade_name TEXT,
    old_grade_id int4,
    grade_level int4,
	new_grade_id int4,
	grade_type int4
);
