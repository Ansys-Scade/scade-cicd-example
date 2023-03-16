@echo off

set SCADE_EXE=%SCADE_DIR%\SCADE\bin\scade.exe
set PYTHON_EXE=%SCADE_DIR%\contrib\Python37\python.exe
set PYTHONPATH=%SCADE_DIR%\SCADE\bin;%SCADE_DIR%\SCADE\APIs\Python\Lib;%PYTHONPATH%
set SCRIPT_PATH=%~dp0.
set WORKING_DIR=%cd%

:: check if there is an argument
if ["%~1"]==[""] goto usage
set PROJECT_TEST=%WORKING_DIR%\%~1

:: check if the project exists
if not exist "%PROJECT_TEST%" goto file1notexist

:: check if there is an argument
if ["%~2"]==[""] goto usage
set PROJECT_TEST_RESULT=%WORKING_DIR%\%~2

:: check if the project exists
if not exist "%PROJECT_TEST_RESULT%" goto file2notexist

:: check if there is an argument
if ["%~3"]==[""] goto usage
set CONF=%~3

@echo Executing the tests %PROJECT_TEST% using the configuration %CONF%
"%SCADE_EXE%" -test -tee "%PROJECT_TEST%" -conf "%CONF%" -result_project "%PROJECT_TEST_RESULT%"

:: check test results
@echo.
@echo "Check tests result:"
FOR %%I in (%PROJECT_TEST_RESULT%) do set TESTS_RESULT=%%~dpnI_tee.xml
"%PYTHON_EXE%" "%SCRIPT_PATH%\CheckResult.py" -v --tee "%PROJECT_TEST_RESULT%" -o "%TESTS_RESULT%"

if %errorlevel% neq 0 exit /B 1

goto :eof

:usage
@echo Usage: %0 ^<SCADE test project^ ^<SCADE test result project^> ^<SCADE configuration^>
exit /B 1
:file1notexist
@echo Error: file ^<%PROJECT_TEST%^> does not exist
exit /B 1
:file2notexist
@echo Error: file ^<%PROJECT_TEST_RESULT%^> does not exist
exit /B 1