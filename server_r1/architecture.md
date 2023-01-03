# Remote server 1

# Applications and services

Most of the services are deployed using docker containers

# TODOs

- [ ] Automate IP refresh for home server
- [ ] Add real time monitoring and alerting for reverse proxy
- [ ] Automate renewal of ssl certificates for upstream traffic

## R1 Bifrost
> *The portal to other worlds ⚡️*
>
> Location: `apps/r1bifrost`

Nginx reverse proxy that listens in host's `80` and `443` port and
redirects trafic to appropriate services. All traffic received on port `80`
is redirected to `443` port to force usage of `https`

### Traffic encryption

The reverse proxy uses [Let's encrypt](https://letsencrypt.org/) for
securing traffic from clients to the reverse proxy (r1bifrost).

The container reads the configured subdomains from the `sites/` folder
and requests/renew certificates as required. See the [offical docs](https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/docs/good_to_know.md#how-the-script-add-domain-names-to-certificate-requests)
for additional details.

### Encryption of traffic to upstream servers

Some of the services to which traffic is proxied are hosted in a different
network than **r1bifrost**, hence, traffic travels through internet and
encryption is required.

Self signed ssl certificates are used to encrypt upstream traffic. Such ssl
certificates were created and configured following below documentation:

1. [Nginx doc: Securing http traffic upstream](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/)
2. [Microsoft doc: Generate self signed ssl certificates with custom Certificate Authority](https://learn.microsoft.com/en-us/azure/application-gateway/self-signed-certificates)

Automation may be required in the future since certificates are valid for
1 year only, following are the steps for configuration of certificates:

1. Create root CA certificate
2. Create server certificate (SSL for final destination of traffic)
3. Create client certificate (SSL for reverse proxy)
4. Copy root CA certificate and client certificate and key to reverse proxy
5. Setup ssl certificate in both nginx instances (Reverse proxy and
    target server).

### Monitoring reverse proxy

Since the proxy is the one that receives all external traffic, real time
monitoring and alerting has been configured
