FROM linuxserver/wireguard

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 51820/udp

ENTRYPOINT ["/entrypoint.sh"]
