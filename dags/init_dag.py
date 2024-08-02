from datetime import datetime, timedelta
import psycopg2
#from config import source_db, dwh_db
import os
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

AIRFLOW_HOME = os.getenv('AIRFLOW_HOME')


default_args = {
    'owner': 'airflow',
    'retries': 0,
    'retry_delay': timedelta(minutes=5)
}

def get_and_set_data():
    dwh_connect = PG_HOOK_DWH.get_conn()
    dwh_cursor = dwh_connect.cursor()

    department_pictures_pd = pd.read_csv(f'{AIRFLOW_HOME}/dags/data/department_pictures.csv')
    dwh_cursor.executemany('insert into stg.department_pictures(department, pic_url) VALUES( %s, %s)', department_pictures_pd.values.tolist() )

    updated_grades_pd = pd.read_csv(f'{AIRFLOW_HOME}/dags/data/updated_grades.csv')
    dwh_cursor.executemany('insert into stg.updated_grades(old_grade, new_grade, grade_level) VALUES( %s, %s, %s)', updated_grades_pd.values.tolist() )    

    fixed_departments_pd = pd.read_csv(f'{AIRFLOW_HOME}/dags/data/fixed_departments.csv')
    dwh_cursor.executemany('insert into stg.fixed_departments(old_department_name, department) VALUES( %s, %s)', fixed_departments_pd.values.tolist() )

    generated_names_pd = pd.read_csv(f'{AIRFLOW_HOME}/dags/data/generated_names.csv')
    dwh_cursor.executemany('insert into stg.generated_names(employee_id, full_name) VALUES( %s, %s)', generated_names_pd.values.tolist() )
    
    dwh_connect.commit()
    dwh_connect.close()

with DAG(
    dag_id='init_dag',
    default_args=default_args,
    # start_date=datetime.now(),
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    # schedule_interval='26 * * * *',
    template_searchpath='/opt/airflow/sql/',
    catchup=False
) as dag:
    init = PostgresOperator(
        task_id='init',
        postgres_conn_id='etl_db_1',
        sql='init_script.sql')
    get_and_set_data = PythonOperator(
        task_id='get_and_set_data',
        python_callable=get_and_set_data,
    )
    init_finish = DummyOperator(
        task_id='init_finish',
    )

init >> get_and_set_data >> init_finish