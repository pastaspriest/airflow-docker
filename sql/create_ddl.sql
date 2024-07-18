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

-- объединена с industry_level
--CREATE TABLE IF NOT EXISTS DDL.subject_level (
--	subject_level_name TEXT,
--	subject_level_id int4
--);


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


-- много проблемных полей было в ODS, не переносится в ddl --------------------------------------
--CREATE TABLE IF NOT EXISTS DDL.resume (
--	employee_id int4,
--	resume_id int4
--);

CREATE TABLE IF NOT EXISTS DDL.employee (
	employee_id int4,
	department TEXT,	-- Восстановить дерево ?? / просто убрать точки
--	dob date,       	-- ВСЕ ПОЛЯ ПУСТЫЕ, НАДО ГЕНЕРИТЬ ???
	activity TEXT,     -- Использовать при расчете метрик (181 человек уволен, 302 работают)
--	gender TEXT,
	name TEXT,			-- ВСЕ ПОЛЯ ПУСТЫЕ, НАДО ГЕНЕРИТЬ ???
	surname TEXT,		-- ВСЕ ПОЛЯ ПУСТЫЕ, НАДО ГЕНЕРИТЬ ???
--	last_authentification date,
	position TEXT     -- есть проблемные записи
--	cfo TEXT,
--	regestration_date date,
--	update_day date,
--	e_mail TEXT,
--	login TEXT,
--	company TEXT,   тут все пусто
--	city TEXT			-- ВСЕ ПОЛЯ ПУСТЫЕ, НАДО ГЕНЕРИТЬ ???
);

CREATE TABLE IF NOT EXISTS DDL.employee_education (
	employee_id int4,
	education_id int4,
--	qualification TEXT,      
--	employee_education_id int4,
--	activity TEXT,
--	sort int4,
--	update_day date,
	year int4
--	school_name TEXT,
--	fiction_name TEXT,
--	faculty TEXT,
--	specialty TEXT
);
--------------   Основные таблицы с вопросами ^^^^
CREATE TABLE IF NOT EXISTS DDL.employee_database (
	employee_id int4,
--	update_day date,
	bd_id int4,
	grade_id int4,
--	employee_database_id int4,
--	activity TEXT,
--	sort int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_instrument (
	employee_id int4,
--	update_day date,
	instrument_id int4,
	grade_id int4,
--	employee_instrument_id int4,
--	activity TEXT,
--	sort int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_industry (
	employee_id int4,
--	update_day date,
	industry_id int4,
	industry_level_id int4,
--	employee_industry_id int4,
--	activity TEXT,
--	sort int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_platform (
	employee_id int4,
--	update_day date,
	platform_id int4,
	grade_id int4,
--	employee_platform_id int4,
--	activity TEXT,
--	sort int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_ide (
	employee_id int4,
--	update_day date,
	ide_id int4,
	grade_id int4,
--	employee_ide_id int4,
--	activity TEXT,
--	sort int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_subject (
	employee_id int4,
--	update_day date,
	subject_id int4,
	subject_level_id int4,
--	employee_subject_id int4,
--	activity TEXT,
--	sort int4,
	date date
);


--CREATE TABLE IF NOT EXISTS DDL.employee_sertificate ( -- не используем совсем
--	employee_id int4,
--	update_day date,
--	sertificate_name TEXT,
--	organisation_name TEXT,
--	employee_sertificate_id int4,
--	activity TEXT,
--	sort int4,
--	year int4
--);


CREATE TABLE IF NOT EXISTS DDL.employee_technology (
	employee_id int4,
--	update_day date,
	technology_id int4,
	grade_id int4,
--	employee_technology_id int4,
--	activity TEXT,
--	sort int4,
	date date
);



CREATE TABLE IF NOT EXISTS DDL.employee_language (
	employee_id int4,
--	update_day date,  -- Оставить дату изменения, смотреть динамику по ней ?? + переименовать в date 
	language_id int4,
	language_level_id int4
--	employee_language_id int4,
--	activity TEXT,
--	sort int4
);


CREATE TABLE IF NOT EXISTS DDL.employee_system_type (
	employee_id int4,
--	update_day date,
	system_type_id int4,
	grade_id int4,
--	employee_system_type_id int4,
--	activity TEXT,
--	sort int4,
	date date
);


CREATE TABLE IF NOT EXISTS DDL.employee_framework (
	employee_id int4,
--	update_day date,
	grade_id int4,
	framework_id int4,
--	employee_framework_id int4,
--	activity TEXT,
--	sort int4,
	date date
);

CREATE TABLE IF NOT EXISTS DDL.employee_programming_language (
	employee_id int4,
--	update_day date,
	grade_id int4,
	programming_language_id int4,
--	employee_programming_language_id int4,
--	activity TEXT,
--	sort int4,
	date date
);