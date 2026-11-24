@echo off
REM ============================================
REM Digital Library System - Quick Run
REM ============================================

echo.
echo ========================================
echo  Digital Library - Quick Run with Cargo
echo ========================================
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

echo Starting embedded Tomcat server with Cargo...
echo.
echo The application will be available at:
echo   http://localhost:8080/library-system/
echo.
echo Press Ctrl+C to stop the server
echo.

call mvn cargo:run

pause
