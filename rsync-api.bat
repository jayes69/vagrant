@echo off
call settings
if "%1" == "reset" (
  set rsynced_api=
  goto :eof
)
if "%1" NEQ "force" (
  if "%rsynced_api%" == "TRUE" ( goto :eof )
  set rsynced_api=TRUE
)
call library :vagrant_version

if "%vg_autocommit%" NEQ "" (
  echo ===^> Executing Auto-commit
  call library :date
  pushd %api_path%
  for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set git_branch=%%i
  git commit -am "Auto-Commit at %date% %time% on %git_branch%"
  popd
)

echo ===^> Rsyncing API
pushd %api_path%
IF "%vagrant_version%" == "1.8.6" (
  echo ==^> Applying quickfix for vagrant/issue:7910
  vagrant ssh -c "if [ $(find /vagrant/log/ -maxdepth 1 -type f | wc -l) -gt 1 ]; then echo Deleting log directory; rm -rf /vagrant/log/*; fi;"
)
echo ==^> Rsyncing...
vagrant rsync 
popd