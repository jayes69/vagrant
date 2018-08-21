@echo off
call settings

pushd %api_path%

echo ==^> Adding default gateway.
vagrant ssh -c "sudo ip route del 0.0.0.0/0"
vagrant ssh -c "sudo ip route add 0.0.0.0/0 via 10.10.10.254"
popd
