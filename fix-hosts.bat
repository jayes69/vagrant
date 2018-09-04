@echo off
call settings

echo ===^> Correcting /etc/hosts

echo ==^> Finding IPs
call :ip_api
call :ip_tmng

echo ==^> Modifying /etc/hosts on TMnG
echo sed /api\d.ticketmachine\.dev/d /etc/hosts ^>/tmp/hosts.new > PuttyFHT
echo echo %IP_API% api.ticketmachine.dev ^>^>/tmp/hosts.new >> PuttyFHT
echo sudo mv /tmp/hosts.new /etc/hosts >> PuttyFHT
call :run_tmng PuttyFHT

echo ==^> Modifying /etc/hosts on API
echo sed /tmng-development/d /etc/hosts ^>/tmp/hosts.new > PuttyFHA
echo echo %IP_TMNG% tmng-development ^>^>/tmp/hosts.new >> PuttyFHA
echo sudo mv /tmp/hosts.new /etc/hosts >> PuttyFHA
call :run_api PuttyFHA

echo ==^> Cleaning up
DEL PuttyFHA
DEL PuttyFHT
goto :eof

:ip_api
set __IPPATH=%TMP%\vgpath%RANDOM%.tmp
pushd %api_path%
vagrant ssh -c "ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2>>NUL >%__IPPATH%
popd
SET /p IP_API=<%__IPPATH%
DEL %__IPPATH%
GOTO :eof

:ip_tmng
set __IPPATH=%TMP%\vgpath%RANDOM%.tmp
pushd %tmng_path%
vagrant ssh -c "ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2>>NUL >%__IPPATH%
popd
SET /p IP_TMNG=<%__IPPATH%
GOTO :eof

:run_api
ansicon plink.exe -t -ssh %IP_API% -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\%1"
GOTO :eof

:run_tmng
ansicon plink.exe -t -ssh %IP_TMNG% -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\%1"
GOTO :eof