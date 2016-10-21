@echo off
call settings

pushd %api_path%
start cmd /c "@title API && @cmd"
popd
