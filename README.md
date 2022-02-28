# DotFiles
This repo contains scripts and config files to automate the installation
and setup of my OS X and Linux workstations. Enjoy it 😉

> So far this is a work in progress

## Structure

- `common/` Contains scripts that can be installed and used on all platforms
  (OS X & Linux)
- `config/` Configuration files for specific programs such as vimrc, iTerm
  colorschemes, etc.
- `ohmyzsh-custom` As the name suggests, this is my custom zsh configuration
- `scripts/` Those are custom built scripts for improve my productivity, most
  of those scripts are pure bash and can be used across OS X and Linux
- `server/` Scripts and setup specific for my home servers
- `Commands.md` Notes of useful comands that I've collected for common scenarios

## Common setup

Run `common/install.sh` from terminal. This script will:

- Verify that vim and git are installed
  - On `apt` based distros: If not installed then will be installed
  - On OS X if those programs are not found, and error will be log and
    installer will exit
- Put my custom vimrc in place `~/.vimrc`
- Add my custom bash init script to corresponding `.bashrc` or `.bash_profile`


Each folder contains a script to install and setup its contents,
*ensure to run it through `bash` instead of `sh`*

