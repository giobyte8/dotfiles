# Automated backups through borgmatic and docker

## TODOs

- [ ] Add crontab.txt to exec borgmatic automatically
- [ ] Implement backups to remote server
- [ ] Implement hooks to integrate with rterminal

This service automates backup of following home server data

- [*] Pictures
- [ ] Personal documents
- [ ] Sensible personal documents

## Backup strategy

There 2 backups of information:

1. Into a local borg repository
2. Offsite, on a remote server

Backups will run every day at 1am as configured at `./borgmatic_cfg/crontab.txt`

## Deployment

### 1. Prepare environment file

Create your own `.env` file from template and edit it to match your own
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

> You can skip this step if a borg repository alread exists in your
> 'BORG_REPO_PATH' variable at your `.env` file.
>
> Note that borgmatic skips repository creation if the repository already exists.
> This supports use cases like ensuring a repository exists prior to performing a
> backup.

From inside container run below commands

```bash
borgmatic rcreate -e repokey
```

### 4. (Optional) Run a backup manually

> It's a good idea to run the first backup manually to make sure things are
> working as expected

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

### Validate config

```bash
# Run below command from inside container
validate-borgmatic-config
```

## References

- [Docker borgmatic](https://github.com/borgmatic-collective/docker-borgmatic/tree/master/base)
- [Docker borgmatic tutorial](https://www.modem7.com/books/docker-backup/page/backup-docker-using-borgmatic)