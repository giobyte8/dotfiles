#
# Loads amex environment variables from local .env file


# If .env file exists at this script dir, source it
if [ -f ""$(dirname "$0")"/.env" ]; then
    source ""$(dirname "$0")"/.env"
fi
