@echo off
call settings

echo ===^> Stopping API
echo function wait() { lsof -i tcp:3000 -t; if [ $? -eq 0 ]; then sleep 1; else exit; fi; } > PuttyAK
echo kill -SIGINT $(lsof -i tcp:3000 -t) 2^> /dev/null >> PuttyAK
echo for i in {1..5}; do wait; done >> PuttyAK
echo echo "Server didn't stop after five seconds. Waiting ten seconds..." >> PuttyAK
echo kill -SIGTERM $(lsof -i tcp:3000 -t) 2^> /dev/null >> PuttyAK
echo for i in {1..10}; do wait; done >> PuttyAK
echo echo "Server didn't stop after ten seconds. Waiting thirty seconds..." >> PuttyAK
echo for i in {1..30}; do wait; done >> PuttyAK
echo kill -SIGKILL $(lsof -i tcp:3000 -t) 2^>/dev/null >> PuttyAK
echo echo "Server didn't stop after thirty seconds. Killed them" >> PuttyAK
plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\PuttyAK"
del PuttyAK