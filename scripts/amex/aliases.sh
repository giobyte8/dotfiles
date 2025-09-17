#
# Setup of alias functions specific to amex env

alias ro="cd ~/src/rooam"
alias poc="cd ~/src/rooam/_poc"
alias rde="cd ~/src/rooam/docker-env"
alias ws="cd ~/src/rooam/_poc/workspace"

alias awsr="aws --profile rooam"

# Run AWS CLI against local stack
#   Endpoint URL is taken from 'localstack'
#   profile at ~/.aws/config
alias laws="aws --profile localstack"
