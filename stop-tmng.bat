@echo off
call settings

call library :vagrant_status %tmng_path%
IF "%state%" == "running" (
  echo ===^> Stopping Servers on TMNG
  echo ==^> Sending SIGINT to all Servers to speed up shutdown process
  echo kill -SIGINT $(lsof -i tcp:3000 -t^) 2^> /dev/null > PuttyTK
  echo kill -SIGINT $(lsof -i tcp:3103 -t^) 2^> /dev/null >> PuttyTK
  echo kill -SIGINT $(lsof -i tcp:3106 -t^) 2^> /dev/null >> PuttyTK
  echo kill -SIGINT $(lsof -i tcp:9292 -t^) 2^> /dev/null >> PuttyTK
  call :run PuttyTK
  del PuttyTK

  REM Join Server Processes with timeout.
  set SERVER_PORT=3000
  call :stop-server
  set SERVER_PORT=3103
  call :stop-server
  set SERVER_PORT=3106
  call :stop-server
  set SERVER_PORT=9292
  call :stop-server
  goto :eof
) ELSE (
  echo ===^> TMNG already stopped
  goto :eof
)

:stop-server
echo ==^> Waiting for Server on Port %SERVER_PORT%
echo PORT="%SERVER_PORT%" > PuttyTK
echo function wait() { lsof -i tcp:$PORT -t ^>/dev/null 2^>/dev/null; if [ $? -eq 0 ]; then sleep 1; else exit; fi; } >> PuttyTK
echo kill -SIGINT $(lsof -i tcp:$PORT -t) 2^>/dev/null >> PuttyTK
echo for i in {1..5}; do wait; done >> PuttyTK
echo echo "Server didn't stop after five seconds. Sending SIGTERM and wait 10 seconds..." >> PuttyTK
echo kill -SIGTERM $(lsof -i tcp:$PORT -t) 2^>/dev/null >> PuttyTK
echo lsof -i tcp:$PORT -t >> PuttyTK
echo for i in {1..10}; do wait; done >> PuttyTK
echo echo "Server didn't stop after ten seconds. Waiting thirty seconds..." >> PuttyTK
echo for i in {1..30}; do wait; done >> PuttyTK
echo kill -SIGKILL $(lsof -i tcp:$PORT -t) 2^>/dev/null >> PuttyTK
echo echo "Server didn't stop after thirty seconds. Killed them" >> PuttyTK
call :run PuttyTK
del PuttyTK
goto :eof

:run
set __DATA=%cd%\%1

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
goto :eof