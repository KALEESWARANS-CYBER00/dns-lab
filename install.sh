#!/bin/bash
set -e

echo "[*] Creating Docker network..."
docker network inspect dns_lab_net >/dev/null 2>&1 || \
docker network create --subnet=172.25.0.0/24 dns_lab_net

echo "[*] Removing old containers if they exist..."
for c in auth-dns rec-dns dns-client; do
    if [ "$(docker ps -aq -f name=$c)" ]; then
        docker rm -f $c
    fi
done

echo "[*] Starting Authoritative DNS server..."
docker run -d --name auth-dns \
  --network dns_lab_net --ip 172.25.0.10 \
  -v $(pwd)/zones:/etc/bind \
  -p 5353:53/tcp -p 5353:53/udp \
  internetsystemsconsortium/bind9:9.18

echo "[*] Starting Recursive Resolver..."
docker pull mvance/unbound:latest >/dev/null
docker run -d --name rec-dns \
  --network dns_lab_net --ip 172.25.0.20 \
  -v $(pwd)/unbound/unbound.conf:/opt/unbound/etc/unbound/unbound.conf \
  mvance/unbound:latest

echo "[*] Starting Client container..."
docker run -it --name dns-client --network dns_lab_net --ip 172.25.0.30 ubuntu bash -c "\
apt update && apt install -y dnsutils curl && \
echo 'nameserver 172.25.0.20' > /etc/resolv.conf && bash"

echo "[*] DNS lab setup complete."
echo "Client container 'dns-client' is ready for testing."
