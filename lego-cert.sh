#!/bin/sh

DOMAIN="${DOMAIN:-""}"
DUCKDNS_TOKEN="${DUCKDNS_TOKEN:-""}"
EMAIL="${EMAIL:-""}"
SERVER="${SERVER:-""}"
RECREATE="${RECREATE:-false}"

echo_timestamp() {
  echo "$(date -u +"%Y/%m/%d %H:%M:%S") [INFO] - $1"
}

run_lego() {
  /usr/bin/lego \
    --accept-tos \
    --server=${SERVER} \
    --key-type ec384 \
    --domains ${DOMAIN} \
    --domains *.${DOMAIN} \
    --email ${EMAIL} \
    --path /data \
    --dns duckdns \
    $1
}

copy_certificates() {
  echo_timestamp "Copying certificates to /certs"
  cp /data/certificates/${DOMAIN}.crt /certs/certificate.crt
  cp /data/certificates/${DOMAIN}.key /certs/certificate.key
  echo_timestamp "Copying done."
}

echo_timestamp "Starting process."

if [ ! -d "/data" ]; then
  echo_timestamp "Directory /data not found! Exiting."
  exit 1
fi

if [ ! -d "/certs" ]; then
  echo_timestamp "Directory /certs not found! Exiting."
  exit 1
fi

if [ -z "$DOMAIN" ]; then
  echo_timestamp "Domain is not set! Exiting."
  exit 1
fi

if [ -z "$SERVER" ]; then
  echo_timestamp "Server is not set! Exiting."
  exit 1
fi

if [ -z "$DUCKDNS_TOKEN" ]; then
  echo_timestamp "DuckDNS token is not set! Exiting."
  exit 1
fi

if [ -z "$EMAIL" ]; then
  echo_timestamp "Email is not set! Exiting."
  exit 1
fi

if [ "$RECREATE" = true ]; then
  echo_timestamp "Deleting all existing certificate data."
  rm -rf /data/*
  echo_timestamp "Data deleted."
fi

if [ -d "/data/certificates" ]; then
  echo_timestamp "Account appears to exist already."
  if openssl x509 -checkend $((60*60*24*29)) -noout -in "/data/certificates/${DOMAIN}.crt"; then
    echo_timestamp "Certificate is not expiring yet."
  else
    echo_timestamp "Certificate is out of the renewal limit. Attempting renewal."
    run_lego renew
    copy_certificates
  fi
else
  echo_timestamp "Account does not exist. Will create one."
  run_lego run
  copy_certificates
fi

echo_timestamp "All done. Exiting."
exit 0
