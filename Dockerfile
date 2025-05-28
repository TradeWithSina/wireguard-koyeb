FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wireguard-tools iproute2 iptables curl qrencode

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 51820/udp

ENTRYPOINT ["/entrypoint.sh"]
