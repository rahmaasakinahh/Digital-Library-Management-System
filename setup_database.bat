@echo off
REM ============================================
REM Digital Library System - Database Setup
REM ============================================

echo.
echo ========================================
echo  Digital Library - Database Setup
echo ========================================
echo.

REM Check if PostgreSQL is in PATH
where psql >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PostgreSQL 'psql' command not found in PATH!
    echo.
    echo Please install PostgreSQL or add it to your PATH:
    echo Example: C:\Program Files\PostgreSQL\15\bin
    echo.
    pause
    exit /b 1
)

REM Configuration (modify these values as needed)
set DB_NAME=library_db
set DB_USER=postgres
set DB_HOST=localhost
set DB_PORT=5432

echo Configuration:
echo   Database: %DB_NAME%
echo   User: %DB_USER%
echo   Host: %DB_HOST%
echo   Port: %DB_PORT%
echo.

REM Prompt for password
echo NOTE: You will be prompted for PostgreSQL password multiple times
echo.
pause

REM Step 1: Check if database exists and drop if needed
echo.
echo Step 1: Checking if database exists...
psql -U %DB_USER% -h %DB_HOST% -p %DB_PORT% -d postgres -c "SELECT 1 FROM pg_database WHERE datname='%DB_NAME%'" -t -A >temp_check.txt 2>nul
set /p DB_EXISTS=<temp_check.txt
del temp_check.txt >nul 2>nul

if "%DB_EXISTS%"=="1" (
    echo Database '%DB_NAME%' already exists.
    set /p DROP_DB="Do you want to drop and recreate it? (Y/N): "
    if /i "%DROP_DB%"=="Y" (
        echo Dropping existing database...
        psql -U %DB_USER% -h %DB_HOST% -p %DB_PORT% -d postgres -c "DROP DATABASE %DB_NAME%;"
        if %ERRORLEVEL% NEQ 0 (
            echo ERROR: Failed to drop database!
            pause
            exit /b 1
        )
        echo Database dropped successfully.
    ) else (
        echo Skipping database recreation. Using existing database.
        goto :SKIP_CREATE
    )
)

REM Step 2: Create database
echo.
echo Step 2: Creating database '%DB_NAME%'...
psql -U %DB_USER% -h %DB_HOST% -p %DB_PORT% -d postgres -c "CREATE DATABASE %DB_NAME%;"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create database!
    pause
    exit /b 1
)
echo Database created successfully.

:SKIP_CREATE

REM Step 3: Run schema.sql
echo.
echo Step 3: Creating database schema...
if not exist "database\schema.sql" (
    echo ERROR: schema.sql not found in database folder!
    pause
    exit /b 1
)

psql -U %DB_USER% -h %DB_HOST% -p %DB_PORT% -d %DB_NAME% -f "database\schema.sql"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create schema!
    pause
    exit /b 1
)
echo Schema created successfully.

REM Step 4: Run seed.sql
echo.
echo Step 4: Loading sample data...
if not exist "database\seed.sql" (
    echo WARNING: seed.sql not found in database folder!
    echo Skipping sample data...
    goto :SKIP_SEED
)

psql -U %DB_USER% -h %DB_HOST% -p %DB_PORT% -d %DB_NAME% -f "database\seed.sql"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to load sample data!
    pause
    exit /b 1
)
echo Sample data loaded successfully.

:SKIP_SEED

REM Step 5: Verify setup
echo.
echo Step 5: Verifying database setup...
psql -U %DB_USER% -h %DB_HOST% -p %DB_PORT% -d %DB_NAME% -c "\dt"

echo.
echo ========================================
echo  Database Setup Complete!
echo ========================================
echo.
echo Database: %DB_NAME%
echo.
echo Next steps:
echo   1. Update database credentials in:
echo      src\main\webapp\META-INF\context.xml
echo   2. Run setup_server.bat to build and deploy
echo.
echo Demo credentials:
echo   Admin: admin / admin123
echo   Student: john_doe / student123
echo.
pause
