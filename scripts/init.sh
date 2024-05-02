#!/bin/bash
# Global 'multi system' configuration init

# Activate mise package/env manager
eval "$(mise activate zsh)"

# # thrift@0.9 path and flags (Required in mac for skytouch setup)
if [ -d "/opt/homebrew/opt/thrift@0.9/bin" ]; then
    export PATH="/opt/homebrew/opt/thrift@0.9/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/thrift@0.9/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/thrift@0.9/include"
fi
