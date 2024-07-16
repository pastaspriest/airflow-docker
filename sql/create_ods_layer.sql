CREATE SCHEMA IF NOT EXISTS ODS;

CREATE TABLE IF NOT EXISTS ODS.database (
	bd_name TEXT,
	bd_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_database (
	employee_id int4,
	update_day date,
	bd_id int4,
	grade_id int4,
	employee_database_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.instrument (
	instrument_name TEXT,
	instrument_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_instrument (
	employee_id int4,
	update_day date,
	instrument_id int4,
	grade_id int4,
	employee_instrument_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_education (
	employee_id int4,
	education_id int4,
	qualification TEXT,
	employee_education_id int4,
	activity TEXT,
	sort int4,
	update_day date,
	year int4,
	school_name TEXT,
	fiction_name TEXT,
	faculty TEXT,
	specialty TEXT 
);

CREATE TABLE IF NOT EXISTS ODS.industry (
	industry_name TEXT NOT,
	industry_id int4 NOT,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_industry (
	employee_id int4,
	update_day date,
	industry_id int4,
	industry_level_id int4,
	employee_industry_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_platform (
	employee_id int4,
	update_day date,
	platform_id int4,
	grade_id int4,
	employee_platform_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.platform (
	platform_name TEXT,
	platform_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.subject (
	subject_name TEXT,
	subject_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_ide (
	employee_id int4,
	update_day date,
	ide_id int4,
	grade_id int4,
	employee_ide_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_subject (
	employee_id int4,
	update_day date,
	subject_id int4,
	subject_level_id int4,
	employee_subject_id int4,
	activity TEXT,
	sort int4,
	date date 
);
-- много проблемных полей --------------------------------------
CREATE TABLE IF NOT EXISTS ODS.resume (
	employee_id int4,
	resume_id int4,
	activity TEXT,
	education_ids TEXT,
	sertificate_ids TEXT,
	language_ids TEXT,
	database_ids TEXT,
	instrument_ids TEXT,
	industry_ids TEXT,
	platform_ids TEXT,
	subject_ids TEXT,
	ide_ids TEXT,
	system_type_ids TEXT,
	framework_ids TEXT,
	programming_language_ids TEXT,
	technology_ids TEXT 
);

CREATE TABLE IF NOT EXISTS ODS.employee_sertificate (
	employee_id int4,
	update_day date,
	sertificate_name TEXT,
	organisation_name TEXT,
	employee_sertificate_id int4,
	activity TEXT,
	sort int4,
	year int4 
);

CREATE TABLE IF NOT EXISTS ODS.employee (
	employee_id int4,
	department TEXT,
	dob date,
	activity TEXT,
	gender TEXT,
	name TEXT,
	surname TEXT,
	last_authentification date,
	position TEXT,
	cfo TEXT,
	regestration_date date,
	update_day date,
	e_mail TEXT,
	login TEXT,
	company TEXT,
	city TEXT 
);

CREATE TABLE IF NOT EXISTS ODS.ide (
	ide_name TEXT,
	ide_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_technology (
	employee_id int4,
	update_day date,
	technology_id int4,
	grade_id int4,
	employee_technology_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.technology (
	technology_name TEXT,
	technology_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.system_type (
	system_type_name TEXT,
	system_type_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.education (
	education_name TEXT,
	education_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.language_level (
	language_level_name TEXT,
	language_level_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.industry_level (
	industry_level_name TEXT,
	industry_level_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.grade (
	grade_name TEXT,
	grade_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.framework (
	framework_name TEXT,
	framework_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_language (
	employee_id int4,
	update_day date,
	language_id int4,
	language_level_id int4,
	employee_language_id int4,
	activity TEXT,
	sort int4 
);

CREATE TABLE IF NOT EXISTS ODS.programming_language (
	programming_language_name TEXT,
	programming_language_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.language (
	language_name TEXT,
	language_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_system_type (
	employee_id int4,
	update_day date,
	system_type_id int4,
	grade_id int4,
	employee_system_type_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.subject_level (
	subject_level_name TEXT,
	subject_level_id int4,
	activity TEXT,
	sort int4,
	update_day date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_framework (
	employee_id int4,
	update_day date,
	grade_id int4,
	framework_id int4,
	employee_framework_id int4,
	activity TEXT,
	sort int4,
	date date 
);

CREATE TABLE IF NOT EXISTS ODS.employee_programming_language (
	employee_id int4,
	update_day date,
	grade_id int4,
	programming_language_id int4,
	employee_programming_language_id int4,
	activity TEXT,
	sort int4,
	date date 
);