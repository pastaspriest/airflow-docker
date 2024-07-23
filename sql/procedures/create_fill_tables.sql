create or replace function DDL.get_database ()
RETURNS void
--returns table (     -- Варианты возвращаемой информации: число перенесенных/отфильтрованных строк
--	bd_name TEXT,     -- Запрос Select * from temp_table
--	bd_id int4        -- Void
--) 
language plpgsql
as $$
begin
    CREATE TEMP TABLE IF NOT EXISTS temp_table AS
        SELECT bd_name, bd_id
        FROM ODS.database
        WHERE activity = 'Да' AND bd_name IS NOT NULL AND bd_id IS NOT NULL;

    INSERT INTO ERROR.database
        SELECT * FROM ODS.database
        WHERE bd_id NOT IN (SELECT bd_id FROM temp_table) AND activity <> 'Нет';

    INSERT INTO DDL.database(bd_name, bd_id)
        SELECT * FROM temp_table

	--RETURN query 
	--SELECT *
	--FROM temp_table;

    DROP TABLE temp_table;

END;
$$;