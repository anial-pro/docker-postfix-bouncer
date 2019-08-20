#!/usr/bin/env bash

if [[ -n "${RECIPIENT}" ]]; then
    # add domain for receive mails
    RECIPIENT_DOMAIN="$(echo "$RECIPIENT" | cut -d "@" -f 2)"
    postconf -e mydestination="\$myhostname, localhost, ${RECIPIENT_DOMAIN}"

    # create "blackhole" for bounce message
    echo "${RECIPIENT} discard:silently" > /etc/postfix/transport \
    && postconf -e transport_maps="hash:/etc/postfix/transport" \
    && postmap /etc/postfix/transport
fi

exec "$@"