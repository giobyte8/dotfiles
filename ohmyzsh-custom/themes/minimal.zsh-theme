# Minimal zsh theme
#  Less is more
#
#  NOTE: A patched font with extense glyphs support is recommended
#  for usage with following prompt
#

# Cleanup current PROMPT
PROMPT=''

if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then
    H="$(hostname)"
    if [[ $H == "redbox" ]]
    then
        H=rbx
    elif [[ $H == "graybox" ]]
    then
        H=gbx
    elif [[ $H == "mbpro-gio.local" ]]
    then
        H=mb
    fi

    #PROMPT="%{$fg[magenta]%}$H ⌁ "
    PROMPT="%{$fg[magenta]%}$H "
fi

PROMPT="$PROMPT%{$fg[yellow]%}%1~ ❯ %{$reset_color%}"
# RPROMPT="%(?.%F{green}√.%F{red}?%?)%{$reset_color%}"
