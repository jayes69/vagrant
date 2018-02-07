@echo off
call settings

echo ===^> Opening SSH on TMACS
call library :terminal_init TMACS - Terminal
pushd %tmacs_path%
vagrant ssh
popd