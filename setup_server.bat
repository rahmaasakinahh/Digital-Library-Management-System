@echo off
REM ============================================
REM Digital Library System - Server Setup
REM ============================================

echo.
echo ========================================
echo  Digital Library - Server Setup
echo ========================================
echo.

REM Configuration (modify these values as needed)
set TOMCAT_HOME=C:\apache-tomcat-10.1.15
set APP_NAME=library-system

echo Configuration:
echo   Tomcat Home: %TOMCAT_HOME%
echo   Application: %APP_NAME%
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven 'mvn' command not found in PATH!
    echo.
    echo Please install Maven or add it to your PATH
    echo Download from: https://maven.apache.org/download.cgi
    echo.
    pause
    exit /b 1
)

REM Check if JAVA_HOME is set
if "%JAVA_HOME%"=="" (
    echo WARNING: JAVA_HOME environment variable is not set!
    echo Maven may not work correctly.
    echo.
    set /p CONTINUE="Do you want to continue anyway? (Y/N): "
    if /i not "%CONTINUE%"=="Y" exit /b 1
)

echo.
echo Step 1: Cleaning previous build...
call mvn clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven clean failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Building the project...
call mvn package
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven build failed!
    echo Please check the error messages above.
    pause
    exit /b 1
)

REM Check if WAR file was created
if not exist "target\%APP_NAME%.war" (
    echo ERROR: WAR file not found: target\%APP_NAME%.war
    echo Build may have failed.
    pause
    exit /b 1
)

echo Build successful! WAR file created: target\%APP_NAME%.war

REM Ask if user wants to deploy to Tomcat
echo.
set /p DEPLOY="Do you want to deploy to Tomcat? (Y/N): "
if /i not "%DEPLOY%"=="Y" (
    echo.
    echo Build complete! WAR file location:
    echo   %CD%\target\%APP_NAME%.war
    echo.
    echo To deploy manually:
    echo   1. Copy the WAR file to: %TOMCAT_HOME%\webapps\
    echo   2. Start Tomcat
    echo   3. Access: http://localhost:8080/%APP_NAME%/
    echo.
    pause
    exit /b 0
)

REM Check if Tomcat directory exists
if not exist "%TOMCAT_HOME%" (
    echo ERROR: Tomcat directory not found: %TOMCAT_HOME%
    echo.
    echo Please update TOMCAT_HOME in this script or install Tomcat:
    echo   Download from: https://tomcat.apache.org/download-10.cgi
    echo.
    pause
    exit /b 1
)

REM Check if webapps directory exists
if not exist "%TOMCAT_HOME%\webapps" (
    echo ERROR: Tomcat webapps directory not found!
    echo Please check your Tomcat installation.
    pause
    exit /b 1
)

echo.
echo Step 3: Deploying to Tomcat...

REM Stop Tomcat if running
echo Checking if Tomcat is running...
tasklist /FI "IMAGENAME eq java.exe" 2>NUL | find /I /N "java.exe">NUL
if %ERRORLEVEL%==0 (
    echo Tomcat appears to be running. Attempting to stop...
    if exist "%TOMCAT_HOME%\bin\shutdown.bat" (
        call "%TOMCAT_HOME%\bin\shutdown.bat"
        echo Waiting for Tomcat to stop...
        timeout /t 5 /nobreak >nul
    )
)

REM Remove old deployment
if exist "%TOMCAT_HOME%\webapps\%APP_NAME%" (
    echo Removing old deployment folder...
    rmdir /s /q "%TOMCAT_HOME%\webapps\%APP_NAME%"
)

if exist "%TOMCAT_HOME%\webapps\%APP_NAME%.war" (
    echo Removing old WAR file...
    del /f /q "%TOMCAT_HOME%\webapps\%APP_NAME%.war"
)

REM Copy new WAR file
echo Copying WAR file to Tomcat...
copy /y "target\%APP_NAME%.war" "%TOMCAT_HOME%\webapps\"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to copy WAR file to Tomcat!
    pause
    exit /b 1
)

echo Deployment successful!

REM Ask if user wants to start Tomcat
echo.
set /p START_TOMCAT="Do you want to start Tomcat now? (Y/N): "
if /i not "%START_TOMCAT%"=="Y" (
    echo.
    echo To start Tomcat manually, run:
    echo   %TOMCAT_HOME%\bin\startup.bat
    echo.
    echo Then access the application at:
    echo   http://localhost:8080/%APP_NAME%/
    echo.
    pause
    exit /b 0
)

echo.
echo Step 4: Starting Tomcat...
if not exist "%TOMCAT_HOME%\bin\startup.bat" (
    echo ERROR: startup.bat not found in Tomcat bin directory!
    pause
    exit /b 1
)

start "Tomcat Server" "%TOMCAT_HOME%\bin\startup.bat"

echo.
echo ========================================
echo  Server Setup Complete!
echo ========================================
echo.
echo Tomcat is starting...
echo.
echo Wait 10-15 seconds for deployment, then access:
echo   http://localhost:8080/%APP_NAME%/
echo.
echo Tomcat logs location:
echo   %TOMCAT_HOME%\logs\
echo.
echo To stop Tomcat:
echo   %TOMCAT_HOME%\bin\shutdown.bat
echo.
echo Demo credentials:
echo   Admin: admin / admin123
echo   Student: john_doe / student123
echo.

REM Ask if user wants to open browser
set /p OPEN_BROWSER="Do you want to open the application in browser? (Y/N): "
if /i "%OPEN_BROWSER%"=="Y" (
    echo Opening browser in 10 seconds...
    timeout /t 10 /nobreak >nul
    start http://localhost:8080/%APP_NAME%/
)

echo.
pause
