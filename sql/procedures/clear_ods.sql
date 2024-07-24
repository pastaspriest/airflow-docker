create or replace function ods.clearing_tables ()
RETURNS void
--returns table (     -- Варианты возвращаемой информации: число перенесенных/отфильтрованных строк
--bd_name TEXT,     -- Запрос Select * from temp_table
--bd_id int4        -- Void
--) 
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
	-- delete from ods.error;
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