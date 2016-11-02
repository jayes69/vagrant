@echo off
call settings
call rsync-api %*
call rsync-tmng %*