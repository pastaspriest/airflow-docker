-- stg.базы_данных определение

-- Drop table

-- DROP TABLE stg.базы_данных;

CREATE TABLE IF NOT EXISTS stg.базы_данных (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL
);

-- stg.базы_данных_и_уровень_знаний_сотру определение

-- Drop table

-- DROP TABLE stg.базы_данных_и_уровень_знаний_сотру;

CREATE TABLE IF NOT EXISTS stg.базы_данных_и_уровень_знаний_сотру (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL,
	"Базы данных" varchar(50) NULL,
	дата varchar(50) NULL,
	"Уровень знаний" varchar(50) NULL
);

-- stg.инструменты определение

-- Drop table

-- DROP TABLE stg.инструменты;

CREATE TABLE IF NOT EXISTS stg.инструменты (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL
);

-- stg.инструменты_и_уровень_знаний_сотр определение

-- Drop table

-- DROP TABLE stg.инструменты_и_уровень_знаний_сотр;

CREATE TABLE IF NOT EXISTS stg.инструменты_и_уровень_знаний_сотр (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL,
	дата varchar(50) NULL,
	инструменты varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL
);

-- stg.образование_пользователей определение

-- Drop table

-- DROP TABLE stg.образование_пользователей;

CREATE TABLE IF NOT EXISTS stg.образование_пользователей (
	"User ID" int4 NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL,
	"Уровень образование" text NULL,
	"Название учебного заведения" text NULL,
	"Фиктивное название" text NULL,
	"Факультет, кафедра" text NULL,
	специальность text NULL,
	квалификация text NULL,
	"Год окончания" int4 NULL
);

-- stg.опыт_сотрудника_в_отраслях определение

-- Drop table

-- DROP TABLE stg.опыт_сотрудника_в_отраслях;

CREATE TABLE IF NOT EXISTS stg.опыт_сотрудника_в_отраслях (
	"User ID" int4 NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL,
	дата varchar(50) NULL,
	отрасли varchar(50) NULL,
	"Уровень знаний в отрасли" varchar(128) NULL
);


-- stg.опыт_сотрудника_в_предметных_обла определение

-- Drop table

-- DROP TABLE stg.опыт_сотрудника_в_предметных_обла;

CREATE TABLE IF NOT EXISTS stg.опыт_сотрудника_в_предметных_обла (
	"User ID" int4 NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL,
	дата varchar(50) NULL,
	"Предментые области" varchar(50) NULL,
	"Уровень знаний в предметной облас" varchar(128) NULL
);


-- stg.отрасли определение

-- Drop table

-- DROP TABLE stg.отрасли;

CREATE TABLE IF NOT EXISTS stg.отрасли (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL
);


-- stg.платформы определение

-- Drop table

-- DROP TABLE stg.платформы;

CREATE TABLE IF NOT EXISTS stg.платформы (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL
);


-- stg.платформы_и_уровень_знаний_сотруд определение

-- Drop table

-- DROP TABLE stg.платформы_и_уровень_знаний_сотруд;

CREATE TABLE IF NOT EXISTS stg.платформы_и_уровень_знаний_сотруд (
	"User ID" int4 NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL,
	дата varchar(50) NULL,
	платформы varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL
);


-- stg.предметная_область определение

-- Drop table

-- DROP TABLE stg.предметная_область;

CREATE TABLE IF NOT EXISTS stg.предметная_область (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL
);


-- stg.резюмедар определение

-- Drop table

-- DROP TABLE stg.резюмедар;

CREATE TABLE IF NOT EXISTS stg.резюмедар (
	"UserID" int4 NULL,
	"ResumeID" int4 NULL,
	"Активность" text NULL,
	"Образование" text NULL,
	"Сертификаты/Курсы" text NULL,
	"Языки" text NULL,
	"Базыданных" text NULL,
	"Инструменты" text NULL,
	"Отрасли" text NULL,
	"Платформы" text NULL,
	"Предметныеобласти" text NULL,
	"Средыразработки" text NULL,
	"Типысистем" text NULL,
	"Фреймворки" text NULL,
	"Языкипрограммирования" text NULL,
	"Технологии" text NULL
);


-- stg.сертификаты_пользователей определение

-- Drop table

-- DROP TABLE stg.сертификаты_пользователей;

CREATE TABLE IF NOT EXISTS stg.сертификаты_пользователей (
	"User ID" int4 NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL,
	"Год сертификата" int4 NULL,
	"Наименование сертификата" text NULL,
	"Организация, выдавшая сертификат" text NULL
);


-- stg.сотрудники_дар определение

-- Drop table

-- DROP TABLE stg.сотрудники_дар;

CREATE TABLE IF NOT EXISTS stg.сотрудники_дар (
	id int4 NULL,
	"Дата рождения" text NULL,
	активность text NULL,
	пол text NULL,
	фамилия text NULL,
	имя text NULL,
	"Последняя авторизация" text NULL,
	должность text NULL,
	цфо text NULL,
	"Дата регистрации" text NULL,
	"Дата изменения" text NULL,
	подразделения text NULL,
	"E-Mail" text NULL,
	логин text NULL,
	компания text NULL,
	"Город проживания" text NULL
);


-- stg.среды_разработки определение

-- Drop table

-- DROP TABLE stg.среды_разработки;

CREATE TABLE IF NOT EXISTS stg.среды_разработки (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.среды_разработки_и_уровень_знаний_ определение

-- Drop table

-- DROP TABLE stg.среды_разработки_и_уровень_знаний_;

CREATE TABLE IF NOT EXISTS stg.среды_разработки_и_уровень_знаний_ (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL,
	дата varchar(50) NULL,
	"Среды разработки" varchar(50) NULL,
	"Уровень знаний" varchar(50) NULL
);


-- stg.технологии определение

-- Drop table

-- DROP TABLE stg.технологии;

CREATE TABLE IF NOT EXISTS stg.технологии (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.технологии_и_уровень_знаний_сотру определение

-- Drop table

-- DROP TABLE stg.технологии_и_уровень_знаний_сотру;

CREATE TABLE IF NOT EXISTS stg.технологии_и_уровень_знаний_сотру (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL,
	дата text NULL,
	технологии text NULL,
	"Уровень знаний" text NULL
);


-- stg.типы_систем определение

-- Drop table

-- DROP TABLE stg.типы_систем;

CREATE TABLE IF NOT EXISTS stg.типы_систем (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.типы_систем_и_уровень_знаний_сотру определение

-- Drop table

-- DROP TABLE stg.типы_систем_и_уровень_знаний_сотру;

CREATE TABLE IF NOT EXISTS stg.типы_систем_и_уровень_знаний_сотру (
	название varchar(50) NULL,
	активность varchar(50) NULL,
	"Сорт." int4 NULL,
	"Дата изм." varchar(50) NULL,
	id int4 NULL,
	дата varchar(50) NULL,
	"Типы систем" varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL
);


-- stg.уровень_образования определение

-- Drop table

-- DROP TABLE stg.уровень_образования;

CREATE TABLE IF NOT EXISTS stg.уровень_образования (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.уровни_владения_ин определение

-- Drop table

-- DROP TABLE stg.уровни_владения_ин;

CREATE TABLE IF NOT EXISTS stg.уровни_владения_ин (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.уровни_знаний определение

-- Drop table

-- DROP TABLE stg.уровни_знаний;

CREATE TABLE IF NOT EXISTS stg.уровни_знаний (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.уровни_знаний_в_отрасли определение

-- Drop table

-- DROP TABLE stg.уровни_знаний_в_отрасли;

CREATE TABLE IF NOT EXISTS stg.уровни_знаний_в_отрасли (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.уровни_знаний_в_предметной_област определение

-- Drop table

-- DROP TABLE stg.уровни_знаний_в_предметной_област;

CREATE TABLE IF NOT EXISTS stg.уровни_знаний_в_предметной_област (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.фреймворки определение

-- Drop table

-- DROP TABLE stg.фреймворки;

CREATE TABLE IF NOT EXISTS stg.фреймворки (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.фреймворки_и_уровень_знаний_сотру определение

-- Drop table

-- DROP TABLE stg.фреймворки_и_уровень_знаний_сотру;

CREATE TABLE IF NOT EXISTS stg.фреймворки_и_уровень_знаний_сотру (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL,
	дата text NULL,
	"Уровень знаний" text NULL,
	фреймворки text NULL
);


-- stg.языки определение

-- Drop table

-- DROP TABLE stg.языки;

CREATE TABLE IF NOT EXISTS stg.языки (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.языки_пользователей определение

-- Drop table

-- DROP TABLE stg.языки_пользователей;

CREATE TABLE IF NOT EXISTS stg.языки_пользователей (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL,
	язык text NULL,
	"Уровень знаний ин. языка" text NULL
);


-- stg.языки_программирования определение

-- Drop table

-- DROP TABLE stg.языки_программирования;

CREATE TABLE IF NOT EXISTS stg.языки_программирования (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL
);


-- stg.языки_программирования_и_уровень определение

-- Drop table

-- DROP TABLE stg.языки_программирования_и_уровень;

CREATE TABLE IF NOT EXISTS stg.языки_программирования_и_уровень (
	название text NULL,
	активность text NULL,
	"Сорт." int4 NULL,
	"Дата изм." text NULL,
	id int4 NULL,
	дата text NULL,
	"Уровень знаний" text NULL,
	"Языки программирования" text NULL
);