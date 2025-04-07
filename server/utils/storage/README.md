# Keep storage mounted

The HDD bay I'm using seems to spin down the drives automatically
after some minutes, which causes disks get unmounted and unavailable
when background services try to access it.

The workaround used here is to do some reading work periodically
on mounted drives so that they seem active to the bay and it doesn't
spin them down.

The script does an `ls` on each mountpoint only if it is identified
as a mount point for HDD. It gets executed periodically via systemd
timer.

## Install and enable

Symlink systemd files to corresponding directory

```bash
sudo ln -s /home/rock/dotf/server/utils/storage/keep-storage-mounted.service /etc/systemd/system/keep-storage-mounted.service
sudo ln -s /home/rock/dotf/server/utils/storage/keep-storage-mounted.timer /etc/systemd/system/keep-storage-mounted.timer
```

Then, enable them on systemd

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now keep-storage-mounted.timer
```

