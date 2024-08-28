# Backup tools

There are several shortcuts and automation functions to backup files provided at `scripts/backup_utils.sh`

Backup functions use `rsync` to prevent overrides and transfer of already existent data

## Backup all files

```shell
bkp /source/ user@192.168.1.1:/path/destination
```

> NOTE: The '/' at end of 'source' path is necessary to indicate that only contents of '/source/' will be transfer and not the '/source' dir itself

- Transfer all contents from *source/* dir into *destination* 
- Files already existent into *destination* won't be transfered
- Files already existent into *destination* and updated (Newer version than *source*) won't be transfered either



Usage example:

```shell
bkp pictures/ rock@192.168.1.103:/home/rock/mmedia/pictures
```

