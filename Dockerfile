# Don't use bhm because it has problem with tls connections
# When run bhm with/without argument -s it return "Cannot start TLS: handshake failure"

FROM debian:stretch-slim

ENV POSTFIX_VERSION 3.1.12-0+deb9u1

# install postfix
RUN set -ex; \
    apt-get update \
    && apt-get -y --no-install-recommends install \
        postfix="${POSTFIX_VERSION}" \
    ; \
    rm -rf /var/lib/apt/lists/*


# setting postfix
RUN set -ex; \
    postconf -e inet_protocols=ipv4


COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 25
CMD ["/usr/lib/postfix/sbin/master", "-d"]
