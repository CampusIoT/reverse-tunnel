
./generate_keys.sh
docker build -t campusiot/gateway-manager:latest .

docker rm -f gateway-manager
docker run -d --hostname gateway-manager --name gateway-manager -p 2222:2222 campusiot/gateway-manager:latest

ssh -i sshkeys/gateway-manager gateway-manager@localhost -p 2222
ssh -i sshkeys/gateway-0001 gateway-0001@localhost -p 2222
ssh -i sshkeys/gateway-0100 gateway-0100@localhost -p 2222

docker rm -f gateway-manager
