@echo off
call stop-vagrants

echo ===^> Starting Vagrants

pushd %api_path%
echo =^> Booting API
vagrant up
popd

pushd %tmng_path%
echo =^> Booting TMNG
vagrant up
popd

call restart-all-servers