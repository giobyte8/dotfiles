# Automated backups through borgmatic and docker
This service automates backup of server data using [borg](https://borgbackup.readthedocs.io) and [borgmatic](https://torsion.org/borgmatic/).

Backups include following data:
- [x] Cameras pictures and videos
- [ ] Edited pictures
- [ ] Edited videos
- [ ] Private sensible galleries (Encrypted zip, not uncompressed files)
- [ ] Legacy source code (SRC The Journey)
- [ ] Personal documents

---

1. [Backup strategy](#backup-strategy)
2. [Deployment](#deployment)
   1. [SSH Keys for remote repositories](#ssh-keys-for-remote-repositories)
   1. [Prepare borgmatic config files](#prepare-borgmatic-config-files)
   1. [Prepare environment file](#prepare-environment-file)
   1. [Start borgmatic service](#start-borgmatic-service)
   1. [Initialize repositories](#initialize-repositories-first-time-only)
   1. [Export and store keyfile and passphrase](#backup-keyfile-and-passphrase-first-time-only)
   1. [Create a backup manually](#create-a-backup-manually)
3. [Restore files](#restore-files-from-backups)
4. [Verify backups automatically](#verify-backups-automatically)
5. [Development](#development)
6. [References](#references)

# Backup strategy
There are 2 backups of information:

1. Onsite: Into a local borg repository
2. Offsite: To a remote storage server

Backups are created periodically based on deployment config

# Deployment

## SSH Keys for remote repositories
> This step is only required if you intent to do backups to remote
> repositories through ssh

Borg supports creating backups into remote repositories accessed via ssh.
Make sure that remote host has `borg` installed to improve the performance
of backup operations.

SSH is used to encrypt traffic across network. In order to enable automatic
login without human intervention you'll need to setup ssh keys and place
it into hosts.

Process can be summarized in following steps:
1. Create ssh key pair (public and private keys)
2. Put private key into borgmatic host `~/.ssh/` directory
3. Put public key into remote host `~/.ssh/authorized_keys` file
   - Some backup hosting services such as [borgbase](https://borgbase.com)
     allow this operation through its web UI

**Create ssh key pair to authenticate into remote host**
```shell
mkdir -p config/ssh
ssh-keygen  \
    -m PEM  \
    -t rsa  \
    -b 4096 \
    -C "borgmatic" \
    -f config/ssh/id_rsa
# Leave empty when prompted for a passphrase
```

If you have complete control of remote host, add public key to
`~/.ssh/authorized_keys` file in remote host.

If you're using a service provider such as [borgbase](https://borgbase.com)
use their web UI to add ssh public key to service.

## Prepare borgmatic config files
Create borgmatic config files based on provided templates

```shell
cp config/borgmatic.cfg.templates/mmedia.yml  config/borgmatic.cfg/mmedia.yml
cp config/borgmatic.cfg.templates/crontab.txt config/borgmatic.cfg/crontab.txt

# Edit each file and double check locations for source files and repositories
vim config/borgmatic.cfg/mmedia.yml
vim config/borgmatic.cfg/crontab.txt
```

## Prepare environment file
Create docker compose `.env` file from template and edit it to match your own
requirements

```bash
cp template.env .env
vim .env

# Enter values for:
#   - Borg passphrase (For backups encryption)
#   - RabbitMQ or Redis broker (Used for notifications)
# > Verify the rest of variables have right values
```

## Start borgmatic service

```shell
docker compose up -d borgmatic
```

## Initialize repositories (First time only)
> This step is required only once. You can skip this step if a borg repository
> already exists at 'BORG_LOCAL_REPO_PATH' from `.env` file and in remote
> hosts.
>
> This operation is **idempotent**: Its secure to run it even if a repository
> already exists in target destinations.
>
> Borgmatic skips repository creation in such cases. This supports use cases like
> ensuring a repository exists prior to performing backup.

Go inside borgmatic container and create repositories. Borgmatic will iterate
over config files to collect all target repositories to be created.
```shell
docker compose exec borgmatic bash
borgmatic rcreate -e repokey

# Alternatively you could use borg directly (Idempotent):
borg init -e repokey ssh://root@borgrh/mnt/repo.borg
```

## Backup keyfile and passphrase (First time only)
When a repository is initialized, borg shows a warning that you'll need the
repokey and passphrase to access repo in case of disaster

```
You will need both KEY AND PASSPHRASE to access this repo!
If you used a repokey mode, the key is stored in the repo, but you should
back it up separately.

Use "borg key export" to export the key, optionally in printable format.
Write down the passphrase. Store both at safe place(s).
```

So, let's export key and passphrase into external files so that we can store it
in alternate secure places.

1. Prepare dir in mounted `restore` volume to store keys and passphrase
   ```shell
   dc exec borgmatic bash
   mkdir -p /mnt/restored/borgkeys
   cd /mnt/restored/borgkeys
   ```
2. Write down passphrase into txt file
   ```shell
   echo "${BORG_PASSPHRASE}" > bpassphrase.txt
   # Alternatively you could get passphrase from your .env compose file
   ```
3. Export keys for each repository. **Make sure to do this process once
   for each encrypted repository**

   > Tip: You can get repo paths from `repositories` section in your
   > borgmatic config (yaml) files

   ```shell
   borg key export /mnt/repos/lrepo.borg > lrepo-key-bkp
   # Repeat for each repository
   
   # OPTIONAL: Export keys in printable format and html with QR code
   borg key export --paper   /mnt/repos/lrepo.borg > lrepo-key-bkp.txt
   borg key export --qr-html /mnt/repos/lrepo.borg > lrepo-key-bkp.html
   ```
4. Store generated files in a secure location.
   > Anyone with access to these files will be able to access and
   > manipulate backups in corresponding repositories.
5. Once files have been stored in a safe place, delete them from local
   file system
   ```bash
   cd / && rm -r /mnt/restored/borgkeys
   ```

## Create a backup manually
Backups will run periodically based on config at
`config/borgmatic.cfg/crontab.txt` file, however, it's a good idea to run the
first backup manually to make sure things works as expected.

Also, if you just added a remote repository to your config, this step may be
useful in order to add remote server to list of known hosts and allow automatic
authentication in later backups.

```shell
docker compose exec borgmatic bash

# Validate config before first backup
borgmatic config validate

# Create backup
borgmatic create -v 1 --list --stats

# List created archive
borg list /mnt/lrepo.borg

# > You can run any borgmatic or borg command from this container
```

# Restore files from backups
Use the `borgmatic` container to restore files from borg archives

```shell
docker compose exec borgmatic bash

cd /mnt/restored
borg extract /mnt/lrepo.borg::<ARCH_NAME>
```

# Verify backups automatically
> TODO: Create a cron job that extract random files from archives and compare
> them against original files to verify its integrity (Research about it, does
> borgmatic already provides the option?).

# Development
For testing of new features or hooks functionality, create a development environment
so that you don't mess up with real files.

See: [development guide](DEVELOPMENT.md)

# References

- [Docker borgmatic](https://github.com/borgmatic-collective/docker-borgmatic/tree/master/base)
- [Docker borgmatic tutorial](https://www.modem7.com/books/docker-backup/page/backup-docker-using-borgmatic)