# Remote server 1

As the name indicates, this server is deployed offsite. Mainly used as a
reverse proxy for `hservices`. It does not need great computational capacity.

1. [Applications and services](#applications-and-services)
    1. [R1 Bifrost](#r1-bifrost)
        1. [Traffic encryption](#traffic-encryption)
        2. [Encryption of traffic to upstream servers](#encryption-of-traffic-to-upstream-servers)
        3. [Realtime monitoring](#realtime-monitoring)
    2. [Plausible](#plausible)

# TODOs

- [ ] Configure realtime monitoring for r1bifrost
- [ ] Automate IP refresh for home server
- [ ] Automate renewal of ssl certificates for upstream traffic

# Applications and services

Services are deployed though docker containers managed by docker compose.

## Infrastructure

This section groups all services which main purpose is to support and offer services to *other* services.

### Bifrost

> The portal to other worlds ⚡️

Nginx reverse proxy with integrated [certbot](https://eff-certbot.readthedocs.io/en/latest/intro.html) for SSL. It listens in host's `80` and `443` port and redirects trafic to appropriate services.

All traffic received on port `80` is redirected to `443` port to force usage of `https`

#### Traffic encryption

The reverse proxy uses [Let's encrypt](https://letsencrypt.org/) for securing traffic from clients to the reverse proxy (bifrost). Container is based on a [customized nginx docker image](https://github.com/JonasAlfredsson/docker-nginx-certbot) that includes support for `certbot`.

The container reads the configured subdomains from the [bifrost/sites/](./apps/infra/bifrost/sites/) folder and requests/renew certificates as required.

See the [offical docs](https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/docs/good_to_know.md#how-the-script-add-domain-names-to-certificate-requests) for additional details.

#### Encryption of traffic to upstream servers

Some of the services to which traffic is proxied are hosted in a different network than **bifrost** container, hence, traffic travels through internet and encryption is required.

Self signed ssl certificates are used to encrypt upstream traffic. Such ssl certificates were created and configured following below documentation:

1. [Nginx doc: Securing http traffic upstream](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/)
2. [Microsoft doc: Generate self signed ssl certificates with custom Certificate Authority](https://learn.microsoft.com/en-us/azure/application-gateway/self-signed-certificates)

The steps for generation of self signed certificates are documented in
[hservices server docs](./../server/apps/infrastructure/README.md#generate-self-signed-certificates)

Once the `client` certificate and `CA` key had been transferred to `remote1`, we can update  `bifrost` config to encrypt traffic to upstream server.

1. Set right value for `BIFROST_UPSTREAM_SSL_PATH` variable in `.env` file. 
   It should point to directory containing the client certificate and CA.
2. Configure sites in [bifrost_sites/](./apps/infra/bifrost/sites/*.conf) files to use self signed certificate to secure traffic. Use existing sites or [nginx docs](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/) as reference.
   Main added parts are detailed below:

```conf
server {
    # ... Let's encrypt certificates
    # ... Other configs

    location / {
        # ...

        # Encrypt upstream traffic to proxied server
    	  proxy_ssl_certificate         /mnt/upstream_ssl_certs/client.crt;
    	  proxy_ssl_certificate_key     /mnt/upstream_ssl_certs/client.key;
    	  proxy_ssl_protocols           TLSv1 TLSv1.1 TLSv1.2;
    	  proxy_ssl_ciphers             HIGH:!aNULL:!MD5;
    	  proxy_ssl_trusted_certificate /mnt/upstream_ssl_certs/ca.crt;

        proxy_ssl_session_reuse on;
    }
}
```

#### Realtime monitoring

Since `bifrost` is the one that receives all external traffic, real time
monitoring and alerting has been configured.

- [ ] Document monitoring implementation

#### Deployment

Pretty straightforward, setup your env values and start container.

From infra root path run following commands

```shell
cp bifrost/proxy_pass.template.conf bifrost/proxy_pass.conf
vim bifrost/proxy_pass.conf
# Enter IP address for upstream server
```

Also, make sure to set values for `NCBOT_*` prefixed variables in your `.env` file, which should be based on [template.env](./apps/infra/template.env) file.

Once right values are in place, go ahead and start the service

```shell
docker-compose up -d bifrost
```

### Cronic Certbot

Use this service to create and maintain SSL certificates for services that doesn't have an http server. For example, databases or TCP servers.

It uses [certbot](https://eff-certbot.readthedocs.io/en/latest/) and its [DNS plugins](https://eff-certbot.readthedocs.io/en/latest/using.html#dns-plugins) to verify domain control.

Deployment is very straighforward, just follow [this guide](https://github.com/giobyte8/cronic_certbot?tab=readme-ov-file#usage) to configure environment values and domains which you need SSL certificates for and you're good to go

```shell
docker-compose up -d
```

> Since certbot needs to run as root user, there might be a chance that other containers doesn't have enough permissions to read certificate. If you face permissions related issues just make sure to set right values through `chmod` for certificate files. Usually read access is enough for other containers.
>
> ccertbot service tries to set them by default, but as always there are edge cases for everything.

### Redis

This service uses the official docker image with a custom config to accept only secure TLS connections.

> **TLS certificates** 
>
> In order to secure client connections, redis instance requires a valid SSL certificate. You can use provided [cronic_certbot]() to generate it and then mount certificates into redis container as described below.

#### Deployment

1. Update `.env` config to point to right SSL certificates
   ```shell
   REDIS_SSL_CERT_FILE=<path to cert: (e.g. cert.pem)>
   REDIS_SSL_KEY_FILE=<path to cert: (e.g. privkey.pem)>
   REDIS_SSL_CA_FILE=<path to CA cert: (e.g. chain.pem)>
   ```

   If you're using `cronic_certbot` or [Let's encrypt]() directly you should point to corresponding files as follows:

   - `REDIS_SSL_CERT_FILE` Point this to certificate file, usually `cert.pem`
   - `REDIS_SSL_KEY_FILE` This is the private key for certificate, usually `privkey.pem`
   - `REDIS_SSL_CA_FILE` This is the intermediate CA, usually named `chain.pem`

2. Setup users and passwords
   ```shell
   cd infra/redis
   cp users.acl.template.conf users.acl.conf
   vim users.acl.conf
   ```

   Enter values for admin and application user. To generate a secure password you can use another redis instance and invoke `ACL GENPASS` command. Of course any other method to generate passwords is valid as well.

   > As you can see in ACL file, `default` user is disabled, this is for security and due to config `protected-mode yes`. When protected mode is enabled and default user has no password assigned, then, all connections from external word are blocked automatically. Instead of assign a password for it I disabled `default` user.

3. Redis is now ready for deployment
   ```shell
   docker-compose up -d redis
   
   # Optionally follow logs
   docker-compose logs -f redis
   ```


## Plausible

- [ ] Automate deployment and document implementation























