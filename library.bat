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

:run
call settings
call %*