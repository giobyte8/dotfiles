# Infrastructure

The backbone of the server is composed by several databases, message
brokers, proxies and other services that are consumed by deployed
applications.

- [Networking overview](#networking-overview)
  - [Services accessible from internal network](#services-accessible-from-internal-network)
  - [Services accessible from the outside](#services-accessible-from-the-outside)
- [Infrastructure services](#infrastructure-services)
  - [Bifrost (Reverse proxy)](#bifrost)
  - MariaDB
  - RabbitMQ
  - Redis

## Networking overview

All production services and apps running in docker are attached to a
docker bridge network called `hservices`.

Some IPs in such network are reserved to be manually assigned and some
others are managed by DHCP

**Home services network:**

* Subnet: `172.20.1.0/24`
* IPs for dynamic assignment: `172.20.1.0/25 (172.20.1.1-126)`
* IPs reserved to be manually assigned: `172.20.1.127-254`

### Services accessible from internal network

| Running on | Service | Exposed port | Mapped to host port |
|------------|---------|--------------|---------------------|
| Docker     | MariaDB | 3306         | 3306                |

### Services accessible from the outside

For security reasons, only a few ports are allowed in the router and mapped
to the server.

| External port | Mapped to host:port | Mapped to docker:port |
|---------------|---------------------|-----------------------|
| :2000         | 192.168.1.103:2000  | bifrost:443           |
| :443          | 192.168.1.103:443   | bifrost:443           |

#### Public apps links

| Application  | Link                                    |
|--------------|-----------------------------------------|
| Photoprism   | https://photos.giovanniaguirre.me       |
| Transmission | https://transmission.giovanniaguirre.me |

## Infrastructure services

### Bifrost

> The portal to other worlds ⚡️

The bifrost is a nginx reverse proxy. It acts as the entrance gateway
for services exposed to the external world. It listens on port 443 and
reverse proxies requests to corresponding services.

Since home server does not have a static public IP address, there is
another server `remote1` that has a static IP address assigned. All DNS
records for apps subdomains point to `remote1` and are then proxied by it
to home server.

```txt

|---------------|  DNS Records  |-----------|  Proxied request  |-----------|
|   INTERNET    |-------------->|  remote1  |------------------>| hservices |
|---------------|               |-----------|                   |-----------|

```

#### Traffic encryption

The traffic from end users to `remote1` server is secured by ssl certificates
issued by [Let's encrypt](https://letsencrypt.org). `remote1` has a reverse
proxy deployed with support for automatic renewal of ssl certificates.

The traffic from `remote1` to `hservices` is a litte bit more complex than that.
Nginx allows to secure http traffic from reverse proxy (remote1) to upstream servers
(hservices) using self signed certificates with a custom Certificate Authority.

The proccess is explained in [nginx official docs](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/).

The implementation details for `remote1` to `hservices` encryption are detailed here:

##### Generate self signed certificates

> I based the process in a tutorial published by Microsoft in their [azure docs](https://learn.microsoft.com/en-us/azure/application-gateway/self-signed-certificates)

> Automation may be required in the future since self signed certificates
> are valid for 1 year only

> Since certificates are senssible information, those are created inside
> `~/workspace/appdata/bifrost/upstream_ssl_certs/` directory in `hservices`
> server.

There are three required elements to get certificates ready

1. Root Certification Authority (CA)
2. Server certificate for final destination of traffic (`hservices`)
3. Client certificate for reverse proxy (`remote1`).

###### 1. Create root Certification Authority (CA) certificate

```bash
# Go to private directory in `hservices`
cd ~/workspace/appdata/bifrost/upstream_ssl_certs

# Create encrypted key for ca
openssl ecparam -out ca.key -name prime256v1 -genkey

# Create root certificate and self-sign it.
# > '.csr' -> Certificate Signing Request
#
# When prompted, type the password for the root key, and the organizational
# information for the custom CA such as Country/Region, State, Org, OU, and
# the fully qualified domain name (this is the domain of the issuer).
openssl req -new -sha256 -key ca.key -out ca.csr

# Use the .csr to create certificate
openssl x509 -req -sha256 -days 365 -in ca.csr -signkey ca.key -out ca.crt
```

###### 2. Create server certificate

```bash

# Create encrypted key for server certificate
openssl ecparam -out server.key -name prime256v1 -genkey

# Create CSR (Certificate Signing Request)
# > The CN (Common Name) for the server certificate must be different from
# > the issuer's domain.
openssl req -new -sha256 -key server.key -out server.csr

# Generate certificate with .csr and .key and sign it with CA's root key
openssl x509 -req                            \
  -in server.csr                             \
  -CA  ca.crt -CAkey ca.key -CAcreateserial  \
  -out server.crt                            \
  -days 365 -sha256

# (Optional) You can verify the certificate's content
openssl x509 -in server.crt -text -noout
```

###### 3. Create client certificate

```bash

# Create encrypted key for client certificate
openssl ecparam -out client.key -name prime256v1 -genkey

# Create CSR (Certificate Signing Request)
# > The CN (Common Name) for the client certificate must be different from
# > the issuer's domain.
openssl req -new -sha256 -key client.key -out client.csr

# Generate certificate with .csr and .key and sign it with CA's root key
openssl x509 -req                            \
  -in client.csr                             \
  -CA  ca.crt -CAkey ca.key -CAcreateserial  \
  -out client.crt                            \
  -days 365 -sha256

# (Optional) You can verify the certificate's content
openssl x509 -in client.crt -text -noout
```

There should be 9 files at the end:

1. `ca.crt`, `ca.csr`, `ca.key`
2. `server.crt`, `server.csr`, `server.key`
3. `client.crt`, `client.csr`, `client.key`

##### Configure ssl certificates in hservices

1. Set right value for `BIFROST_UPSTREAM_SSL_PATH` variable in `.env` file.
   It should point to directory containing the server certificate and CA.
2. Configure sites in [bifrost_sites/](./bifrost_sites/*.conf) files to use
   self signed certificate to secure traffic. Use existing sites or
   [nginx docs](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/)
   as reference. Main added parts are detailed below:

```conf

server {
    # ...

    # Self signed certificates for nginx upstream traffic encryption;
    ssl_certificate        /mnt/upstream_ssl_certs/photos_server.crt;
    ssl_certificate_key    /mnt/upstream_ssl_certs/photos_server.key;
    ssl_client_certificate /mnt/upstream_ssl_certs/ca.crt;
    ssl_verify_client      optional;

    location / {
        # ...
    }
}
```

##### Configure ssl certificates in remote1

You'll need to upload the client certificate and CA to `remote1`. `scp` is a
good tool for the job. You can use a command like below:

```bash
scp ca.crt client.crt client.key \
  <user>@<remote1_ip>:./workspace/appdata/r1bifrost/upstream_ssl_certs/
```

Then, follow ssl config instructions for `remote1` at
[r1bifrost docs](../../../server_r1/apps/r1bifrost/REDME.md)
