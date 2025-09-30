
# Opens a tunneled connection to jumphost in LZ and
# maps local port to OpenSearch in AWS
function os-mdl() {
    cd ~/src/rooam/rooam-dev-tools/aws
    awsl # Function from 'aws.sh'

    bash access-opensearch.sh staging middleware
}

##
## Shortcuts to open tunneled connection to RDS Instances

function rds-tpw() {
    cd ~/src/rooam/rooam-dev-tools/aws
    awsl # Function from 'aws.sh'

    bash access-rds.sh staging middleware staging-ticket-poll-worker-db-0
}
