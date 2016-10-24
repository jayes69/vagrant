@echo off
call settings

call library :terminal_init TMNG-APIv2 - Rails Console
pushd %api_path%
call library :irb_init /vagrant/
vagrant ssh -c "/usr/bin/env bash -c 'bundle exec rails c'"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [INFO] This terminal returned a non-zero exitcode: %ERRORLEVEL%
    pause
)
popd