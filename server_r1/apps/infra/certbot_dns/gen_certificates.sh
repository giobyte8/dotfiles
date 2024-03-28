#!/bin/bash
# Generate X.509 TLS certificates and CA (Certificate Authority) to secure
# incoming server connections

# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
USER_CURR_PATH=$(pwd)

cd "${HERE}"

CREDENTIALS_FILE="./do_token"
TGT_DOMAIN="rd.giovanniaguirre.me" # TODO Read domains from .env file

# Define output directories for certificates (Read from env)
CERT_DIR="./certs"

# Certbot paths
/etc/letsencrypt
/var/lib/letsencrypt

# Use certbot to create certificates
# docker run -it --rm --name certbot                \
#   -v "${CREDENTIALS_FILE}:/opt/do_token"          \
#   -v "./certs/etcle:/etc/letsencrypt"             \
#   -v "./certs/lible:/var/lib/letsencrypt"         \
#   certbot/dns-digitalocean certonly               \
#     -v
#     --dry-run                                     \
#     --register-unsafely-without-email             \
#     --dns-digitalocean                            \
#     --dns-digitalocean-credentials /opt/do_token  \
#     -d "${TGT_DOMAIN}"

docker run -it --rm --name certbot                \
  -v "${CREDENTIALS_FILE}:/opt/do_token"          \
  -v "./certs/etcle:/etc/letsencrypt"             \
  -v "./certs/lible:/var/lib/letsencrypt"         \
  certbot/dns-digitalocean bash
