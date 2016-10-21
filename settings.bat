@echo off

if "%pathes_set%" == "" (
  echo ===^> Loading Settings...
  set pathes_set=TRUE

  if exist "config.bat" (
    call config
  ) else (
    echo ^[WARNING^] Configuration not found. Use configuration example as defaults.
    echo ^[INFO^] Copy the config-example.bat and name the copied file config.bat
    echo.
    call config-example
  )

)

