# Стажировка КОРУС Консалтинг, команда 1
> Разработчики Карпухин Артем, Гущин Иван \
> Системный аналитик Каменев Даниил
> Бизнес аналитик Смяткин Александр

## 1. Слои данных
В проекте используются 4 слоя данных: **STG**,**ODS**, **DDS**, **DM**
### `STG`
В слое **STG** содержатся таблицы в которые копируются данные из **source** 1 в 1. Скрипт создания слоя находится в [**sql/create_stg_layer.sql**](sql/create_stg_layer.sql). Так-же в этом слое находятся все функции для очистки слоев. 
### `ODS`
В слой **ODS** перенесены все таблицы с переименованием названий таблиц и атрибутов по стандарту sql. Скрипты создания и заполнения слоя находится в [**sql/create_ods_layer.sql**](sql/create_ods_layer.sql) и [**sql/stg_to_ods.sql**](sql/stg_to_ods.sql).
### `DDL`
В слое **DDL** произведена очистка данных и выгрузка строк с ошибками в таблицу **stg.error**. 
Скрипты создания и заполнения слоя находится в [**sql/create_ddl.sql**](sql/create_ddl.sql) и [**sql/ods_to_ddl.sql**](sql/ods_to_ddl.sql).
### `DM`
В слое DM хранятся таблицы **dim_date**, **dim_department**, **dim_employee**, **dim_position**, **dim_skill_level**, **dim_skills**, **dim_year**, **fact_empl_skills**, **fact_pos_year**, **for_radar** необходимые для создания витрины и последующей визуализации. Скрипты создания и заполнения слоя находится в [**sql/create_dm.sql**](sql/create_dm.sql) и [**sql/ddl_to_dm.sql**](sql/ddl_to_dm.sql).

## 2. Структура
[**./sql/**](sql/) - SQL-скрипты для создания / загрузки / обработки \
[**./dags/init_dag.py**](dags/init_dag.py) - Создание схем и функций, заполнение таблиц **stg.updated_grades**, **stg.department_pictures**, **stg.fixed_departments**, **stg.generated_names** в БД **etl_db_1** \
[**./dags/stg_dag.py**](dags/stg_dag.py) - Создание и заполнение таблиц в слой **STG** \
[**./dags/ods_dag.py**](dags/ods_dag.py) - Создание и заполнение таблиц в слой **ODS** \
[**./dags/ddl_dag.py**](dags/ddl_dag.py) - Создание и заполнение таблиц в слой **DDL** \
[**./dags/dm_dag.py**](dags/dm_dag.py) - Создание и заполнение таблиц в в слой **DM** \


Ниже представлена структура репозитория:
```
├── dags
│   ├── data
│   │   ├── departments_pictures.csv
│   │   ├── fixed_departments.csv
│   │   ├── generated_names.csv
│   │   └── updated_grades.csv
├── dag_ddl.py
│   ├── dds_dag.py
│   ├── dm_dag.py
│   ├── init_dag.py
│   ├── ods_dag.py
│   └── stg_dag.py
├── sql
│   ├── create_ddl.sql
│   ├── create_dm.sql
│   ├── create_ods.sql
│   ├── create_stg.sql
│   ├── ddl_to_dm.sql
│   ├── init_script.sql
│   ├── ods_to_ddl.sql
│   └── stg_to_ods.sql
├── .env
├── README.md
└── docker-compose-airflow.yaml
```

## 3. Архитектура решения
![Архитектура решения](https://github.com/pastaspriest/airflow-docker/blob/main/architecture_diagram.png)

## 4. Запуск сервиса Apache Airflow
Запуск сервиса Apache Airflow 2.6.3 происходит при помощи **docker compose**. Официальная инструкция к установке указана в [официальной документации по установке Docker](https://docs.docker.com/desktop/install/windows-install/).

1. Скопируйте репозиторий на свою систему:
```bash
git clone https://github.com/pastaspriest/airflow-docker.git
```
2. Перейдите в директорию с проектом:
```bash
cd airflow-docker
```
3. Создайте папки для запуска **Apache Airflow**:
```bash
mkdir config logs plugins
```
4. (Только при первом запуске!) Инициализируйте базу данных в **Apache Airflow**:
```bash
docker compose -f docker-compose.yaml up airflow-init
```
5. После иниализации запустите контейнер:
```bash
docker compose -f docker-compose.yaml up -d
```
6. В интерфейсе https://localhost:8080/ по пути **Admin -> Connections** укажите соединения к БД
