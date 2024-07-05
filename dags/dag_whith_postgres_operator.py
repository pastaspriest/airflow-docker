from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

default_args = {
    'owner': 'tema',
    'retries': 5,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='dag_with_postgres_operator_v04',
    default_args=default_args,
    start_date=datetime.now(),
    schedule_interval='0 0 * * *'
) as dag:
    task1 = PostgresOperator(
        task_id='get_data_from_postgres',
        postgres_conn_id='source',
        sql="""
            select * from source_data.базы_данных
        """
    )
    task1