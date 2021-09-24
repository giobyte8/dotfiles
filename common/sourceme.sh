#!/bin/bash
# Basic setup compatible with ALL *unix systems


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
    PS1='\[\e[033m\]\W \[\e[034m\]❯ \[\e[m\]'
    #PS1='\[\033[48;5;178;38;5;232m\] \W \[\e[m\]'
fi
unset color_prompt force_color_prompt

## TODO Add source to aliases
## TODO Add source to custom bash functions
