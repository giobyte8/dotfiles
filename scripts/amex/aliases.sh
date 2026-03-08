#
# Setup of alias functions specific to amex env

alias ro="cd ~/src/rooam"
alias ro-other="cd ~/src/rooam/_other"
alias rde="cd ~/src/rooam/docker-env"
alias ws="cd ~/src/rooam/_other/workspace"

alias awsr="aws --profile rooam"

#
# Shortcuts to rooam projects

alias tpw="cd ~/src/rooam/rooam-ticket-poll-worker"


# Run AWS CLI against local stack
#   Endpoint URL is taken from 'localstack'
#   profile at ~/.aws/config
alias aws-local="aws --profile localstack"
alias awslocal="aws --profile localstack"
