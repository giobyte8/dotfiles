# Minimal zsh theme
#  Less is more
#
#  NOTE: A patched font with extense glyphs support is recommended
#  for usage with following prompt



if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then
    H=$HOSTNAME
    if [[ $H -eq "redbox" ]]
    then
        H=rbx
    elif [[ $H -eq "graybox" ]]
    then
        H=graybox
    fi

    PROMPT="%{$fg[magenta]%}$H ⌁ "
fi

PROMPT="$PROMPT%{$fg[yellow]%}%1~ ❯ $T %{$reset_color%}"
RPROMPT="%(?.%F{green}√.%F{red}?%?)%{$reset_color%}"
