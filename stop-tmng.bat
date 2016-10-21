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
  plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\PuttyTK"
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
echo function wait() { lsof -i tcp:$PORT -t; if [ $? -eq 0 ]; then sleep 1; else exit; fi; } >> PuttyTK
echo kill -SIGINT $(lsof -i tcp:$PORT -t) 2^> /dev/null >> PuttyTK
echo for i in {1..5}; do wait; done >> PuttyTK
echo echo "Server didn't stop after five seconds. Sending SIGTERM and wait 10 seconds..." >> PuttyTK
echo kill -SIGTERM $(lsof -i tcp:$PORT -t) 2^> /dev/null >> PuttyTK
echo lsof -i tcp:$PORT -t >> PuttyTK
echo for i in {1..10}; do wait; done >> PuttyTK
echo echo "Server didn't stop after ten seconds. Waiting thirty seconds..." >> PuttyTK
echo for i in {1..30}; do wait; done >> PuttyTK
echo kill -SIGKILL $(lsof -i tcp:$PORT -t) 2^>/dev/null >> PuttyTK
echo echo "Server didn't stop after thirty seconds. Killed them" >> PuttyTK
plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\PuttyTK"
del PuttyTK
goto :eof