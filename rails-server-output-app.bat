@echo off
call settings

ansicon plink.exe -t -ssh tmng-development -P 22 -l "vagrant" -pw "vagrant" screen -rx tmng-app