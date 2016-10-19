@echo off

if "%pathes_set%" == "" (
  echo ===^> Loading Settings...

  if exist config.bat (
    call config.bat
  ) else (
    echo [WARNING] Configuration not found. Use configuration example as defaults.
    call config-example.bat
  )

)

