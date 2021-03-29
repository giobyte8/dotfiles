# DRY: Use existent commands

There is a lot of functionality already integrated in native tools. Don't repeat yourself

## Files sync

`rsync` is the tool to go. Below is a command that will send Wallpapers directory to `192.168.1.103` machine 

```bash
rsync --delete --progress -zrh \
		Wallpapers/ \
		ubuntu@192.168.1.103:/media/blackstore/Pictures/Wallpapers
```



Some other interesting flags for `rsync`

* `--existing` Skip creating new files on receiver
* `--ignore-existing` Skip updating files that already exist on receiver
* `--remove-source-files` Sender removes synchronized files (non-dirs)
* `--delete` Delete extraneous files from destination dirs
* `--progress` Show progress during transfers
* `-z` or `--compress` Compress data during transfer
* `-h` or `--human-readable` Output numbers in a human-readable format
* `--log-file=FILE` Log what we're doing to the specified FILE

And much more options: https://ss64.com/bash/rsync.html

