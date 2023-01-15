# Automated backups through borgmatic and docker

## TODOs

- [x] Add crontab.txt to exec borgmatic automatically
- [ ] Implement backups to remote server
- [ ] Implement hooks to integrate with rterminal

This service automates backup of following home server data

- [x] Camera pictures
- [ ] Camera videos
- [ ] Edited pictures
- [ ] Edited videos
- [ ] Private sensible galleries (Backup encrypted zip, not pictures)
- [ ] Personal documents

## Backup strategy

There 2 backups of information:

1. Into a local borg repository
2. Offsite, on a remote server

Backups will run every Monday at 1am as configured at `./borgmatic_cfg/crontab.txt`

## Deployment

### 1. Prepare environment file

Create `.env` file from template and edit it to match your own
requirements

```bash
cp env.template .env
vim .env
```
> Make sure to enter a secure passphrase in your config

### 2. Start borgmatic service

```bash
docker compose up -d borgmatic
```

### 3. Initialize repository

> You can skip this step if a borg repository already exists in your
> 'BORG_REPO_PATH' variable in your `.env` file.
>
> Note that borgmatic skips repository creation if the repository already exists.
> This supports use cases like ensuring a repository exists prior to performing a
> backup.

From inside container run below commands

```bash
borgmatic rcreate -e repokey
```

### 4. (Optional) Setup backups to remote location

> This is needed only if you're implementing backups into a remote
> server. Like in the config at `location.repositories.ssh...` in
> `pictures.yml` file

1. Make sure the right user and IP address are configured in the repositories
   list of your backup config (`.yml` file).
2. Setup right values for `$SSH_KEYS_PATH` in your `.env` file. This can be the
   path to your `$HOME/.ssh` or you can create a `ssh_keys/` directory in this
   project root and create new keys there. Check
   [this article from Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-22-04) for further reference.
3. Make sure repository is initialized in remote server. This repository should
   be the same as specified in the `location.repositories.ssh...` config of your
   backups. You can init repo with `borg init -encryption=repokey ./path/to/repo`

### 5. (Optional) Run a backup manually

> It's a good idea to run the first backup manually to make sure things are
> working as expected.
>
> Also, if you configured new ssh keys for a remote repository, this may be
> necessary in order to add remote server to list of known hosts during first
> backup

From inside container run

```bash
borgmatic create -v 1 --list --stats

# List created archive
borg list /mnt/host-local-borg-repository


# Restore files

# 1. Go to restoration path
cd /mnt/restored
borg extract /mnt/host-local-borg-repository::<ARCH_NAME>
```

## Run borg commands manually

Start the borgmatic service and then run a shell inside container
```bash
docker compose up -d borgmatic
docker exec -it borgmatic /bin/bash

# Now you can run either 'borgmatic' or 'borg' commands
# > Remember the default local repository is at:
# > /mnt/host-local-borg-repository
```

## Setup customization

### Customize automated backup time

Cron will be configured based on file at `borgmatic_cfg/crontab.txt`,
update this file and then recreate container so that new config is
applied

### Validate config

```bash
# Run below command from inside container
validate-borgmatic-config
```

## References

- [Docker borgmatic](https://github.com/borgmatic-collective/docker-borgmatic/tree/master/base)
- [Docker borgmatic tutorial](https://www.modem7.com/books/docker-backup/page/backup-docker-using-borgmatic)