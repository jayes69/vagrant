@echo off
call settings
call test_init %*

IF "%_t_norsync%" EQU "FALSE" (
  call rsync-api force
  call rsync-tmng force
) ELSE (
  echo =*=^> Skipping RSYNC
)

echo ===^> Preparing Test environment
plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" bash -l -c 'bundle exec rake db:drop db:create db:migrate RAILS_ENV=test' >NUL

echo ===^> Executing Tests in APIv2
ansicon plink.exe -t -ssh api.ticketmachine.dev -P 22 -l "vagrant" -pw "vagrant" bash -l -c 'bundle exec rspec'

IF "%_t_pause%" EQU "TRUE" (
  echo ===^> Test completed...
  pause
)