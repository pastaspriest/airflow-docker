from datetime import datetime, timedelta
import psycopg2
from config import source_db, dwh_db
import pandas as pd
import io
import csv

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python_operator import PythonOperator

default_args = {
    'owner': 'tema',
    'retries': 5,
    'retry_delay': timedelta(minutes=5)
}


def get_conn_db(db_config):
    return psycopg2.connect(database  = db_config['database'],
                             host     = db_config['host'],
                             user     = db_config['user'],
                             password = db_config['password'],
                             port     = db_config['port'])


def create_tables_from_list(cursor, list_):
  
    fields = {}
    
    sql = "create table if not exists dar.!table_name! ( !fields! )"
    
    for li in list_:
        if li[0] not in fields:
            fields[li[0]] = f"\"{li[1]}\" {li[2]}, "
        else:
            fields[li[0]] += f"\"{li[1]}\" {li[2]}, "

    for k in fields:

        cursor.execute( sql.replace('!table_name!', f"stg_{k}").replace('!fields!', fields[k].rstrip(', ')) )
        

def create_tables_from_meta_df(cursor, df):

    cursor.execute("create table if not exists dar.source_meta ( table_name varchar(200), field varchar(200), type varchar(100) )")

    cursor.execute("truncate table dar.source_meta")

    cursor.executemany( "insert into dar.source_meta( table_name, field, type) VALUES( %s, %s, %s) ", df.values.tolist() )


def dataframe_formation(cursor, records):

    # Формирование DataFrame
    names = [ x[0].replace('\"', '') for x in cursor.description ]
    df = pd.DataFrame( records, columns = names )
    
    return df


def get_meta_df_from_source(cursor):

    cursor.execute(
                    '''
                        select
                            table_name
                        ,   column_name
            
                        ,   case when udt_name = 'varchar' then CONCAT('varchar(', CAST(character_maximum_length AS varchar), ')')
                        else udt_name end as udt_name
                        from
                            information_schema.columns
                        where
                            table_name in (
                                            select tablename FROM pg_catalog.pg_tables
                                            where schemaname = 'source_data'
                                            );
                    '''
    )
    records = cursor.fetchall()

    return dataframe_formation(cursor, records)

def get_meta_df(cursor):

    cursor.execute("select * from dar.source_meta")

    records = cursor.fetchall()
    
    return dataframe_formation(cursor, records)
        

def copy_data_into_stg(source_cursor, dwh_cursor, meta_list):

    table_names = []
    
    for li in meta_list:
        table_names.append(li[0])

    for n in set(table_names):

        batch_size = 1000
        source_cursor.itersize = batch_size
        source_cursor.execute(f'SELECT * FROM source_data.{n}')
        transfer_table_name = f'dar.stg_{n}'
        
        while True:
            rows = source_cursor.fetchmany(batch_size)
            if not rows:
                break
            
            csv_io = io.StringIO()
            writer = csv.writer(csv_io)
            writer.writerows(rows)
            
            csv_io.seek(0)
            
            dwh_cursor.copy_expert(
                    f'COPY {transfer_table_name} FROM STDIN WITH (NULL \'\', DELIMITER \',\', FORMAT CSV)',
                    csv_io
                )


def get_dataframe_from_source(cursor, table_name):
    
    cursor.execute(
                    f'''
                        select * from source_data.{table_name}
                    '''
    )
    records = cursor.fetchall()
    
    df = dataframe_formation(cursor, records)

    return df
    
# =============================================================
# Забираем мету source
# Забираем данные из source
# Вставляем данные в двх слой стг 
# =============================================================

def get_and_set_data():

    source_connect = get_conn_db(source_db)
    source_connect.autocommit = False
    source_cursor = source_connect.cursor()

    dwh_connect = get_conn_db(dwh_db)
    dwh_connect.autocommit = False
    dwh_cursor = dwh_connect.cursor()    
    
    meta_list = get_meta_df(dwh_cursor).values.tolist()

    copy_data_into_stg(source_cursor, dwh_cursor, meta_list)

    source_connect.commit()
    source_cursor.close() 
    source_connect.close()
    
    dwh_connect.commit()
    dwh_connect.close()
    dwh_cursor.close()

    return 1
    
# =============================================================
# Забираем мету бд source
# создаем на омнове меты таблицы в ДВХ
# Создаем в двх таблицу с метаданными и заполняем ее
# =============================================================
    
def create_tables():

    source_connect = get_conn_db(source_db)
    source_connect.autocommit = False
    source_cursor = source_connect.cursor()

    dwh_connect = get_conn_db(dwh_db)
    dwh_connect.autocommit = False
    dwh_cursor = dwh_connect.cursor() 

    meta_df = get_meta_df_from_source(source_cursor)
    
    create_tables_from_meta_df(dwh_cursor, meta_df)

    create_tables_from_list(dwh_cursor, meta_df.values.tolist())

    source_connect.commit()
    source_connect.close()
    source_cursor.close() 

    dwh_connect.commit()
    dwh_cursor.close()
    dwh_connect.close()
     

    return 1

# =============================================================

with DAG(
    dag_id='metadata_pull_v05',
    default_args=default_args,
    start_date=datetime.now(),
    schedule_interval='0 0 * * *'
) as dag:
    create_tables = PythonOperator(
        task_id='create_tables_from_meta',
        python_callable=create_tables,
    )
    get_and_set_data = PythonOperator(
        task_id='get_and_set_data',
        python_callable=get_and_set_data,
    )
    create_tables >> get_and_set_data
    
    