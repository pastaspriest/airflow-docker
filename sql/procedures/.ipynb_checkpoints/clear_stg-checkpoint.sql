create or replace function stg.clearing_tables ()
RETURNS void
--returns table (     -- Варианты возвращаемой информации: число перенесенных/отфильтрованных строк
--bd_name TEXT,     -- Запрос Select * from temp_table
--bd_id int4        -- Void
--) 
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