FROM ghcr.io/borgmatic-collective/borgmatic:1.8.11
LABEL maintainer="giovanni.fi05@gmail.com"

# Redis notifications require aioredis and python-dotenv
RUN pip install redis>=4.2.0rc1 python-dotenv
