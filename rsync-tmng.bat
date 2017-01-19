@echo off
call settings

if "%1" == "reset" (
  set rsynced_tmng=
  goto :eof
)

if "%1" == "bundle" (
    set bundle="TRUE"
    shift
)

if "%1" NEQ "force" (
  if "%rsynced_tmng%" == "TRUE" ( goto :eof )
  set rsynced_tmng=TRUE
)

echo ===^> Rsyncing TMNG
if "%vg_autocommit%" NEQ "" (
  echo ==^> Executing Auto-commit
  call library :date
  pushd %tmng_path%
  git add *
  popd
)

pushd %tmng_path%
echo ==^> Rsyncing...
vagrant rsync
popd
