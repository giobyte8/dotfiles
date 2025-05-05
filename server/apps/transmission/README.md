# Transmission

## Web UI

By default, transmission docker image doesn't include a WebUI anymore, adding [flood](https://github.com/johman10/flood-for-transmission) is possible with following steps.

```shell
mkdir -p config/ui
cd config/ui

curl -OL https://github.com/johman10/flood-for-transmission/releases/download/latest/flood-for-transmission.zip
unzip flood-for-transmission.zip
rm flood-for-transmission.zip
```

Once the UI code is in place, the `docker-compose.yml` file already mounts it and map into `TRANSMISSION_WEB_UI` env var.

## References

Flood for transmission docs: https://github.com/johman10/flood-for-transmission