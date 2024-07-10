from datetime import datetime, timedelta
import os

from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python_operator import PythonOperator


PG_HOOK_DWH = PostgresHook(postgres_conn_id='etl_db_1')

os.environ['CONN_SOURCES'] = PG_HOOK_DWH.get_uri().rsplit('?')[0]

default_args = {
    'owner': 'tema',
    'retries': 5,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='etl',
    default_args=default_args,
    start_date=datetime.now(),
    schedule_interval='0 0 * * *',
    template_searchpath='/opt/airflow/sql/'
) as dag:
    create_stg_layer = PostgresOperator(
        task_id='create_stg_layer',
        postgres_conn_id='etl_db_1',
        sql='create_stg_layer.sql')

create_stg_layer