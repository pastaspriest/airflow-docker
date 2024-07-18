create or replace function ddl.clearing_tables ()
RETURNS void
--returns table (     -- Варианты возвращаемой информации: число перенесенных/отфильтрованных строк
--bd_name TEXT,     -- Запрос Select * from temp_table
--bd_id int4        -- Void
--) 
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