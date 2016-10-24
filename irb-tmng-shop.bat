@echo off
call settings

call library :terminal_init TMNG-SHOP_SVR - Rails Console
pushd %tmng_path%
vagrant ssh -c "/usr/bin/env bash -c 'cd /vagrant/apis/shop_svr && bundle exec rails c'"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [INFO] This terminal returned a non-zero exitcode: %ERRORLEVEL%
    pause
)
popd