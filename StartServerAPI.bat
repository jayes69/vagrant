@echo off
call settings

call stop-api
call rsync-api
echo ===^> Starting API

echo ==^> Starting API Server
if "%1"=="production" (
	SET railsenv=production
)
if "%1"=="development" (
	SET railsenv=development
)
if "%1"=="test" (
	SET railsenv=test
)
if "%railsenv%"=="" (
	SET railsenv=development
)

echo cat ^<^<-EOF ^> /tmp/puttya.sh > PuttyA
echo kill -SIGKILL $(lsof -i tcp:3000 -t) 2^> /dev/null >> PuttyA
echo source ~/.profile >> PuttyA
echo source /etc/profile >> PuttyA
echo cd /vagrant/ >> PuttyA
echo bundle install ^>/dev/null >> PuttyA
echo bundle exec bundle install ^>/dev/null >> PuttyA
echo echo -ne '\033]0;TicketMachine - API - %railsenv%\007' >> PuttyA
echo echo TicketMachine Enviroment: %railsenv% >> PuttyA
echo export DEVISE_SECRET_KEY="3773c094c7421013dcefdaf8515ef87f73b94e6310124bf81da6cc7c861d0b29a0d2ee7b6ccfac5f2f26665d9dc83826b1e170e21b88d83b5e75577c976a4773" >> PuttyA
echo rm /tmp/puttya.sh >>  PuttyA
echo bash --login bundle exec rails s -b 0.0.0.0 -e %railsenv% >> PuttyA
REM echo if ^[ $? -ne 0 ^]^; then read -n1 -p"Press any key to continue"; fi >> PuttyA
echo EOF>> PuttyA
echo screen -dmS tmng-api bash /tmp/puttya.sh >> PuttyA
echo screen -wipe ^>/dev/null >> PuttyA
echo function wait() { lsof -i tcp:3000 -t ^>/dev/null 2^>/dev/null; if [ $? -gt 0 ]; then sleep 1; else exit; fi; } >> PuttyA
echo echo ==\^> Waiting for Ports to be blocked >> PuttyA
echo for i in {1..20}; do wait; done >> PuttyA
echo screen -rx tmng-api >> PuttyA

ansicon plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" -m PuttyA
del PuttyA
