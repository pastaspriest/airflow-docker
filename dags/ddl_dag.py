from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.dummy import DummyOperator
from airflow.sensors.external_task_sensor import ExternalTaskSensor

default_args = {
    'owner': 'tema',
    'retries': 5,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='ddl_dag',
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule_interval='*/5 * * * *',
    # schedule_interval=None,
    template_searchpath='/opt/airflow/sql/',
    catchup=False,
) as dag:
    ods_finish_sensor = ExternalTaskSensor(
        task_id='ods_finish_sensor',
        external_dag_id='ods_dag',
        external_task_id='ods_finish',
        execution_delta=timedelta(minutes=5),
        # timeout=5,
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
        sql='select ddl.clearing_tables ()'
    )
    insert_tables = PostgresOperator(
        task_id='insert_tables',
        postgres_conn_id='etl_db_1',
        sql='ods_to_ddl.sql'
    )
    ddl_finish = DummyOperator(
        task_id='ddl_finish',
    )

ods_finish_sensor >> create_ddl_layer >> clear_ddl_layer >> insert_tables >> ddl_finish