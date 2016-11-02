@echo off

REM Enter this Path to the TMNG App Vagrant Root
set tmng_path=C:\Devel\projekte\tmng

REM Enter this Path to the TMNG Api Vagrant Root
set api_path=C:\Devel\projekte\tmng_api

REM Enter the desired buffer width of the terminal
REM opened by terminal-api.bat and terminal-tmng.bat
set terminal_width=150

REM Do autocommit if vg_autocommit is set to a non-empty value
set vg_autocommit=

REM Set this to on to disable automatical batch script update.
set vg_debug=off