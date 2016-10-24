@echo off

if "%pathes_set%" == "" (
  echo ===^> Loading Settings...
  set pathes_set=TRUE

  call %~dp0\config-example

  if exist "config.bat" (
    call %~dp0\config
  ) else (
    echo ^[WARNING^] Configuration not found. Use configuration example as defaults.
    echo ^[INFO^] Copy the config-example.bat and name the copied file config.bat
    echo.
  )

  if "%vg_debug%" == "on" (
    echo ^[DEBUG^] This script is running in debug mode.
    echo ^[DEBUG^] Init-Script will not update automatically.
  )
)

