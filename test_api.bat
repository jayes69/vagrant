@echo off
call settings
call test_init %*

IF "%_t_norsync%" EQU "FALSE" (
  call rsync-api force
  call rsync-tmng force
) ELSE (
  echo =*=^> Skipping RSYNC
)

echo ===^> Executing Tests in APIv2
echo source ~/.profile > PuttyTApi
echo source /etc/profile >> PuttyTApi
echo cd /vagrant/ >> PuttyTApi
echo export RAILS_ENV=test >> PuttyTApi
echo bundle exec rake db:drop db:create db:migrate >> PuttyTApi
echo bundle exec rspec >> PuttyTApi
call :run PuttyTApi
del PuttyTApi

IF "%_t_pause%" EQU "TRUE" (
  echo ===^> Test completed...
  pause
)

GOTO :eof

:run
set __IPPATH=%TMP%\vgpath%RANDOM%.tmp
pushd %api_path%
vagrant ssh -c "ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2>>NUL >%__IPPATH%
popd
SET /p __IP_API=<%__IPPATH%
DEL %__IPPATH%
IF "%__IPPATH%" == "" (
  ECHO "Failed to detect running vagrant instance... Skipping command."
  GOTO :eof
)
ansicon plink.exe -t -ssh %__IP_API% -P 22 -l "vagrant" -pw "vagrant" -m "%cd%\%1"
GOTO :eof