@echo off
call settings

REM PARSING ENVIRONMENT
set _t_api_norsync="FALSE"
IF "%1" EQU "norsync" (
    set _t_api_norsync="TRUE"
    shift
)
IF "test_norsync" EQU "TRUE" (
    set _t_api_norsync="TRUE"
)

IF %_t_api_norsync% EQU "FALSE" (
  call rsync-api force
  call rsync-tmng force
) ELSE (
  echo =*=^> Skipping RSYNC
)

echo ===^> Preparing Test environment
plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" bash -l -c 'bundle exec rake db:drop db:create db:migrate RAILS_ENV=test' >NUL

echo ===^> Executing Tests in APIv2
ansicon plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" bash -l -c 'bundle exec rspec'