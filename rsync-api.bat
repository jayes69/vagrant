@echo off
call settings
call library :vagrant_version

pushd %api_path%
echo ===^> Rsyncing API
IF "%vagrant_version%" == "1.8.6" (
  echo ==^> Applying quickfix for vagrant/issue:7910
  vagrant ssh -c "if [ $(find /vagrant/log/ -maxdepth 1 -type f | wc -l) -gt 1 ]; then echo Deleting log directory; rm -rf /vagrant/log/*; fi;"
)
echo ==^> Rsyncing...
vagrant rsync 
popd