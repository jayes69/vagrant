@echo off
call settings

IF "%1" == "" (
  set environment=development
) ELSE (
  set environment=%1
)

pushd %tmacs_path%
vagrant ssh -- -t less +G -R /vagrant/log/%environment%.log
popd