FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y wireguard iproute2 iptables curl qrencode && \
    mkdir /etc/wireguard && \
    chmod 700 /etc/wireguard

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 51820/udp

ENTRYPOINT ["/entrypoint.sh"]
