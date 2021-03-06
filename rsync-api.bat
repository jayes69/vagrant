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

echo ===^> Rsyncing API
if "%vg_autocommit%" NEQ "" (
  echo ==^> Executing Auto-commit
  pushd %api_path%
  git add *
  popd
)

pushd %api_path%
IF "%vagrant_version%" == "1.8.6" (
  echo ==^> Applying quickfix for vagrant/issue:7910
  vagrant ssh -c "if [ $(find /vagrant/log/ -maxdepth 1 -type f | wc -l) -gt 1 ]; then echo Deleting log directory; rm -rf /vagrant/log/*; fi;"
)
echo ==^> Rsyncing...
vagrant rsync
popd
