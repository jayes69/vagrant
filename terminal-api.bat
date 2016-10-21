@echo off
call settings

echo ===^> Opening SSH
call library :terminal_init API - Terminal
pushd %api_path%
vagrant ssh
popd