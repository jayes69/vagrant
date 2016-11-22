@echo off
call settings

IF "%1" == "" (
  set environment=development
) ELSE (
  set environment=%1
)

pushd %tmng_path%
vagrant ssh -- -t less +G -R /vagrant/apps/ticket_machine/log/%environment%.log
popd