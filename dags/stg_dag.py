from datetime import datetime, timedelta
import psycopg2
#from config import source_db, dwh_db
# import os
import io
import csv
import pandas as pd

from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy import DummyOperator

PG_HOOK_DWH = PostgresHook(postgres_conn_id='etl_db_1')
PG_HOOK_SOURCE = PostgresHook(postgres_conn_id='source')

# os.environ['CONN_DWH'] = PG_HOOK_DWH.get_uri().rsplit('?')[0]
# os.environ['CONN_SOURCE'] = PG_HOOK_DWH.get_uri().rsplit('?')[0]

# df = pd.read_sql('SELECT * FROM my_table', con=os.environ['CONN_SOURCE'])


def read_meta(connect):

    query = '''
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

    df = pd.read_sql_query(query, connect)
    
    return df

def insert_source_into_stg(source_connect, dwh_connect, table_name, schema='source_data', batch_size=1000):
    
    query = f'SELECT * FROM {schema}.{table_name}'
    new_table_name = 'stg.' + table_name
    
    with source_connect.cursor() as cursor, dwh_connect.cursor() as dwh_cursor:
        cursor.itersize = batch_size
        cursor.execute(query)
        while True:
            rows = cursor.fetchmany(batch_size)
            if not rows:
                break
        
            csv_io = io.StringIO()
            writer = csv.writer(csv_io)
            writer.writerows(rows)
        
            csv_io.seek(0)

            dwh_cursor.copy_expert(    # Тут можно добавить схему в которую будем сохранять
                f'COPY {new_table_name} FROM STDIN WITH (NULL \'\', DELIMITER \',\', FORMAT CSV)',
                csv_io
            )

# =============================================================
# Вставляем данные в двх слой стг 
# =============================================================

def insert_tables():

    source_connect = PG_HOOK_SOURCE.get_conn()
    dwh_connect = PG_HOOK_DWH.get_conn()
    
    meta_df = read_meta(source_connect)

    for table_name in meta_df['table_name'].unique():
        insert_source_into_stg(source_connect, dwh_connect, table_name)

    source_connect.commit()
    source_connect.close()

    dwh_connect.commit()
    dwh_connect.close()

    return 1
    
# =============================================================

default_args = {
    'owner': 'tema',
    'retries': 0,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='stg_dag',
    default_args=default_args,
    # start_date=datetime.now(),
    start_date=datetime(2024, 1, 1),
    # schedule_interval=None,
    schedule_interval='26 * * * *',
    template_searchpath='/opt/airflow/sql/',
    catchup=False
) as dag:
    create_stg_layer = PostgresOperator(
        task_id='create_stg_layer',
        postgres_conn_id='etl_db_1',
        sql='create_stg_layer.sql')
    clear_stg_layer = PostgresOperator(
        task_id='clear_stg_layer',
        postgres_conn_id='etl_db_1',
        sql='SELECT stg.clear_stg_tables ();')
    insert_tables = PythonOperator(
        task_id='insert_tables',
        python_callable=insert_tables,
    )
    stg_finish = DummyOperator(
        task_id='stg_finish',
    )

create_stg_layer >> clear_stg_layer >> insert_tables >> stg_finish