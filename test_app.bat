@echo off
call settings
call test_init %*

IF "%_t_norsync%" EQU "FALSE" (
  call rsync-tmng force
) ELSE (
  echo =*=^> Skipping RSYNC
)

echo ===^> Running Test on TMNG App
ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" bash -l -c 'cd /vagrant/apps/ticket_machine/; bundle exec rspec'

IF "%_t_pause%" EQU "TRUE" (
  echo ===^> Test completed...
  pause
)