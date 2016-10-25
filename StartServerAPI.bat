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

if "%2" == "local" (
  SET runcommand=
) else (
  SET runcommand=START ^"API^"
)


echo kill -SIGKILL $(lsof -i tcp:3000 -t) 2^> /dev/null > PuttyA
echo source ~/.profile >> PuttyA
echo source /etc/profile >> PuttyA
echo cd /vagrant/ >> PuttyA
echo bundle install ^>/dev/null >> PuttyA
echo bundle exec bundle install ^>/dev/null >> PuttyA
echo echo -ne '\033]0;TicketMachine - API - %railsenv%\007' >> PuttyA
echo echo TicketMachine Enviroment: %railsenv% >> PuttyA
echo export DEVISE_SECRET_KEY="3773c094c7421013dcefdaf8515ef87f73b94e6310124bf81da6cc7c861d0b29a0d2ee7b6ccfac5f2f26665d9dc83826b1e170e21b88d83b5e75577c976a4773" >> PuttyA
echo bash --login bundle exec rails s -b 0.0.0.0 -e %railsenv% >> PuttyA
echo if ^[ $? -ne 0 ^]^; then read -n1 -p"Press any key to continue"; fi >> PuttyA

%runcommand% ansicon plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\PuttyA"
sleep 2
del PuttyA
