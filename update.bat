@echo off
call settings

IF "%vg_debug%" == "on" (
  echo ^[DEBUG^] Debug mode doesn't update.
) ELSE (
  echo ===^> Updating Scripts...
  for /f %%i in ('git rev-parse --abbrev-ref HEAD') do git pull origin %%i
)

set pathes_set=
call settings
goto :eof
