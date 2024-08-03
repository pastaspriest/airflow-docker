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
    dag_id='dm_dag',
    default_args=default_args,
    # schedule_interval=None,
    schedule_interval='32 * * * *',
    template_searchpath='/opt/airflow/sql/',
    catchup=False
) as dag:
    ddl_finish_sensor = ExternalTaskSensor(
        task_id='ddl_finish_sensor',
        external_dag_id='ddl_dag',
        external_task_id='ddl_finish',
        execution_delta=timedelta(minutes=2),
        timeout=300,
        # check_existence=True
    )
    create_dm_layer = PostgresOperator(
        task_id='create_dm_layer',
        postgres_conn_id='etl_db_1',
        sql='create_dm.sql'
    )
    clear_dm_layer = PostgresOperator(
        task_id='clear_dm_layer',
        postgres_conn_id='etl_db_1',
        sql='select stg.clear_dm_tables ()'
    )
    insert_in_dm_tables = PostgresOperator(
        task_id='insert_in_dm_tables',
        postgres_conn_id='etl_db_1',
        sql='ddl_to_dm.sql'
    )
    dm_finish = DummyOperator(
        task_id='dm_finish',
    )

ddl_finish_sensor >> create_dm_layer >> clear_dm_layer >> insert_in_dm_tables >> dm_finish