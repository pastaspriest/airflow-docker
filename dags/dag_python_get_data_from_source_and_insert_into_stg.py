from datetime import datetime, timedelta
import pandas as pd
import psycopg2
from config import source_db

from airflow import DAG
from airflow.operators.python import PythonOperator

def get_conn_db(db_config):
    return psycopg2.connect(database  = db_config['database'],
                             host     = db_config['host'],
                             user     = db_config['user'],
                             password = db_config['password'],
                             port     = db_config['port'])

def dataframe_formation(cursor, records):

    # Формирование DataFrame
    names = [ x[0] for x in cursor.description ]
    df = pd.DataFrame( records, columns = names )
    
    return df

def get_dataframe_from_source_and_insert_into_stg(source_conn, stg_conn, table_name):
    
    # Создание подключения к db source
    source_conn = source_conn
    # Отключение автокоммита
    source_conn.autocommit = False
    # Создание курсора
    source_cursor = source_conn.cursor()
    
    source_cursor.execute(
                            '''
                                select * from source_data.базы_данных бд 
                            '''
    )
    records = source_cursor.fetchall()
    
    df = dataframe_formation(source_cursor, records)

    source_conn.close()
    source_cursor.close()

    # Создание подключения к db stg 
    dwh_conn = get_conn_db()
    # Отключение автокоммита
    dwh_conn.autocommit = False
    # Создание курсора
    dwh_cursor = source_conn.cursor()    
    # Запись DataFrame в таблицу базы данных
    dwh_cursor.executemany( f"INSERT INTO stg_{table_name}( terminal_id, terminal_type, terminal_city, terminal_address) VALUES( %s, %s, %s, %s)", df.values.tolist() )
    conn.commit()
    
    return df


def get_and_set_data():
    
    get_dataframe_from_source_and_insert_into_stg(get_conn_db(source_db), get_conn_db(dwh_db))
    
default_args = {
    'owner': 'tema',
    'retries': 5,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='dag_python_get_data_from_source_and_insert_into_stg',
    default_args=default_args,
    start_date=datetime.now(),
    schedule_interval='0 0 * * *'
) as dag:
    get_data = PythonOperator(
        task_id='get_data_from_postgres',
        python_callable=get_and_set_data,
        
    )
    get_and_set_data