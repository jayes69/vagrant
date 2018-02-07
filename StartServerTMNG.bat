@echo off
call settings

call stop-tmng
call rsync-tmng
echo ===^> Starting TMNG

echo ==^> Starting TMNG Servers
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

echo cat ^<^<EOF ^> /tmp/putty.sh > Putty
echo source ~/.profile >> Putty
echo source /etc/profile >> Putty
echo kill -SIGKILL $(lsof -i tcp:3000 -t) 2^> /dev/null >> Putty
echo cd /vagrant/apps/ticket_machine/ >> Putty
echo bundle install ^>/dev/null >> Putty
echo bundle exec bundle install ^>/dev/null >> Putty
echo echo -ne '\033]0;TicketMachine - %railsenv%\007' >> Putty
echo echo TicketMachine Enviroment: %railsenv% >> Putty
echo rm /tmp/putty.sh >> Putty
echo rails s puma -e %railsenv% >> Putty
echo sleep 5 >> Putty
echo EOF>>Putty
echo screen -dmS tmng-app bash /tmp/putty.sh >> Putty
echo screen -wipe ^>/dev/null >> Putty
echo function wait() { lsof -i tcp:3000 -t ^>/dev/null 2^>/dev/null; if [ $? -gt 0 ]; then sleep 1; else exit; fi; } >> Putty
echo echo ==\^> Waiting for Ports to be blocked >> Putty
echo for i in {1..20}; do wait; done >> Putty
echo screen -rx tmng-app >> Putty

echo cat ^<^<EOF ^> /tmp/putty1.sh > Putty1
echo source ~/.profile >> Putty1
echo source /etc/profile >> Putty1
echo kill -SIGKILL $(lsof -i tcp:3103 -t) 2^> /dev/null >> Putty1
echo cd /vagrant/apis/shop_svr/ >> Putty1
echo bundle install ^>/dev/null >> Putty1
echo bundle exec bundle install ^>/dev/null >> Putty1
echo echo -ne '\033]0;ShopSvr - %railsenv%\007' >> Putty1
echo echo ShopSvr Enviroment: %railsenv% >> Putty1
echo rm /tmp/putty1.sh >> Putty
echo rails s puma -p 3103 -e %railsenv% >> Putty1
echo sleep 5 >> Putty1
echo EOF>>Putty1
echo screen -dmS tmng-shop bash /tmp/putty1.sh >> Putty1
echo screen -wipe ^>/dev/null >> Putty1
echo function wait() { lsof -i tcp:3103 -t ^>/dev/null 2^>/dev/null; if [ $? -gt 0 ]; then sleep 1; else exit; fi; } >> Putty1
echo echo ==\^> Waiting for Ports to be blocked >> Putty1
echo for i in {1..20}; do wait; done >> Putty1
echo screen -rx tmng-shop >> Putty1

echo cat ^<^<EOF ^> /tmp/putty2.sh > Putty2
echo source ~/.profile >> Putty2
echo source /etc/profile >> Putty2
echo kill -SIGKILL $(lsof -i tcp:3106 -t) 2^> /dev/null >> Putty2
echo cd /vagrant/apis/schedule_svr/ >> Putty2
echo bundle install ^>/dev/null >> Putty2
echo bundle exec bundle install ^>/dev/null >> Putty2
echo echo -ne '\033]0;ScheduleSvr - %railsenv%\007' >> Putty2
echo echo Schedule Enviroment: %railsenv% >> Putty2
echo rm /tmp/putty2.sh >> Putty2
echo rails s puma -p 3106 -e %railsenv% >> Putty2
echo sleep 5 >> Putty2
echo EOF>>Putty2
echo screen -dmS tmng-schedule bash /tmp/putty2.sh >> Putty2
echo screen -wipe ^>/dev/null >> Putty2
echo function wait() { lsof -i tcp:3106 -t ^>/dev/null 2^>/dev/null; if [ $? -gt 0 ]; then sleep 1; else exit; fi; } >> Putty2
echo echo ==\^> Waiting for Ports to be blocked >> Putty2
echo for i in {1..20}; do wait; done >> Putty2
echo screen -rx tmng-schedule >> Putty2

echo cat ^<^<EOF ^> /tmp/putty3.sh > Putty3
echo source ~/.profile >> Putty3
echo source /etc/profile >> Putty3
echo kill -SIGKILL $(lsof -i tcp:9292 -t) 2^> /dev/null >> Putty3
echo sleep 5 >> Putty3
echo cd /vagrant/apps/ticket_machine/ >> Putty3
echo bundle install ^>/dev/null >> Putty3
echo bundle exec bundle install ^>/dev/null >> Putty3
echo echo -ne '\033]0;Faye - %railsenv%\007' >> Putty3
echo echo Faye Enviroment: %railsenv% >> Putty3
echo rm /tmp/putty3.sh >> Putty3
echo rackup faye.ru -E %railsenv% >> Putty3
echo EOF>>Putty3
echo screen -dmS tmng-faye bash /tmp/putty3.sh >> Putty3
echo screen -wipe ^>/dev/null >> Putty3
echo function wait() { lsof -i tcp:9292 -t ^>/dev/null 2^>/dev/null; if [ $? -gt 0 ]; then sleep 1; else exit; fi; } >> Putty3
echo echo ==\^> Waiting for Ports to be blocked >> Putty3
echo for i in {1..20}; do wait; done >> Putty3
echo screen -rx tmng-faye >> Putty3

call :run Putty
call :run Putty1
call :run Putty2
call :run Putty3

echo Initializing TMNG
echo wget http://localhost:3000/ ^>^> /dev/null ^|^| true > Putty4
echo wget http://localhost:3000/customer/kb ^>^> /dev/null ^|^| true >> Putty4
call :run Putty4

del Putty
del Putty1
del Putty2
del Putty3
del Putty4

GOTO eof

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
:eof