# Wezterm config

## Color schemas
By default wezterm integrates a wide catalog of color schemas that can be
referenced from the config file out of the box.

See [available schemes in the docs](https://wezterm.org/colorschemes/index.html)

## Install
Wezterm looks for its configuration file in user's home. i.e. `~/.wezterm.lua`.
So we can create a symlink to the versioned config file

```shell
ln -s "${HOME}/dotf/config/wezterm/wezterm.lua" "${HOME}/.wezterm.lua"

# NOTE: Replace `${HOME}/dotf/` with appropriate path to dotf dir
```

> Make sure that fonts referenced in the `wezterm.lua` config
> are installed before installing the config

## References

- [Docs: Wezterm config](https://wezterm.org/config/files.html)
