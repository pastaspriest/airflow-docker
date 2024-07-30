-- init_script срабатывает 1 раз после ресета БД
-- Создаем все схемы

CREATE SCHEMA IF NOT EXISTS STG;
CREATE SCHEMA IF NOT EXISTS ODS;
CREATE SCHEMA IF NOT EXISTS DDL;
CREATE SCHEMA IF NOT EXISTS DM;


-- Создаем доп таблицы (заполнятся через airflow) (в stg или отдельный слой, например utils ?)

-- Изменения в уровнях знания, численная оценка
CREATE TABLE stg.updated_grades (
	old_grade TEXT,
	new_grade TEXT,
	grade_level int4
);

-- url для изображений (сейчас по департаментам чтобы не делать 300 картинок)
CREATE TABLE stg.department_pictures (
	department TEXT,
	pic_url TEXT
);

-- Изменения в названиях департаментов
CREATE TABLE stg.fixed_departments (
	old_department_name TEXT,
	department TEXT
);

-- Сгенерированные имена для удобства при разработке и наглядности демо
CREATE TABLE stg.generated_names (
	employee_id int4,
	full_name TEXT
);

--Создаем все функции ???

-- Очистка stg
create or replace function stg.clearing_tables ()
RETURNS void
language plpgsql
as $$
begin
	DELETE FROM stg.базы_данных;
	DELETE FROM stg.базы_данных_и_уровень_знаний_сотру;
	DELETE FROM stg.инструменты;
	DELETE FROM stg.инструменты_и_уровень_знаний_сотр;
	DELETE FROM stg.образование_пользователей;
	DELETE FROM stg.опыт_сотрудника_в_отраслях;
	DELETE FROM stg.опыт_сотрудника_в_предметных_обла;
	DELETE FROM stg.отрасли;
	DELETE FROM stg.платформы;
	DELETE FROM stg.платформы_и_уровень_знаний_сотруд;
	DELETE FROM stg.предметная_область;
	DELETE FROM stg.резюмедар;
	DELETE FROM stg.сертификаты_пользователей;
	DELETE FROM stg.сотрудники_дар;
	DELETE FROM stg.среды_разработки;
	DELETE FROM stg.среды_разработки_и_уровень_знаний_;
	DELETE FROM stg.технологии;
	DELETE FROM stg.технологии_и_уровень_знаний_сотру;
	DELETE FROM stg.типы_систем;
	DELETE FROM stg.типы_систем_и_уровень_знаний_сотру;
	DELETE FROM stg.уровень_образования;
	DELETE FROM stg.уровни_владения_ин;
	DELETE FROM stg.уровни_знаний;
	DELETE FROM stg.уровни_знаний_в_отрасли;
	DELETE FROM stg.уровни_знаний_в_предметной_област;
	DELETE FROM stg.фреймворки;
	DELETE FROM stg.фреймворки_и_уровень_знаний_сотру;
	DELETE FROM stg.языки;
	DELETE FROM stg.языки_пользователей;
	DELETE FROM stg.языки_программирования;
	DELETE FROM stg.языки_программирования_и_уровень;
END;
$$;

-- Очистка ods
create or replace function stg.clearing_tables ()
RETURNS void
language plpgsql
as $$
begin
	delete from ods.database;
	delete from ods.education;
	delete from ods.employee;
	delete from ods.employee_database;
	delete from ods.employee_education;
	delete from ods.employee_framework;
	delete from ods.employee_ide;
	delete from ods.employee_industry;
	delete from ods.employee_instrument;
	delete from ods.employee_language;
	delete from ods.employee_platform;
	delete from ods.employee_programming_language;
	delete from ods.employee_sertificate;
	delete from ods.employee_subject;
	delete from ods.employee_system_type;
	delete from ods.employee_technology;
	delete from ods.framework;
	delete from ods.grade;
	delete from ods.ide;
	delete from ods.industry;
	delete from ods.industry_level;
	delete from ods.instrument;
	delete from ods.language;
	delete from ods.language_level;
	delete from ods.platform;
	delete from ods.programming_language;
	delete from ods.resume;
	delete from ods.subject;
	delete from ods.subject_level;
	delete from ods.system_type;
	delete from ods.technology;
END;
$$;

-- Очистка ddl
create or replace function stg.clearing_tables ()
RETURNS void
language plpgsql
as $$
begin
	delete from ddl.database;
	delete from ddl.education;
	delete from ddl.education_updates;
	delete from ddl.employee;
	delete from ddl.employee_database;
	delete from ddl.employee_education;
	delete from ddl.employee_framework;
	delete from ddl.employee_ide;
	delete from ddl.employee_industry;
	delete from ddl.employee_instrument;
	delete from ddl.employee_language;
	delete from ddl.employee_platform;
	delete from ddl.employee_programming_language;
	delete from ddl.employee_subject;
	delete from ddl.employee_system_type;
	delete from ddl.employee_technology;
	delete from ddl.framework;
	delete from ddl.grade;
	delete from ddl.grade_updates;
	delete from ddl.ide;
	delete from ddl.industry;
	delete from ddl.instrument;
	delete from ddl.language;
	delete from ddl.language_level;
	delete from ddl.platform;
	delete from ddl.programming_language;
	delete from ddl.subject;
	delete from ddl.subject_industry_level;
	delete from ddl.system_type;
	delete from ddl.technology;
END;
$$;

-- Очистка dm
create or replace function stg.clearing_tables ()
RETURNS void
language plpgsql
as $$
begin
	delete from dm.dim_date;
	delete from dm.dim_employee;
	delete from dm.dim_skill_level;
	delete from dm.dim_skills;
	delete from dm.fact_empl_skills;
END;
$$;