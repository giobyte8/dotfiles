#!/bin/bash
# Global 'multi system' configuration init

# Activate mise package/env manager
if [ -f "$HOME/.local/bin/mise" ]; then
# if type mise > /dev/null; then
    # echo "mise found, activating..."
    eval "$(~/.local/bin/mise activate zsh)"
fi

# Some envs use asdf instead of mise
# if [ -f "$HOME/.asdf/plugins/java/set-java-home.zsh" ]; then
#     # echo "Setting JAVA_HOME"
#     . ~/.asdf/plugins/java/set-java-home.zsh
# fi

# # thrift@0.9 path and flags (Required in mac for skytouch setup)
if [ -d "/opt/homebrew/opt/thrift@0.9/bin" ]; then
    export PATH="/opt/homebrew/opt/thrift@0.9/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/thrift@0.9/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/thrift@0.9/include"
fi
