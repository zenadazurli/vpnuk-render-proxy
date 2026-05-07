FROM alpine:3.19

RUN apk update && apk add --no-cache \
    openvpn \
    dante-server \
    curl \
    bash

COPY vpnuk.ovpn /etc/openvpn/client.conf
COPY sockd.conf /etc/sockd.conf

# Crea auth.txt all'avvio usando le variabili d'ambiente
CMD sh -c 'echo "$OVPN_USERNAME" > /etc/openvpn/auth.txt && \
           echo "$OVPN_PASSWORD" >> /etc/openvpn/auth.txt && \
           chmod 600 /etc/openvpn/auth.txt && \
           openvpn --config /etc/openvpn/client.conf --auth-user-pass /etc/openvpn/auth.txt --daemon && \
           sockd -f /etc/sockd.conf -D && \
           tail -f /dev/null'
