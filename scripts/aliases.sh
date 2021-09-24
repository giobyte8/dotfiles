#!/bin/bash

# Docker aliases
alias dps="docker ps --format \"table {{.Names}}\t{{.Status}}\""
alias dpsa="docker ps -a --format \"table {{.Names}}\t{{.Status}}\""
alias dpsp="docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\""
alias dpsap="docker ps -a --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\""

# AWS SAM shortcuts
alias sam-local-api="sam build && sam local start-api"

# ssh shortcuts
alias rpi="ssh rock@192.168.1.103"
alias graybox="ssh giovanni@192.168.1.102"
alias meserver="ssh rock@143.244.144.17"


## Mac exclusive aliases
## If this list grows too much, consider move it into its
## own script
if [[ $OSTYPE == 'darwin'* ]]; then
    
    # Apps shortcuts
    alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
fi
