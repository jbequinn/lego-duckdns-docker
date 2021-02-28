FROM alpine:3.13

RUN apk update
RUN apk add --no-cache lego openssl tini

COPY lego-cert.sh /etc/periodic/daily/

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/crond", "-f"]
