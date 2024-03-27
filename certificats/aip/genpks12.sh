#!/bin/bash

openssl pkcs12 -export -out aip-client.p12 -inkey private.key -in public.crt

PASS: GGFT987654356DFCFDT
GENERATE cert

openssl pkcs12 -in aip-client.p12 -clcerts -nokeys -out certs/certificate.crt
openssl pkcs12 -in aip-client.p12 -nocerts -out certs/private.key