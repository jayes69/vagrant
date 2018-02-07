@echo off
call settings.bat

pushd %tmng_path%
git stash
git fetch
git checkout origin/master
git merge origin/staging -S --no-ff -m "%1"
git branch -f master HEAD
git checkout master
git tag -s %1 -m "[Release] %1"
git push --tags origin master
git stash pop
popd
