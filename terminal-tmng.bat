@echo off
call settings

echo ===^> Opening SSH on TMNG
call library :terminal_init TMNG - Terminal
pushd %tmng_path%
vagrant ssh
popd