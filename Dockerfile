# Don't use bhm because it has problem with tls connections
# When run bhm with/without argument -s it return "Cannot start TLS: handshake failure"

FROM debian:stretch-slim

# install postfix
RUN set -ex; \
    apt-get update \
    && apt-get -y --no-install-recommends install \
        postfix=3.1.12-0+deb9u1 \
    ; \
    rm -rf /var/lib/apt/lists/*

ENV RECIPIENT blackhole@example.com

RUN set -ex; \
    # add domain for receive mails
    RECIPIENT_DOMAIN="$(echo "$RECIPIENT" | cut -d "@" -f 2)" \
    && postconf mydestination="\$myhostname, localhost, $RECIPIENT_DOMAIN" \
    \
    # create "blackhole" for bounce message
    && echo "$RECIPIENT discard:silently" > /etc/postfix/transport \
    && postmap /etc/postfix/transport \
    && postconf -e transport_maps="hash:/etc/postfix/transport" \
    \
    # other settings
    && postconf -e inet_protocols=ipv4

EXPOSE 25

CMD ["/usr/lib/postfix/sbin/master", "-d"]