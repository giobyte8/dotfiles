#!/bin/bash

# Docker aliases
alias dps="docker ps --format \"table {{.Names}}\t{{.Status}}\""
alias dpsa="docker ps -a --format \"table {{.Names}}\t{{.Status}}\""
alias dpsp="docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\""
alias dpsap="docker ps -a --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\""
alias dc="docker compose"
alias dcs="docker compose config --services"

# AWS SAM shortcuts
alias sam-local-api="sam build && sam local start-api"

# ssh shortcuts
alias rpi="ssh rock@192.168.1.103"
alias graybox="ssh giovanni@192.168.1.102"
alias meserver="ssh rock@143.244.144.17"
