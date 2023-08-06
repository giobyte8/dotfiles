# Borgmatic backups
In order to verify the backup infrastructure works as expected, you can
create a small dev environment to deploy the backup services and verify
that:

1. Backups are saved to local repository
2. Backups are saved to remote repository (through ssh)
3. MariaDB databases are backed up
4. PostgreSQL databases are backed up
5. Hooks are invoked and notifications posted to AMQP broker
6. Files can be restored from backup

# Env deployment

## Prepare test files
Get some dummy files so you can test backup and restore functionality
with true files but without risking your own personal files.

From `borgmatic/` dir, run below commands:
```shell
mkdir -p devdata/f_sources/memories
mkdir -p devdata/f_sources/pictures

# TODO Include gallery-dl command to fetch some images into dirs
```

## Start RabbitMQ broker for hooks notifications
Start AMQP broker from [infrastructure](../infrastructure/README.md) so
that you can verify hooks post notifications to the queue

## Prepare runtime dirs for borgmatic
```shell
mkdir -p devdata/borglh/borg.cache
mkdir -p devdata/borglh/repos

mkdir -p devdata/f_restored
```
> Make sure to enter above dirs during next steps when configuring
> docker compose `.env` file

## Prepare "remote" storage server
In order to verify that remote repository config works, an additional container
`borgrh` with borg on it is provided. Use such container as a remote host
so that backups are created through ssh repository.

### Setup ssh keys
Follow steps at
['SSH Keys for remote repositories'](README.md#ssh-keys-for-remote-repositories)
deployment section and then come back here.

Copy public key into `authorized_keys` file that is provided to `borgrh`
container
```shell
mkdir -p devdata/borgrh/ssh
cat config/ssh/id_rsa.pub >> devdata/borgrh/ssh/authorized_keys
```

**Create ssh key pair to verify remote host identity**
Create remote host public and private keys and add public key
to *borgmatic* `known_hosts` file. So that authenticity of *borgrh*
can be verified without warnings during ssh connection

```shell
mkdir -p devdata/borgrh/ssh_hostkeys

# Leave empty when prompted for passphrase
ssh-keygen                      \
    -t ed25519                  \
    -C ""                       \
    -f devdata/borgrh/ssh_hostkeys/ssh_host_ed25519_key

# Add public key to 'known_hosts' file
echo "borgrh $(cat devdata/borgrh/ssh_hostkeys/ssh_host_ed25519_key.pub)" >> \
    config/ssh/known_hosts
```

### Start "remote" storage container
```shell
# Prepare directories for container volumes
mkdir -p devdata/borgrh/repos
mkdir -p devdata/borgrh/borg.cfg
mkdir -p devdata/borgrh/borg.cache

# Start remote host container
docker compose up -d borgrh
```

## Prepare dummy database servers
TODO: Create database containers to test DBs backups

## Happy coding
Now follow rest of steps from main [deployment guide](README.md#prepare-borgmatic-config-files)
and you'll be good to go.

Once deployment is complete, you can manually run backups or create
additional backup configurations for files or databases.

Happy coding! 🚀
