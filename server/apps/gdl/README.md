# GDL

Scripts and config for personal usage of [gallery-dl](https://github.com/mikf/gallery-dl)
to download content from internet

## Usage
Run using provided script, which will load config from `gdl.config.json`

```shell
./gdl [url]
```

## Cookies setup
Some private content requires authentication, place sites cookies in a txt file so
that `gallery-dl` can use it to authenticate against the site.

1. Use a tool like [this chrome extension](https://chrome.google.com/webstore/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc)
   to retrieve cookies
2. Place cookies into `cookies.txt` in `gdl/` project root
    - Use '#' as line starters to include comments
    - Use comments and line breaks to separate cookies for different sites

> Reference for `gallery-dl` cookies setup: https://github.com/mikf/gallery-dl#cookies
