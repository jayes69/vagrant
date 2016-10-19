@echo off
call settings

echo ===^> Opening SSH
mode %terminal_width%
pushd %api_path%
vagrant ssh
popd