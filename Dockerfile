FROM alpine:3.13

RUN apk update
RUN apk add --no-cache curl openssl

RUN mkdir /app
RUN curl -L https://github.com/go-acme/lego/releases/download/v4.2.0/lego_v4.2.0_linux_amd64.tar.gz | tar -zxv -C /app

COPY lego-cert.sh /etc/periodic/daily/

CMD ["/usr/sbin/crond", "-f"]
