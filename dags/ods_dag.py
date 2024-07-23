from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.dummy import DummyOperator
from airflow.sensors.external_task_sensor import ExternalTaskSensor

default_args = {
    'owner': 'tema',
    'retries': 0,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='ods_dag',
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule_interval='28 * * * *',
    # schedule_interval=None,
    template_searchpath='/opt/airflow/sql/',
    catchup=False,
) as dag:
    stg_finish_sensor = ExternalTaskSensor(
        task_id='stg_finish_sensor',
        external_dag_id='stg_dag',
        external_task_id='stg_finish',
        execution_delta=timedelta(minutes=2),
        # timeout=5,
        # check_existence=True
    )
    create_ods_layer = PostgresOperator(
        task_id='create_ods_layer',
        postgres_conn_id='etl_db_1',
        sql='create_ods_layer.sql'
    )
    clear_ods_layer = PostgresOperator(
        task_id='clear_ods_layer',
        postgres_conn_id='etl_db_1',
        sql='select ods.clearing_tables ()'
    )
    insert_in_ods_tables = PostgresOperator(
        task_id='insert_in_ods_tables',
        postgres_conn_id='etl_db_1',
        sql='stg_to_ods.sql'
    )
    ods_finish = DummyOperator(
        task_id='ods_finish',
    )

stg_finish_sensor >> create_ods_layer >> clear_ods_layer >> insert_in_ods_tables >> ods_finish