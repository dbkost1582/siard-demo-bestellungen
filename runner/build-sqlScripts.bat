@echo off

set source_dir=%cd%\sqls\
echo script source: %source%
echo generate scripts in: %1 
mkdir %1 >nul 2>&1
type %source_dir%ddl-mysql.sql %source_dir%sql-non-rdbms-objects.sql %source_dir%sql-insert-alles.sql > %1\demo_mysql.sql
type %source_dir%ddl-postgresql.sql  %source_dir%sql-non-rdbms-objects.sql %source_dir%sql-insert-alles.sql > %1\demo_postgresql.sql