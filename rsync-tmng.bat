@echo off
call settings

pushd %tmng_path%
echo ===^> Rsyncing TMNG
echo ==^> Rsyncing...
vagrant rsync >NUL
popd