@echo off
call settings

call library :terminal_init TMNG-APP - Rails Console
pushd %tmng_path%
vagrant ssh -c "/usr/bin/env bash -c 'cd /vagrant/apps/ticket_machine/ && bundle exec rails c'"
popd