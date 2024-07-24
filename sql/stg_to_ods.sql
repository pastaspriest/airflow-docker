--базы_данных 
INSERT INTO ODS.database
SELECT
	название AS bd_name
,	id AS bd_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.базы_данных;

--отрасли
INSERT INTO ODS.industry
SELECT
	название industry
,	id industry_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.отрасли;

--инструменты
INSERT INTO ODS.instrument
SELECT
	название instrument_name
,	id instrument_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.инструменты;

--платформы
INSERT INTO ODS.platform
SELECT
	название platform_name
,	id platform_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.платформы;

--предметная_область
INSERT INTO ODS.subject
SELECT
	название subject_name
,	id subject_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.предметная_область;

--среды_разработки
INSERT INTO ODS.ide
SELECT
	название ide_name
,	id ide_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.среды_разработки;

--технологии
INSERT INTO ODS.technology
SELECT
	название technology_name
,	id technology_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.технологии;

--типы_систем
INSERT INTO ODS.system_type
SELECT
	название system_type_name
,	id system_type_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.типы_систем;

--уровни_знаний_в_отрасли
INSERT INTO ODS.industry_level
SELECT
	название industry_level_name
,	id industry_level_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.уровни_знаний_в_отрасли;

--уровень_образования
INSERT INTO ODS.education
SELECT
	название education_name
,	id education_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.уровень_образования;

--уровни_владения_ин
INSERT INTO ODS.language_level
SELECT
	название language_level_name
,	id language_level_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.уровни_владения_ин;


--уровни_знаний
INSERT INTO ODS.grade
SELECT
	название grade_name
,	id grade_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.уровни_знаний;

--фреймворки
INSERT INTO ODS.framework
SELECT
	название framework_name
,	id framework_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.фреймворки;

--языки_программирования
INSERT INTO ODS.programming_language
SELECT
	название programming_language_name
,	id programming_language_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.языки_программирования;

--языки
INSERT INTO ODS.language
SELECT
	название language_name
,	id language_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.языки;

--уровни_знаний_в_предметной_област
INSERT INTO ODS.subject_level
SELECT
	название subject_level_name
,	id subject_level_id
,	CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("Дата изм." AS DATE) AS update_day
FROM stg.уровни_знаний_в_предметной_област;


-- базы_данных_и_уровень_знаний_сотру
INSERT INTO ODS.employee_database
select 
    substring(название, '[0-9]{1,}')::int AS employee_id
,   CAST("Дата изм." AS DATE) AS update_day
,   substring("Базы данных", '.*\[(.*)\]')::int AS bd_id
,   substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,	id AS employee_database_id
,   CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("дата" AS DATE) AS date
from stg.базы_данных_и_уровень_знаний_сотру;

--резюмедар  
INSERT INTO ODS.resume
SELECT
	"UserID" employee_id
,	"ResumeID" resume_id
,	Активность AS activity
,	Образование AS education_ids
,	"Сертификаты/Курсы" AS sertificate_ids
,	Языки AS language_ids
,	Базыданных AS database_ids
,	Инструменты AS instrument_ids
,	Отрасли AS industry_ids
,	Платформы AS platform_ids
,	Предметныеобласти AS subject_ids
,	Средыразработки AS ide_ids
,	Типысистем AS system_type_ids
,	Фреймворки AS framework_ids
,	Языкипрограммирования AS programming_language_ids
,	Технологии AS technology_ids
FROM stg.резюмедар;

--инструменты_и_уровень_знаний_сотр
INSERT INTO ODS.employee_instrument
SELECT
	substring(название, '[0-9]{1,}')::int employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	substring(инструменты, '.*\[(.*)\]')::int instrument_id
,	substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,	id AS employee_instrument_id
,   CAST(активность AS TEXT) AS activity
,	"Сорт." AS sort
,	CAST("дата" AS DATE) AS date
FROM stg.инструменты_и_уровень_знаний_сотр;


--опыт_сотрудника_в_отраслях
INSERT INTO ODS.employee_industry(employee_id, update_day, employee_industry_id, sort, date,
industry_id, industry_level_id, activity)
SELECT
	"User ID" employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_industry_id
,	"Сорт." AS sort
,	CAST("дата" AS DATE) AS date
,	substring(отрасли, '[0-9]{1,}')::int AS industry_id
,	substring("Уровень знаний в отрасли", '.*\[(.*)\]')::int AS industry_level_id
,   CAST(активность AS TEXT) AS activity
FROM stg.опыт_сотрудника_в_отраслях;

--платформы_и_уровень_знаний_сотруд
INSERT INTO ODS.employee_platform(employee_id, update_day, employee_platform_id,
sort, date, platform_id, grade_id, activity)
SELECT
	"User ID" AS employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_platform_id
,	"Сорт." AS sort
,	CAST("дата" AS DATE) AS date
,	substring(платформы, '.*\[(.*)\]')::int AS platform_id
,	substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,   CAST(активность AS TEXT) AS activity
FROM stg.платформы_и_уровень_знаний_сотруд;

--среды_разработки_и_уровень_знаний_
INSERT INTO ODS.employee_ide(employee_id, update_day, employee_ide_id, sort,
date, ide_id, grade_id, activity)
SELECT
	substring(название, '[0-9]{1,}')::int employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_ide_id
,	"Сорт." AS sort
,	CAST("дата" AS DATE) AS date
,	substring("Среды разработки", '.*\[(.*)\]')::int AS ide_id
,	substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,   CAST(активность AS TEXT) AS activity
FROM stg.среды_разработки_и_уровень_знаний_;

--опыт_сотрудника_в_предметных_обла
INSERT INTO ODS.employee_subject(employee_id, update_day, employee_subject_id,
sort, date, subject_id, subject_level_id, activity)
SELECT
	"User ID" AS employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_subject_id
,	"Сорт." AS sort
,	CAST("дата" AS DATE) AS date
,	substring("Предментые области", '.*\[(.*)\]')::int AS subject_id
,	substring("Уровень знаний в предметной облас", '.*\[(.*)\]')::int AS subject_level_id
,   CAST(активность AS TEXT) AS activity
FROM stg.опыт_сотрудника_в_предметных_обла;


--сертификаты_пользователей
INSERT INTO ODS.employee_sertificate(employee_id, update_day, employee_sertificate_id,
year, sertificate_name, organisation_name, sort, activity)
SELECT
	"User ID" AS employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_sertificate_id
,	"Год сертификата" AS year
,	CAST("Наименование сертификата" AS TEXT) AS sertificate_name
,	CAST("Организация, выдавшая сертификат" AS TEXT) AS	organisation_name
,	"Сорт." AS sort
,   CAST(активность AS TEXT) AS activity
FROM stg.сертификаты_пользователей;

--сотрудники_дар
INSERT INTO ODS.employee(employee_id, dob, gender, surname, name, last_authentification,
position, cfo, regestration_date, update_day, department, e_mail, login, company, city, activity)
SELECT
	id AS employee_id
,	CAST("Дата рождения" AS DATE) AS dob
,	пол AS gender
,	фамилия AS surname
,	имя AS name
,	CAST("Последняя авторизация" AS DATE) AS last_authentification
,	должность AS position
,	цфо AS cfo
,	CAST("Дата регистрации" AS DATE) AS regestration_date
,	CAST("Дата изменения" AS DATE) AS update_day
,	подразделения AS department
,	"E-Mail" AS e_mail
,	логин AS login
,	компания AS company
,	"Город проживания" AS city
,   активность AS activity
FROM stg.сотрудники_дар;

--технологии_и_уровень_знаний_сотру
INSERT INTO ODS.employee_technology(employee_id, update_day, employee_technology_id,
date, technology_id, grade_id, sort, activity)
SELECT
	substring(название, '[0-9]{1,}')::int employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_technology_id
,	CAST("дата" AS DATE) AS date
,   substring(технологии, '.*\[(.*)\]')::int AS technology_id
,	substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,	"Сорт." AS sort
,   CAST(активность AS TEXT) AS activity
FROM stg.технологии_и_уровень_знаний_сотру;

--языки_пользователей
INSERT INTO ODS.employee_language(employee_id, update_day, employee_language_id, language_id,
language_level_id, sort, activity)
SELECT
	substring(название, '[0-9]{1,}')::int employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_language_id
,   substring(язык, '.*\[(.*)\]')::int AS language_id
,   substring("Уровень знаний ин. языка", '.*\[(.*)\]')::int AS language_level_id
,	"Сорт." AS sort
,   активность AS activity
FROM stg.языки_пользователей;

--типы_систем_и_уровень_знаний_сотру
INSERT INTO ODS.employee_system_type(employee_id, update_day, employee_system_type_id,
system_type_id, grade_id, date, sort, activity)
SELECT
	substring(название, '[0-9]{1,}')::int employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_system_type_id
,   substring("Типы систем", '.*\[(.*)\]')::int AS system_type_id
,	substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,	CAST("дата" AS DATE) AS date
,	"Сорт." AS sort
,   CAST(активность AS TEXT) AS activity
FROM stg.типы_систем_и_уровень_знаний_сотру;

--фреймворки_и_уровень_знаний_сотру
INSERT INTO ODS.employee_framework(employee_id, update_day, employee_framework_id, grade_id,
framework_id, date, sort, activity)
SELECT
	substring(название, '[0-9]{1,}')::int employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_framework_id
,	substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,	substring(фреймворки, '.*\[(.*)\]')::int AS framework_id
,	CAST("дата" AS DATE) AS date
,	"Сорт." AS sort
,   активность AS activity	
FROM stg.фреймворки_и_уровень_знаний_сотру;

--языки_программирования_и_уровень
INSERT INTO ODS.employee_programming_language(employee_id, update_day, employee_programming_language_id,
grade_id, programming_language_id, date, sort, activity)
SELECT
	substring(название, '[0-9]{1,}')::int employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_programming_language_id
,	substring("Уровень знаний", '.*\[(.*)\]')::int AS grade_id
,	substring("Языки программирования", '.*\[(.*)\]')::int as programming_language_id
,	CAST("дата" AS DATE) AS date
,	"Сорт." AS sort
,   активность AS activity		
FROM stg.языки_программирования_и_уровень;

--образование_пользователей
INSERT INTO ODS.employee_education(employee_id, update_day, employee_education_id, education_id,
qualification, activity, sort, year, specialty, school_name, fiction_name, faculty)
SELECT
	"User ID" AS employee_id
,	CAST("Дата изм." AS DATE) AS update_day
,	id AS employee_education_id
,	substring("Уровень образование", '.*\[(.*)\]')::int AS education_id
,	квалификация AS qualification
,   активность AS activity	
,	"Сорт." AS sort
,	"Год окончания" AS year
,	специальность AS specialty
,   "Название учебного заведения" AS school_name
,	"Фиктивное название" AS fiction_name
,	"Факультет, кафедра" AS faculty
FROM stg.образование_пользователей;
