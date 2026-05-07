FROM alpine:latest


RUN apk add --no-cache openvpn dante-client curl

COPY vpnuk.ovpn /etc/openvpn/client.conf
COPY auth.txt /etc/openvpn/auth.txt
COPY sockd.conf /etc/sockd.conf

RUN chmod 600 /etc/openvpn/auth.txt

EXPOSE 1080

CMD sh -c 'openvpn --config /etc/openvpn/client.conf --auth-user-pass /etc/openvpn/auth.txt --daemon && sockd -f /etc/sockd.conf -D && tail -f /dev/null'