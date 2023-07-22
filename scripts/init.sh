#!/bin/bash
# Global 'multi system' configuration init

if [ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

if [ -f "$HOME/.asdf/plugins/java/set-java-home.zsh" ]; then
    . ~/.asdf/plugins/java/set-java-home.zsh
    export ASDF_GROOVY_DISABLE_JAVA_HOME_EXPORT=true
fi

if [ -f "$HOME/.asdf/plugins/golang/set-env.zsh" ]; then
    . ~/.asdf/plugins/golang/set-env.zsh
fi

# thrift@0.9 path and flags (Required in mac for skytouch setup)
if [ -d "/opt/homebrew/opt/thrift@0.9/bin" ]; then
    export PATH="/opt/homebrew/opt/thrift@0.9/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/thrift@0.9/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/thrift@0.9/include"
fi
