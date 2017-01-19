@echo off
call settings

REM PARSING ENVIRONMENT
set _t_app_norsync="FALSE"
IF "%1" EQU "norsync" (
    set _t_app_norsync="TRUE"
    shift
)
IF "test_norsync" EQU "TRUE" (
    set _t_app_norsync="TRUE"
)

IF %_t_app_norsync% EQU "FALSE" (
  call rsync-tmng force
) ELSE (
  echo =*=^> Skipping RSYNC
)

echo ===^> Running Test on TMNG App
ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" bash -l -c 'cd /vagrant/apps/ticket_machine/; bundle exec rspec'