FROM alpine:3.13

RUN apk update
RUN apk add --no-cache lego openssl

COPY lego-cert.sh /etc/periodic/daily/

CMD ["/usr/sbin/crond", "-f"]
