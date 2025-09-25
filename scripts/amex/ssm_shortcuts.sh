
# Opens a tunneled connection to jumphost in LZ and
# maps local port to OpenSearch in AWS
function opensearch-mdl() {
    cd ~/src/rooam/rooam-dev-tools/aws
    awsl # Function from 'aws.sh'

    bash access-opensearch.sh staging middleware
}