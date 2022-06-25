#!/bin/bash
# Basic setup compatible with ALL *unix systems
# NOTE: Use this initialization scripts for bash only


SOURCE="${BASH_SOURCE[0]}"

# resolve $SOURCE until the file is no longer a symlink 
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"

  # if $SOURCE was a relative symlink, we need to resolve it relative
  # to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
HERE="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

DOTF_ROOT="${HERE}/.."
SCRIPTS_ROOT="${DOTF_ROOT}/scripts"

##
## PS1 Variable setup (bash prompt)
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
	    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # Color reference: https://unix.stackexchange.com/a/124409/331321

    if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then
        H=$HOSTNAME
        if [ $H = "redbox" ]; then
            H=rbx
        fi

        # Without bg colors
        PS1='\[\033[38;5;183m\]$H ⌁ \[\033[38;5;221m\]\W ❯ \[\e[m\]'

        # With nice bg colors
        #PS1='\[\033[48;5;240;38;5;253m\] ⎌ $H \[\e[m\] \W ❯ \[\e[m\]'
    else
        PS1='\[\e[033m\]\W ❯ \[\e[m\]'
    fi
fi
unset color_prompt force_color_prompt

## Custom variables
export SYSTEMD_EDITOR=vim
export BAT_THEME=Dracula

##
## Load custom scripts and functions
source "${SCRIPTS_ROOT}/aliases.sh"

if [[ $OSTYPE == 'darwin'* ]]; then
    source "${SCRIPTS_ROOT}/mac_utils.sh"

    source "${SCRIPTS_ROOT}/skt/hook.sh"
    source "${SCRIPTS_ROOT}/skt/woai.sh"
fi
