@echo off

call settings
pushd %tmng_path%
start cmd /c "@title APP && @cmd"
popd

