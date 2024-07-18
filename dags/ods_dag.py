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
from airflow.sensors.external_task_sensor import ExternalTaskSensor

PG_HOOK_DWH = PostgresHook(postgres_conn_id='etl_db_1')
PG_HOOK_SOURCE = PostgresHook(postgres_conn_id='source')

# os.environ['CONN_DWH'] = PG_HOOK_DWH.get_uri().rsplit('?')[0]
# os.environ['CONN_SOURCE'] = PG_HOOK_DWH.get_uri().rsplit('?')[0]

# df = pd.read_sql('SELECT * FROM my_table', con=os.environ['CONN_SOURCE'])

default_args = {
    'owner': 'tema',
    'retries': 5,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='ods_dag',
    default_args=default_args,
    start_date=datetime.now(),
    schedule_interval='*/5 * * * *',
    template_searchpath='/opt/airflow/sql/'
) as dag:
    ods_finish = DummyOperator(
        task_id='ods_finish',
    )
    # create_ods_layer = PostgresOperator(
    #     task_id='create_ods_layer',
    #     postgres_conn_id='etl_db_1',
    #     sql='create_stg_layer.sql')
    stg_finish_sensor = ExternalTaskSensor(
        task_id='stg_finish_sensor',
        external_dag_id = 'stg_dag',
        external_task_id = 'stg_finish',
        # allowed_states=["success"],
        execution_delta = timedelta(minutes=1),
        timeout=5,
    )


    

stg_finish_sensor >> ods_finish