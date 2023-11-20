# GDL

Scripts and config for [gallery-dl](https://github.com/mikf/gallery-dl).

## Usage
Run using provided wrapper script, which will load config from `gdl.config.json`

```shell
./gdl [url]
```

## Config file
Create your custom config for downloads

```shell
cp gallery-dl.conf.template.json gallery-dl.conf.json
vim gallery-dl.conf.json
```

### Cookies setup
Some private content requires authentication by using cookies. Follow below
steps to setup

1. Use a tool like [this chrome extension](https://chrome.google.com/webstore/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc)
   to retrieve cookies
2. Place cookies values into corresponding json field for each extractor into
   `gallery-dl.conf.json` in `gdl/` project root.

> Reference for `gallery-dl` cookies setup: https://github.com/mikf/gallery-dl#cookies
