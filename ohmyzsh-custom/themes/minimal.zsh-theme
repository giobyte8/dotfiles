# Minimal zsh theme
#  Less is more
#
#  NOTE: A patched font with extense glyphs support is recommended
#  for usage with following prompt

PROMPT="%{$fg[yellow]%}%1~ ❯ %{$reset_color%}"
RPROMPT="%(?.%F{green}√.%F{red}?%?)%{$reset_color%}"
