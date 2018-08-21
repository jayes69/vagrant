@echo off
call settings

call library :vagrant_status %tmacs_path%
IF "%state%" == "running" (
  echo ===^> Stopping Server
  REM Join Server Processes with timeout.
  set SERVER_PORT=3000
  call :stop-server
  goto :eof
) ELSE (
  echo ===^> TMACS already stopped
  goto :eof
)

:stop-server
echo ==^> Waiting for Server on Port %SERVER_PORT%
echo PORT="%SERVER_PORT%" > PuttyTM
echo function wait() { lsof -i tcp:$PORT -t ^>/dev/null 2^>/dev/null; if [ $? -eq 0 ]; then sleep 1; else exit; fi; } >> PuttyTM
echo kill -SIGINT $(lsof -i tcp:$PORT -t) 2^>/dev/null >> PuttyTM
echo for i in {1..5}; do wait; done >> PuttyTM
echo echo "Server didn't stop after five seconds. Sending SIGTERM and wait 10 seconds..." >> PuttyTM
echo kill -SIGTERM $(lsof -i tcp:$PORT -t) 2^>/dev/null >> PuttyTM
echo lsof -i tcp:$PORT -t >> PuttyTM
echo for i in {1..10}; do wait; done >> PuttyTM
echo echo "Server didn't stop after ten seconds. Waiting thirty seconds..." >> PuttyTM
echo for i in {1..30}; do wait; done >> PuttyTM
echo kill -SIGKILL $(lsof -i tcp:$PORT -t) 2^>/dev/null >> PuttyTM
echo echo "Server didn't stop after thirty seconds. Killed them" >> PuttyTM
call :run PuttyTM
del PuttyTM
goto :eof


:run
set __IPPATH=%TMP%\vgpath%RANDOM%.tmp
pushd %tmacs_path%
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
:eof