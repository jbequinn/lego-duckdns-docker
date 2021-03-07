# lego-duckdns-docker

## What's this ##
Simple Docker image to automate obtaining and renewing [Let's Encrypt](https://letsencrypt.org/) SSL certificates for [DuckDNS](https://www.duckdns.org/) using the the dns-01 challenge.
The image uses [Lego](https://github.com/go-acme/lego), and supports both main domain and subdomains -wildcard.

Used in the [Nginx Lego Docker Image](https://github.com/jbequinn/nginx-lego) repository.
