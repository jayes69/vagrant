@echo off
call settings

call stop-tmacs
call rsync-tmacs
echo ===^> Starting TMACS

echo ==^> Starting TMACS Server
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

echo cat ^<^<-EOF ^> /tmp/puttya.sh > PuttyM
echo kill -SIGKILL $(lsof -i tcp:3000 -t) 2^> /dev/null >> PuttyM
echo source ~/.profile >> PuttyM
echo source /etc/profile >> PuttyM
echo cd /vagrant/ >> PuttyM
echo bundle install ^>/dev/null >> PuttyM
echo bundle exec bundle install ^>/dev/null >> PuttyM
echo echo -ne '\033]0;TicketMachine - API - %railsenv%\007' >> PuttyM
echo echo TicketMachine Enviroment: %railsenv% >> PuttyM
echo export DEVISE_SECRET_KEY="3773c094c7421013dcefdaf8515ef87f73b94e6310124bf81da6cc7c861d0b29a0d2ee7b6ccfac5f2f26665d9dc83826b1e170e21b88d83b5e75577c976a4773" >> PuttyA
echo rm /tmp/puttya.sh >>  PuttyM
echo bash --login bundle exec rails s -b 0.0.0.0 -e %railsenv% >> PuttyM
REM echo if ^[ $? -ne 0 ^]^; then read -n1 -p"Press any key to continue"; fi >> PuttyM
echo EOF>> PuttyM
echo screen -dmS tmng-tmacs bash /tmp/puttya.sh >> PuttyM
echo screen -wipe ^>/dev/null >> PuttyM
echo function wait() { lsof -i tcp:3000 -t ^>/dev/null 2^>/dev/null; if [ $? -gt 0 ]; then sleep 1; else exit; fi; } >> PuttyM
echo echo ==\^> Waiting for Ports to be blocked >> PuttyM
echo for i in {1..20}; do wait; done >> PuttyM
echo screen -rx tmng-tmacs >> PuttyM

call :run PuttyM
del PuttyA

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