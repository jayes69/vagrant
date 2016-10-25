@echo off
goto :run

:vagrant_status
pushd %1
for /f "tokens=3,4 delims=, " %%F IN ('vagrant status --machine-readable') DO (
  IF "%%F" == "state" (
    SET state=%%G
    goto :eoloop
  )

)
:eoloop
popd
goto :eof

:terminal_init
mode %terminal_width%
title %*
goto :eof

:vagrant_version
for /f "tokens=2" %%F IN ('vagrant --version') DO (
  SET vagrant_version=%%F
)
goto :eof

:run
call settings
call %*