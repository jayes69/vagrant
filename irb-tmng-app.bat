@echo off
call settings

call library :terminal_init TMNG-APP - Rails Console
pushd %tmng_path%
vagrant ssh -c "/usr/bin/env bash -c 'cd /vagrant/apps/ticket_machine/ && bundle exec rails c'"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [INFO] This terminal returned a non-zero exitcode: %ERRORLEVEL%
    pause
)
popd