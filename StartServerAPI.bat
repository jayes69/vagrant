@echo off
call settings

call stop-api
echo ===^> Starting API
echo ==^> rsync API
pushd %api_path%
vagrant rsync >NUL 2>NUL
popd

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


echo kill -SIGKILL $(lsof -i tcp:3000 -t) 2^> /dev/null > PuttyA
echo source ~/.profile >> PuttyA
echo source /etc/profile >> PuttyA
echo cd /vagrant/ >> PuttyA
echo bundle install ^>/dev/null >> PuttyA
echo bundle exec bundle install ^>/dev/null >> PuttyA
echo echo -ne '\033]0;TicketMachine - API - %railsenv%\007' >> PuttyA
echo echo TicketMachine Enviroment: %railsenv% >> PuttyA
echo bash --login rails s -b 0.0.0.0 -e %railsenv% >> PuttyA
echo sleep 2 >> PuttyA

START "API" ansicon plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\PuttyA"
sleep 2
del PuttyA
