@echo off
call fix-hosts
call StartServerAPI %*
call StartServerTMNG %*