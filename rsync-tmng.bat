@echo off
call settings

if "%1" == "reset" (
  set rsynced_tmng=
  goto :eof
)

if "%1" NEQ "force" (
  if "%rsynced_tmng%" == "TRUE" ( goto :eof )
  set rsynced_tmng=TRUE
)

if "%vg_autocommit%" NEQ "" (
  echo ===^> Executing Auto-commit
  call library :date
  pushd %tmng_path%
  for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set git_branch=%%i
  git commit -am "Auto-Commit at %date% %time% on %git_branch%"
  popd
)

pushd %tmng_path%
echo ===^> Rsyncing TMNG
echo ==^> Rsyncing...
vagrant rsync
popd