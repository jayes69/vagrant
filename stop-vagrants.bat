@echo off
call settings

call stop-all-servers
echo ===^> Stopping Vagrants

pushd %tmng_path%
echo =^> Halting TMNG
vagrant halt
popd

pushd %api_path%
echo =^> Halting API
vagrant halt
popd
