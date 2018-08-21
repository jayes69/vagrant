@echo off
call settings
call test_init %*

IF "%_t_norsync%" EQU "FALSE" (
  call rsync-tmng force
) ELSE (
  echo =*=^> Skipping RSYNC
)

echo ===^> Running Test on TMNG App
echo bash -l -c 'cd /vagrant/apps/ticket_machine/; bundle exec rspec' > PuttyTApp

call :run PuttyTApp
del PuttyTApp

IF "%_t_pause%" EQU "TRUE" (
  echo ===^> Test completed...
  pause
)

:run
set __IPPATH=%TMP%\vgpath%RANDOM%.tmp
pushd %tmng_path%
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