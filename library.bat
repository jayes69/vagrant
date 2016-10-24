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

:irb_init
vagrant ssh -c "/usr/bin/env bash -c 'cd %1 && gem list -i pry-rails'" >NUL
if errorlevel EQ 1 (
    vagrant ssh -c "/usr/bin/env bash -c 'cd %1 && gem install pry-rails" >NUL
)
goto :eof

:run
call settings
call %*