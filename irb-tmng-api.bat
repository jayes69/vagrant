@echo off
call settings

call library :terminal_init TMNG-APIv2 - Rails Console

echo cat ^<^<EOF ^> /tmp/irb-api-launch > PuttyIrbApi
echo if which pry; then >> PuttyIrbApi
echo   cd /vagrant/ >> PuttyIrbApi
echo   pry -I. -e "require 'bundler';Bundler.setup;require './config/environment'" >> PuttyIrbApi
echo   true >> PuttyIrbApi
echo else >> PuttyIrbApi
echo   cd /vagrant/ >> PuttyIrbApi
echo   bundle exec rails c >> PuttyIrbApi
echo fi >> PuttyIrbApi
call :run PuttyIrbApi >NUL
del PuttyIrbApi

pushd %api_path%
vagrant ssh -c "/usr/bin/env bash --login /tmp/irb-api-launch"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [INFO] This terminal returned a non-zero exitcode: %ERRORLEVEL%
    pause
)
popd

GOTO :eof

:run
set __IPPATH=%TMP%\vgpath%RANDOM%.tmp
pushd %api_path%
vagrant ssh -c "ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2>>NUL >%__IPPATH%
popd
SET /p __IP_API=<%__IPPATH%
DEL %__IPPATH%
IF "%__IPPATH%" == "" (
  ECHO "Failed to detect running vagrant instance... Skipping command."
  GOTO :eof
)
ansicon plink.exe -t -ssh %__IP_API% -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\%1"
GOTO :eof