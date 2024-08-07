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
    dag_id='ddl_dag',
    default_args=default_args,
    # schedule_interval=None,
    schedule_interval='30 * * * *',
    template_searchpath='/opt/airflow/sql/',
    catchup=False,
) as dag:
    ods_finish_sensor = ExternalTaskSensor(
        task_id='ods_finish_sensor',
        external_dag_id='ods_dag',
        external_task_id='ods_finish',
        execution_delta=timedelta(minutes=2),
        timeout=240
        # check_existence=True
    )
    create_ddl_layer = PostgresOperator(
        task_id='create_ddl_layer',
        postgres_conn_id='etl_db_1',
        sql='create_ddl.sql'
    )
    clear_ddl_layer = PostgresOperator(
        task_id='clear_ddl_layer',
        postgres_conn_id='etl_db_1',
        sql='select stg.clear_ddl_tables ()'
    )
    insert_in_ddl_tables = PostgresOperator(
        task_id='insert_in_ddl_tables',
        postgres_conn_id='etl_db_1',
        sql='ods_to_ddl.sql'
    )
    ddl_finish = DummyOperator(
        task_id='ddl_finish',
    )

ods_finish_sensor >> create_ddl_layer >> clear_ddl_layer >> insert_in_ddl_tables >> ddl_finish