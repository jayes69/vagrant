@echo off
call settings

echo ===^> Starting TMNG
echo ==^> rsync TMNG
pushd %tmng_path%
vagrant rsync >NUL 2>NUL
popd

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

echo source ~/.profile > Putty
echo source /etc/profile >> Putty
echo kill -SIGTERM $(lsof -i tcp:3000 -t) 2^> /dev/null >> Putty
echo cd /vagrant/apps/ticket_machine/ >> Putty
echo bundle install ^>/dev/null >> Putty
echo bundle exec bundle install ^>/dev/null >> Putty
echo echo -ne '\033]0;TicketMachine - %railsenv%\007' >> Putty
echo echo TicketMachine Enviroment: %railsenv% >> Putty
echo rails s puma -e %railsenv% >> Putty
echo sleep 5 >> Putty

echo source ~/.profile > Putty1
echo source /etc/profile >> Putty1
echo kill -SIGTERM $(lsof -i tcp:3103 -t) 2^> /dev/null >> Putty1
echo cd /vagrant/apis/shop_svr/ >> Putty1
echo bundle install ^>/dev/null >> Putty1
echo bundle exec bundle install ^>/dev/null >> Putty1
echo echo -ne '\033]0;ShopSvr - %railsenv%\007' >> Putty1
echo echo ShopSvr Enviroment: %railsenv% >> Putty1
echo rails s puma -p 3103 -e %railsenv% >> Putty1
echo sleep 5 >> Putty1

echo source ~/.profile > Putty2
echo source /etc/profile >> Putty2
echo kill -SIGTERM $(lsof -i tcp:3106 -t) 2^> /dev/null >> Putty2
echo cd /vagrant/apis/schedule_svr/ >> Putty2
echo bundle install ^>/dev/null >> Putty2
echo bundle exec bundle install ^>/dev/null >> Putty2
echo echo -ne '\033]0;ScheduleSvr - %railsenv%\007' >> Putty2
echo echo Schedule Enviroment: %railsenv% >> Putty2
echo rails s puma -p 3106 -e %railsenv% >> Putty2
echo sleep 5 >> Putty2

echo source ~/.profile > Putty3
echo source /etc/profile >> Putty3
echo kill -SIGTERM $(lsof -i tcp:9292 -t) 2^> /dev/null >> Putty3
echo sleep 5 >> Putty3
echo cd /vagrant/apps/ticket_machine/ >> Putty3
echo bundle install ^>/dev/null >> Putty3
echo bundle exec bundle install ^>/dev/null >> Putty3
echo echo -ne '\033]0;Faye - %railsenv%\007' >> Putty3
echo echo Faye Enviroment: %railsenv% >> Putty3
echo rackup faye.ru -E %railsenv% >> Putty3
echo sleep 5 >> Putty3

START "TICKET MACHINE" ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\Putty"
START "SHOP" ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\Putty1"
START "SCHEDULE" ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\Putty2"
START "FAYE" ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\Putty3"

echo Waiting for Servers to start
sleep 20

echo Initializing TMNG
echo wget http://tmng-development:3000/ ^>^> /dev/null ^|^| true > Putty4
echo wget http://tmng-development:3000/customer/kb ^>^> /dev/null ^|^| true >> Putty4
ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\Putty4" >NUL

del Putty
del Putty1
del Putty2
del Putty3
del Putty4