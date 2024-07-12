CREATE SCHEMA IF NOT EXISTS ODS;

CREATE TABLE IF NOT EXISTS ODS.database (
	bd_name TEXT NOT NULL,
	bd_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_database (
	employee_id int4 NULL,
	update_day date NULL,
	bd_id int4 NULL,
	grade_id int4 NULL,
	employee_database_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.instrument (
	instrument_name TEXT NOT NULL,
	instrument_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_instrument (
	employee_id int4 NULL,
	update_day date NULL,
	instrument_id int4 NULL,
	grade_id int4 NULL,
	employee_instrument_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_education (
	employee_id int4 NULL,
	education_id int4 NULL,
	qualification TEXT NULL,
	employee_education_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL,
	year int4 NULL,
	school_name TEXT NULL,
	fiction_name TEXT NULL,
	faculty TEXT NULL,
	specialty TEXT NULL
);

CREATE TABLE IF NOT EXISTS ODS.industry (
	industry_name TEXT NOT NULL,
	industry_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_industry (
	employee_id int4 NULL,
	update_day date NULL,
	industry_id int4 NULL,
	industry_level_id int4 NULL,
	employee_industry_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_platform (
	employee_id int4 NULL,
	update_day date NULL,
	platform_id int4 NULL,
	grade_id int4 NULL,
	employee_platform_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.platform (
	platform_name TEXT NOT NULL,
	platform_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.subject (
	subject_name TEXT NOT NULL,
	subject_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_ide (
	employee_id int4 NULL,
	update_day date NULL,
	ide_id int4 NULL,
	grade_id int4 NULL,
	employee_ide_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_subject (
	employee_id int4 NULL,
	update_day date NULL,
	subject_id int4 NULL,
	subject_level_id int4 NULL,
	employee_subject_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);
-- много проблемных полей --------------------------------------
CREATE TABLE IF NOT EXISTS ODS.resume (
	employee_id int4 NOT NULL,
	resume_id int4 NOT NULL,
	activity TEXT NULL,
	education_ids TEXT NULL,
	sertificate_ids TEXT NULL,
	language_ids TEXT NULL,
	database_ids TEXT NULL,
	instrument_ids TEXT NULL,
	industry_ids TEXT NULL,
	platform_ids TEXT NULL,
	subject_ids TEXT NULL,
	ide_ids TEXT NULL,
	system_type_ids TEXT NULL,
	framework_ids TEXT NULL,
	programming_language_ids TEXT NULL,
	technology_ids TEXT NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_sertificate (
	employee_id int4 NULL,
	update_day date NULL,
	sertificate_name TEXT NULL,
	organisation_name TEXT NULL,
	employee_sertificate_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	year int4 NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee (
	employee_id int4 NOT NULL,
	department TEXT NULL,
	dob date NULL,
	activity TEXT NULL,
	gender TEXT NULL,
	name TEXT NULL,
	surname TEXT NULL,
	last_authentification date NULL,
	position TEXT NULL,
	cfo TEXT NULL,
	regestration_date date NULL,
	update_day date NULL,
	e_mail TEXT NULL,
	login TEXT NULL,
	company TEXT NULL,
	city TEXT NULL
);

CREATE TABLE IF NOT EXISTS ODS.ide (
	ide_name TEXT NOT NULL,
	ide_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_technology (
	employee_id int4 NULL,
	update_day date NULL,
	technology_id int4 NULL,
	grade_id int4 NULL,
	employee_technology_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.technology (
	technology_name TEXT NOT NULL,
	technology_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.system_type (
	system_type_name TEXT NOT NULL,
	system_type_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.education (
	education TEXT NOT NULL,
	education_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.language_level (
	language_level_name TEXT NOT NULL,
	language_level_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.industry_level (
	industry_level_name TEXT NOT NULL,
	industry_level_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.grade (
	grade_name TEXT NOT NULL,
	grade_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.framework (
	framework_name TEXT NOT NULL,
	framework_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_language (
	employee_id int4 NULL,
	update_day date NULL,
	language_id int4 NULL,
	language_level_id int4 NULL,
	employee_language_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL
);

CREATE TABLE IF NOT EXISTS ODS.programming_language (
	programming_language_name TEXT NOT NULL,
	grade_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.language (
	language_name TEXT NOT NULL,
	language_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_system_type (
	employee_id int4 NULL,
	update_day date NULL,
	system_type_id int4 NULL,
	grade_id int4 NULL,
	employee_system_type_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.subject_level (
	subject_level_name TEXT NOT NULL,
	subject_level_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	update_day date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_framework (
	employee_id int4 NULL,
	update_day date NULL,
	grade_id int4 NULL,
	framework_id int4 NULL,
	employee_framework_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);

CREATE TABLE IF NOT EXISTS ODS.employee_programming_language (
	employee_id int4 NULL,
	update_day date NULL,
	grade_id int4 NULL,
	programming_language_id int4 NULL,
	employee_programming_language_id int4 NOT NULL,
	activity TEXT NULL,
	sort int4 NULL,
	date date NULL
);