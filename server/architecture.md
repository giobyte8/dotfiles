# Home Server Architecture

External drives, application containers and custom scripts are all connected
and structured in a particular way to facilitate maintenance and setup
workflows

1. [Storage](#storage)
    1. [Main drive](#main-drive)
    2. [External drives](#external-drives)
    4. [Backups automation and structure](#backups-automation-and-structure)
2. [Apps and services](#applications-and-services)
    1. [Common services](#common-services)
    4. [Automated startup process](#automated-startup-process)
3. Monitoring tools
    1. Btop and docker aliases
    1. Notifications with RabbitMQ and RTerminal
    1. Bifrost monitoring
4. [Security](#security)
    1. [SSH Login](#ssh-login)
    2. Firewall setup
    2. Installed apps password management
    3. Access from outside monitoring and alerting

# TODOs

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
|
|     # Multimedia content:
|     # - Pictures, Photos, Videos, etc.
|- -- mmedia/
|
|        # Content classified by the camera which was taken by. There is
|        # an 'Others' directory for photos with unknown camera.
|- -- -- cameras/
|
|        # Edited photos/videos or in progress edition projects
|- -- -- edits/
|
|           # Transcoded versions of videos. All of those are optimized for
|           # web access. Since those are transcoded version from the originals
|           # no backup of this directory is needed
|- -- -- -- vtranscoded/
|
|        # Collections downloaded and classified by my 'galleries' instance
|        # https://github.com/giobyte8/galleries
|- -- -- galleries/
|
|        # Photos collection until before I started to classify (2019)
|- -- -- memories/
|
|        # Private galleries:
|        # - Hand picked sensible pictures
|- -- -- pgalleries/
|
|        # Hand picked amazing wallpapers
|- -- -- wallpapers/
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
|- -- # SDCards are manually mounted here when needed
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

## Backups automation and structure

Important data is backed up automatically following the 3-2-1 policy.
All implementation details are documented in its
[own section](apps/borgmatic/README.md)

# Applications and services

Most of the services are deployed using docker containers.
- Each app is configured in its own directory in [apps/](apps/)
- Most of the apps include a `docker-compose.yml` and an `.env` files.
- When is necessary, apps include its own `README.md` with docs about
  its implementation

Navigate to each app's directory inside [apps/](apps/) to review it's
implementation and deployment details.

## Common services

The backbone of the server [infrastructure](apps/infrastructure/) is
composed of several services such as databases, queues, proxies, etc.
that are then used by deployed applications.

Network configuration and overview of such services is documented
in [apps/infrastructure](apps/infrastructure/README.md)

## Automated startup process

# Security

## SSH Login

SSH is configured following my [custom guide](https://giovanniaguirre.me/blog/secure_ssh_setup/) which:

- Disables root login
- Disables password login from external networks
- Setup client machines to use ssh keys to login
