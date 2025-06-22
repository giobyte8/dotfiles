# DRY: Use existent commands

There is a lot of functionality already integrated in native tools. Don't repeat yourself

## Files sync

`rsync` is the tool to go. Below there is a command that will send Wallpapers directory
to `192.168.1.103` machine

```bash
rsync --delete --progress -zrh \
		Wallpapers/ \
		ubuntu@192.168.1.103:/media/blackstore/Pictures/Wallpapers

# rsync files listed in a txt
#  missing.txt -> each line contains a filename relative to source path
rsync --progress -hu --files-from=missing.txt rock@192.168.1.103:./videos/cameras/GoPro/ ./
```

Some other interesting flags for `rsync`

* `--existing` Skip creating new files on receiver
* `--ignore-existing` Skip updating files that already exist on receiver
* `--remove-source-files` Sender removes synchronized files (non-dirs)
* `--delete` Delete extraneous files from destination dirs
* `--progress` Show progress during transfers
* `-z` or `--compress` Compress data during transfer
* `-h` or `--human-readable` Output numbers in a human-readable format
* `-u` Skip existing files on the destination that have a modification time newer than the
       source file.
* `--log-file=FILE` Log what we're doing to the specified FILE

And much more options: https://ss64.com/bash/rsync.html

## Cheatsheet 'rsync'

Copy with progress

```shell
rsync --progress -hru /path/to/source/ /path/to/destination

# NOTE: '/' at end of source is needed to sync contents only
```