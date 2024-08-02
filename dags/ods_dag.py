from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.dummy import DummyOperator
from airflow.sensors.external_task_sensor import ExternalTaskSensor

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=4),
    'start_date': datetime(2024, 8, 2),
}

with DAG(
    dag_id='stg_dag',
    default_args=default_args,
    schedule_interval=None,
    # schedule_interval='26 * * * *',
    template_searchpath='/opt/airflow/sql/',
    catchup=False,
    execution_delta=timedelta(minutes=2)
) as dag:
    stg_finish_sensor = ExternalTaskSensor(
        task_id='stg_finish_sensor',
        external_dag_id='stg_dag',
        external_task_id='stg_finish',
        execution_delta=timedelta(minutes=2),
        timeout=5,
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
        sql='select stg.clear_ods_tables ()'
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