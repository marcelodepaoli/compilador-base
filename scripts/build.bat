@echo off
setlocal
cd /d "%~dp0.."

rem JDK portavel: jdk\bin ou jdk\<subpasta>\bin; senao usa JAVA_HOME/PATH
if exist "jdk\bin\javac.exe" set "JAVA_HOME=%CD%\jdk"
for /d %%D in (jdk\*) do if exist "%%D\bin\javac.exe" set "JAVA_HOME=%%~fD"
if defined JAVA_HOME set "PATH=%JAVA_HOME%\bin;%PATH%"
where javac >nul 2>&1 || (echo ERRO: JDK nao encontrado. Extraia o JDK na pasta jdk\ & exit /b 1)
if not exist lib\javacc.jar (echo ERRO: lib\javacc.jar ausente & exit /b 1)

set "CMD=%1"
shift
if "%CMD%"=="gramatica" goto gramatica
if "%CMD%"=="compilar"  goto compilar
if "%CMD%"=="executar"  goto executar
if "%CMD%"=="tudo" (
  call :gramatica || exit /b 1
  call :compilar  || exit /b 1
  goto executar
)
echo Uso: build.bat gramatica^|compilar^|executar^|tudo
exit /b 1

:gramatica
if not exist build\gen mkdir build\gen
java -cp lib\javacc.jar javacc -OUTPUT_DIRECTORY=build\gen src\Calc.jj
exit /b %errorlevel%

:compilar
if not exist build\classes mkdir build\classes
(for %%f in (build\gen\*.java src\*.java) do echo %%f) > build\sources.txt
javac -encoding UTF-8 -d build\classes @build\sources.txt
exit /b %errorlevel%

:executar
java -cp build\classes Main %1 %2 %3 %4 %5 %6 %7 %8 %9
exit /b %errorlevel%
