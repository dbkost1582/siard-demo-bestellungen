@echo off
setlocal enabledelayedexpansion

REM create a dir for temporary files and prefix it with _ (so .gitignore can do its job)
set temp_dir=%cd%\_temp
set mount_dir=%cd%\mount
::mkdir %temp_dir%
rmdir /S /Q %temp_dir% >nul 2>&1

call build-sqlScripts.bat %temp_dir%

REM ============================================
REM Demo-System: PostgreSQL+pgAdmin -> Pause -> MySQL+phpMyAdmin
REM ============================================
 
REM ---- PostgreSQL Konfiguration ----
set PG_NETWORK=pg_demo_net
set PG_CONTAINER=pg_demo
set PGADMIN_CONTAINER=pgadmin_demo
set PG_USER=demo
set PG_PASSWORD=demo
set PG_DB=demo
set PG_SQL_FILE=%temp_dir%\demo_postgresql.sql
set PGADMIN_EMAIL=demo@kost.ch
set PGADMIN_PASSWORD=demo
set PGADMIN_PORT=5051
set PG_PORT=5432

 
REM ---- MySQL Konfiguration ----
set MYSQL_NETWORK=mysql_demo_net
set MYSQL_CONTAINER=mysql_demo
set PHPMYADMIN_CONTAINER=phpmyadmin_demo
set MYSQL_USER=demo
set MYSQL_PASSWORD=demo
set MYSQL_DATABASE=demo
set MYSQL_SQL_FILE=%temp_dir%\demo_mysql.sql
set PHPMYADMIN_PORT=8080
set MYSQL_PORT=3306
:: root password: demo

set DATABASE_INIT_SCRIPT=init-multi-schema.sql

::goto :EOF

::echo skipping POSTGRES
::goto :END_SKIP_POSTGRES

echo ============================================
echo Starte PostgreSQL-Demo...
echo ============================================
 
REM ---- Alte PostgreSQL Container/Volumes bereinigen ----
docker rm -f %PG_CONTAINER% %PGADMIN_CONTAINER% >nul 2>&1
docker volume rm pgadmin_data >nul 2>&1
docker volume create pgadmin_data >nul 2>&1
docker volume rm pg_data >nul 2>&1
docker volume create pg_data >nul 2>&1
docker network rm %PG_NETWORK% >nul 2>&1
docker network create %PG_NETWORK% >nul 2>&1
 
REM ---- PostgreSQL starten ----
docker run -d --network %PG_NETWORK% --name %PG_CONTAINER% ^
    -e POSTGRES_USER=%PG_USER% ^
    -e POSTGRES_PASSWORD=%PG_PASSWORD% ^
    -e POSTGRES_DB=%PG_DB% ^
	-v pg_data:/var/lib/postgresql/data ^
	-v %mount_dir%\postgresql\%DATABASE_INIT_SCRIPT%:/docker-entrypoint-initdb.d/%DATABASE_INIT_SCRIPT% ^
    -p %PG_PORT%:5432 ^
    postgres:latest
 
REM ---- Warten auf PostgreSQL ----
set /a retries=0
:wait_pg
docker exec %PG_CONTAINER% pg_isready -U %PG_USER% -d %PG_DB% >nul 2>&1
if %errorlevel%==0 goto :ready_pg
set /a retries+=1
if %retries% gtr 20 (
    echo PostgreSQL Timeout
    exit /b 1
)
timeout /t 1 >nul
goto :wait_pg
:ready_pg
timeout /t 3 >nul
docker exec -i %PG_CONTAINER% psql -U %PG_USER% -d %PG_DB% -f - < %PG_SQL_FILE%
echo PostgreSQL SQL-Skript ausgeführt.
 
REM ---- pgAdmin starten ----
docker run -d --network %PG_NETWORK% --name %PGADMIN_CONTAINER% ^
    -e PGADMIN_DEFAULT_EMAIL=%PGADMIN_EMAIL% ^
    -e PGADMIN_DEFAULT_PASSWORD=%PGADMIN_PASSWORD% ^
    -v pgadmin_data:/var/lib/pgadmin ^
    -p %PGADMIN_PORT%:80 ^
    dpage/pgadmin4:latest
 
timeout /t 5 >nul
 
echo.
echo PostgreSQL + pgAdmin sind gestartet!
echo http://localhost:%PGADMIN_PORT%
echo Benutzer: %PGADMIN_EMAIL% / Passwort: %PGADMIN_PASSWORD%
echo.
echo  Server-Verbindung:
echo      Hostname: %CONTAINER_NAME%
echo      Benutzer: %POSTGRES_USER%
echo      Passwort: %POSTGRES_PASSWORD%
:: hook to check the connection
::pause
echo Fahre mit MySQL-Demo fort...
echo.


:END_SKIP_POSTGRES
REM ---- MySQL Teil ----
echo ============================================
echo Starte MySQL-Demo...
echo ============================================
 
REM ---- Alte MySQL Container/Volumes bereinigen ----
docker rm -f %MYSQL_CONTAINER% %PHPMYADMIN_CONTAINER% >nul 2>&1
docker volume rm mysql_data >nul 2>&1
docker volume create mysql_data >nul 2>&1

rem network initialisieren
docker network rm %MYSQL_NETWORK% >nul 2>&1
docker network create %MYSQL_NETWORK% >nul 2>&1

 
REM ---- MySQL starten ----
docker run -d --network %MYSQL_NETWORK% --name %MYSQL_CONTAINER% ^
    -e MYSQL_ROOT_PASSWORD=%MYSQL_PASSWORD% ^
    -e MYSQL_USER=%MYSQL_USER% ^
    -e MYSQL_PASSWORD=%MYSQL_PASSWORD% ^
    -e MYSQL_DATABASE=%MYSQL_DATABASE% ^
    -v mysql_data:/var/lib/mysql ^
	-v %mount_dir%\mysql\%DATABASE_INIT_SCRIPT%:/docker-entrypoint-initdb.d/%DATABASE_INIT_SCRIPT% ^
    -p %MYSQL_PORT%:3306 ^
    mysql:latest
 
 
REM ---- Warten auf MySQL ----
set /a retries=0
:wait_mysql
docker exec %MYSQL_CONTAINER% mysqladmin ping -u%MYSQL_USER% -p%MYSQL_PASSWORD% >nul 2>&1
if %errorlevel%==0 goto :ready_mysql
set /a retries+=1
if %retries% gtr 30 (
    echo MySQL Timeout
    exit /b 1
)

timeout /t 1 >nul
goto :wait_mysql
:ready_mysql

:: db bastel
timeout /t 7 >nul

REM docker logs %MYSQL_CONTAINER%

:: REM Hack für Demo: mysql ist falsch konfiguriert bezüglich utf. Das kann man entweder im Container ändern oder hier. Im Container hat es nicht geklappt
:: REM                resp. hätte viel zu viel Zeit gekostet (eine Config Datei anpassen, was dann aber zu einem Berechtigungsding eskalierte.
:: REM                => hier das Characterset des Skripts direkt angeben 
docker exec -i %MYSQL_CONTAINER% sh -c "mysql --default-character-set=utf8mb4 -u%MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE%" < %MYSQL_SQL_FILE%
::alt docker exec -i %MYSQL_CONTAINER% sh -c "mysql -u%MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE%" < %MYSQL_SQL_FILE%
echo MySQL SQL-Skript ausgeführt.
 
REM ---- phpMyAdmin starten ----
docker run -d --network %MYSQL_NETWORK% --name %PHPMYADMIN_CONTAINER% ^
    -e PMA_HOST=%MYSQL_CONTAINER% ^
    -e PMA_USER=%MYSQL_USER% ^
    -e PMA_PASSWORD=%MYSQL_PASSWORD% ^
    -p %PHPMYADMIN_PORT%:80 ^
    phpmyadmin:latest
 
timeout /t 5 >nul
 
echo.
echo MySQL + phpMyAdmin sind gestartet!
echo http://localhost:%PHPMYADMIN_PORT%
echo Benutzer: %MYSQL_USER% / Passwort: %MYSQL_PASSWORD%



echo last pause before shutdown...
pause
 
REM ---- Aufräumen ----
echo Stoppe alle Container...
docker stop %PGADMIN_CONTAINER% %PG_CONTAINER% %PHPMYADMIN_CONTAINER% %MYSQL_CONTAINER% >nul
docker network rm %PG_NETWORK% %MYSQL_NETWORK% >nul
echo Demo-System beendet und gelöscht.
::pause