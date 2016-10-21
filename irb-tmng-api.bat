@echo off
call settings

call library :terminal_init TMNG-APP - Rails Console
pushd %api_path%
vagrant ssh -c "/usr/bin/env bash -c 'bundle exec rails c'"
popd