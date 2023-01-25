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

Most of the services are deployed using docker containers

## R1 Bifrost

> The portal to other worlds ⚡️

Configuration files are located in [apps/r1bifrost](./apps/r1bifrost/)

Nginx reverse proxy that listens in host's `80` and `443` port and
redirects trafic to appropriate services.

All traffic received on port `80`
is redirected to `443` port to force usage of `https`

### Traffic encryption

The reverse proxy uses [Let's encrypt](https://letsencrypt.org/) for
securing traffic from clients to the reverse proxy (r1bifrost). Container is
based on a [customized nginx docker image](https://github.com/JonasAlfredsson/docker-nginx-certbot)
that includes support for `certbot`.

The container reads the configured subdomains from the
[sites/](./apps/r1bifrost/sites/) folder and requests/renew certificates as
required. See the [offical docs](https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/docs/good_to_know.md#how-the-script-add-domain-names-to-certificate-requests)
for additional details.

### Encryption of traffic to upstream servers

Some of the services to which traffic is proxied are hosted in a different
network than **r1bifrost**, hence, traffic travels through internet and
encryption is required.

Self signed ssl certificates are used to encrypt upstream traffic. Such ssl
certificates were created and configured following below documentation:

1. [Nginx doc: Securing http traffic upstream](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/)
2. [Microsoft doc: Generate self signed ssl certificates with custom Certificate Authority](https://learn.microsoft.com/en-us/azure/application-gateway/self-signed-certificates)

The steps for generation of self signed certificates are documented in
[hservices server docs](./../server/apps/infrastructure/README.md#generate-self-signed-certificates)

Once the `client` certificate and `CA` key had been transferred to `remote1`.
We can update the `r1bifrost` config to encrypt traffic to upstream server.

1. Set right value for `BIFROST_UPSTREAM_SSL_PATH` variable in `.env` file.
   It should point to directory containing the client certificate and CA.
2. Configure sites in [bifrost_sites/](./apps/r1bifrost/sites/*.conf) files
   to use self signed certificate to secure traffic. Use existing sites or
   [nginx docs](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/)
   as reference. Main added parts are detailed below:

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

### Realtime monitoring

Since `r1bifrost` is the one that receives all external traffic, real time
monitoring and alerting has been configured...

## Plausible
