# Shortcuts to open tunneled connections to jumphost in LZ and
# map local ports to OpenSearch/RDS in AWS


# Access open search
function os-mdl() {
    # Default to 'staging' if no argument is provided
    local env="${1:-staging}"

    cd ~/src/rooam/rooam-dev-tools/aws
    awsl # Function from 'aws.sh'
    bash access-opensearch.sh "$env" middleware
}

# Access RDS Aurora
function rds-tpw() {
    # Default to 'staging' if no argument is provided
    local env="${1:-staging}"

    # Determine db value based on environment
    local db_name
    if [[ "$env" == "staging" ]]; then
        db_name="staging-ticket-poll-worker-db-0"
    elif [[ "$env" == "production" ]]; then
        db_name="production-ticket-poll-worker-db-0"
    else
        echo "Unknown environment: $env. Use 'staging' or 'production'."
        return 1
    fi

    cd ~/src/rooam/rooam-dev-tools/aws
    awsl # Function from 'aws.sh'

    bash access-rds.sh "$env" middleware "$db_name"
}

function rds-audit() {
    # Default to 'staging' if no argument is provided
    local env="${1:-staging}"

    # Determine db value based on environment
    local db_name
    if [[ "$env" == "staging" ]]; then
        db_name="staging-middleware-audit-db-0"
    elif [[ "$env" == "production" ]]; then
        db_name="production-middleware-audit-db-0"
    else
        echo "Unknown environment: $env. Use 'staging' or 'production'."
        return 1
    fi

    cd ~/src/rooam/rooam-dev-tools/aws
    awsl # Function from 'aws.sh'

    bash access-rds.sh "$env" middleware "$db_name"
}
