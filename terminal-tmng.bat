@echo off
call settings

echo ===^> Opening SSH on TMNG
mode %terminal_width%
pushd %tmng_path%
vagrant ssh
popd