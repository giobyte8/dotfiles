# Home Server Architecture

External drives, application containers and custom scripts are all connected
and structured in a particular way to facilitate maintenance and setup
workflows

1. [Storage](#storage)
    1. [Main drive](#main-drive)
    2. [External drives](#external-drives)
    4. [Backups structure and automation](#backups-structure-and-automation)
2. [Deployed apps and services](#applications-and-services)
    1. [Common services](#common-services)
    2. [Deployed apps](#deployed-apps)
    3. [Networking overview](#networking-overview)
        1. [Access from internal network](#access-from-internal-network)
        2. [Access from outside](#access-from-outside)
            1. [Bifrost](#bifrost)
            2. [Public apps links](#public-apps-links)
    4. [Automated startup process](#automated-startup-process)
3. Monitoring tools
    1. Btop and docker aliases
    1. Notifications with RabbitMQ and RTerminal
    1. Bifrost monitoring
4. Security
    1. Firewall setup
    2. Installed apps password management
    3. Access from outside monitoring and alerting

# TODOs

- [ ] Document backup automation
- [ ] Complete documentation of internal and external networking
- [ ] Implement automated startup process

# Storage

Server uses an SSD as its main drive for boot and frequent access data,
also, there are several external SSDs/HDDs connected for extended storage

## Main drive

- Type: SSD
- Capacity: 1TB
- Filesystem: BTRFS

Contains the system installation, system setup files, apps, apps data and
personal frequently accessed data

### Home directory

> `/home/rock`

By security reasons most of the operations are executed by a non root user
called `rock`. Rock's home is the **only** directory in this drive that
contains personal data

```bash
|- /home/rock
|
|     # Where my dotfiles repo is cloned. https://github.com/giobyte8/DotFiles
|- -- DotFiles/
|
|     # External applications: Contains source code and settings for apps that
|     # have not yet make it to the DotFiles/server/apps directory.
|     # * Usually experimental or in early development phase apps
|- -- eapps/
|
|     # Where all the photos and pictures are stored
|- -- pictures/
|
|        # Personal photos classified by the camera which they come from
|        # there is an 'Others' directory for photos with unknown camera or
|        # not taken by me
|- -- -- Cameras/
|
|        # Edited photos/videos or in progress edition projects
|- -- -- Edits/
|
|        # All of my photos from before I started to classify (2019)
|- -- -- Memories/
|
|        # Hand picked amazing wallpapers
|- -- -- Wallpapers/
|
|        # Collections downloaded and classified by my 'galleries' instance
|        # https://github.com/giobyte8/galleries
|- -- -- galleries/
|
|        # Private galleries: Mostly hand picked sensible pictures
|- -- -- pgalleries/
|
|
|     # Runtime or wip data from running apps and services
|- -- workspace/
|
|        # Runtime data (logs, databases, files) from apps and services
|- -- -- appdata/
|
|        # Downloaded and pending of review/classification files
|- -- -- downloads/
```

In addition to above directories, a few symbolic links are created for saving
time during administrative operations

```bash
|- /home/rock
|
|- -- apps       -> DotFiles/server/apps
|- -- blackstore -> /media/blackstore
|- -- vstore     -> /media/vstore
```

### Media directory

> `/media`

Here is where all external drives (SSDs, HDDs, SD Cards) are mounted

```bash
|- /media
|
|- -- blackstore/
|- -- vstore/
|
|     # (Galaxy S20+) MTP Device is manually mounted here
|- -- s20/
|
|- -- # RPI SDCard is manually mounted here
|- -- sdcard/
```

## External drives

### Blackstore

- Type: External HDD (WD Elements)
- Capacity: 1TB
- Filesystem: NTFS
- Automounted: Yes

```bash
|- blackstore/
|
|- -- Movies/
|- -- Music/
|- -- TVShows/
|
|     # Concerts and songs videos
|- -- MusicVideos/
|
|- -- # Hand picked videos that cannot be could not be classified
|     # in other directory
|- -- RandomVideos/
```

### VStore

- Type: HDD (From Sony VAIO Laptop)
- Capacity: 750GB
- Filesystem: BTRFS
- Automounted: Yes

```bash
|- vstore/
|- -- Documents/
|
|     # Backups from third parties people/companies
|- -- ExternalBackups/
|
|     # Installers, ROMs, ISOs, Executables
|- -- Games/
|
|     # Operating systems ISOs
|- -- ISOs/
|
|     # Software installers
|- -- Installers/
|
|     # I wasn't using git when I was learning programming
|     # at school, here is the code from back then
|- -- Sources/
|
|     # Exported and reusable virtual machines
|- -- VMs/
|
|     # Borg backups repository (See: #backups-structure-and-automation)
|- -- backups/
```

## Backups structure and automation

Important data is backed up using [Borg](https://www.borgbackup.org/), there
are two borg repositories, which means two backups of the information:

1. Local backup at: `/media/vstore/backups`
2. Offsite backup at remote server

Following directories are included in backups

```bash
- /home/rock/pictures

- /home/rock/workspace/runtime_backups
- /media/vstore/Sources
```

Backups are done automatically by [borgmatic]() and are configured under
`/home/rock/DotFiles/server/apps/borgmatic`

# Applications and services

Most of the services are deployed using docker containers

## Common services

The backbone of the infrastructure is composed of several services that
are used by multiple deployed applications. Such services are:

- MariaDB
- RabbitMQ
- Redis

## Deployed apps

- Plex
- Transmission
- Photoprism
- [Galleries](github.com/giobyte8/galleries)

## Networking overview

All production services and apps running in docker are attached to a
docker bridge network called `hservices`.

Some IPs in such network are reserved to be manually assigned and some
others are destinated to be managed by DHCP

**Home services network**

* Subnet: `172.20.1.0/24`
* IPs for dynamic assignment: `172.20.1.0/25 (172.20.1.1-126)`
* IPs reserved to be manually assigned: `172.20.1.127-254`

### Access from internal network

| Running on | Service | Exposed port | Mapped to host port |
|------------|---------|--------------|---------------------|
| Docker     | MariaDB | 3306         | 3306                |

### Access from outside

For security reasons, only a few ports are allowed in the router and mapped
to the server

| External port | Mapped to host port | Mapped to service |
|---------------|---------------------|-------------------|
| 2000          | 2000                | bifrost:443       |

#### Bifrost

> The portal to other worlds ⚡️

The bifrost acts as the entrance gateway for services exposed to the external
world. It listens on port 443 and reverse proxies requests to appropriate
services

#### Public apps links

| Application  | Link                                    |
|--------------|-----------------------------------------|
| Photoprism   | https://photos.giovanniaguirre.me       |
| Transmission | https://transmission.giovanniaguirre.me |

## Automated startup process
