create or replace function ddl.clearing_tables ()
RETURNS void
--returns table (     -- Варианты возвращаемой информации: число перенесенных/отфильтрованных строк
--bd_name TEXT,     -- Запрос Select * from temp_table
--bd_id int4        -- Void
--) 
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