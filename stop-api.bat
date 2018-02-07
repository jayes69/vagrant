@echo off
call settings
call library :vagrant_status %api_path%
if "%state%" NEQ "running" (
  echo ===^> API already stopped
  goto :eof
)
echo ===^> Stopping API
echo function wait() { lsof -i tcp:3000 -t ^>/dev/null 2^>/dev/null; if [ $? -eq 0 ]; then sleep 1; else exit; fi; } > PuttyAK
echo kill -SIGINT $(lsof -i tcp:3000 -t) 2^> /dev/null >> PuttyAK
echo for i in {1..5}; do wait; done >> PuttyAK
echo echo "Server didn't stop after five seconds. Waiting ten seconds..." >> PuttyAK
echo kill -SIGTERM $(lsof -i tcp:3000 -t) 2^> /dev/null >> PuttyAK
echo for i in {1..10}; do wait; done >> PuttyAK
echo echo "Server didn't stop after ten seconds. Waiting thirty seconds..." >> PuttyAK
echo for i in {1..30}; do wait; done >> PuttyAK
echo kill -SIGKILL $(lsof -i tcp:3000 -t) 2^>/dev/null >> PuttyAK
echo echo "Server didn't stop after thirty seconds. Killed them" >> PuttyAK
call :run PuttyAK
del PuttyAK
goto :eof

:run
set __IPPATH=%TMP%\vgpath%RANDOM%.tmp
pushd %tmng_path%
vagrant ssh -c "ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2>>NUL >%__IPPATH%
popd
SET /p __IP=<%__IPPATH%
DEL %__IPPATH%
IF "%__IPPATH%" == "" (
  ECHO "Failed to detect running vagrant instance... Skipping command."
  GOTO :eof
)
ansicon plink.exe -t -ssh %__IP% -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\%1"
GOTO :eof