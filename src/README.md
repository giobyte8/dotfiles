# Source (src)
Custom utilities and scripts for my terminals:

- aliases
- Custom functions/utilities
    - Backup functions
    - Shortcuts/Wrappers to frequently used commands
        - `gallery-dl` abbreviations
        - `rsync` shortcuts
        - `docker` cli wrapper and shortcuts

## Structure

- `core/` Provides a framework of shell functions that are used by higher level
  utilities. As an example, `curp` is a function to retrieve a script's parent
  path, it might not be useful to the final users, however, several higher level
  utilities benefit from it

## WIP
Current production code lives under `scripts/` path, the idea
is to simplify and migrate code gradually into this directory

- [ ] Migrate aliases
- [ ] Migrate core functions
