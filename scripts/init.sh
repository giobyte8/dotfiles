#!/bin/bash
# Global 'multi system' configuration init

if [[ $OSTYPE == 'darwin'* ]]; then
    export PATH="/opt/homebrew/opt/thrift@0.9/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/thrift@0.9/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/thrift@0.9/include"
fi
