@echo off

call settings
pushd %tmng_path%
start cmd /c "@title APP && @cmd"
popd

pushd %api_path%
start cmd /c "@title API && @cmd"
popd
