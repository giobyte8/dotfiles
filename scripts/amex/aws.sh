# Manages AWS SSO Login and AWS_PROFILE value
# Ref: https://rooamdotco.atlassian.net/wiki/spaces/DEV/pages/2415788033/AWS+CLI

DEBUG=0

# Setup CodeArtifact token
function awsca_token {
    TOKEN=`aws codeartifact get-authorization-token --domain rooam --domain-owner ${1} --region us-east-1 --query authorizationToken --output text --duration-seconds 43200`

    if [ $DEBUG -eq 1 ]; then
        echo
        echo "Exporting CodeArtifact token:"
        echo "$TOKEN"
    fi

    export CODEARTIFACT_AUTH_TOKEN=$TOKEN
}

function __login_with_profile {
    # Clean up env variables from previous/expired sessions
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    export AWS_PROFILE="${1}"
    echo "Doing 'aws sso login' with profile: '${AWS_PROFILE}'"

    aws sso login
    eval "$(aws configure export-credentials --format env)"
}

function aws_poweruser {
    #__login_with_profile "Rooam-PowerUser-738199573860"
    __login_with_profile "power-user"
    awsca_token 738199573860
    # export CURRENT_AWS_ROOAM_PROFILE="main_PowerUser"
}

function aws_admin {
    __login_with_profile "Rooam-Admin-738199573860"
    awsca_token 738199573860
    # export CURRENT_AWS_ROOAM_PROFILE="main_Admin"
}

function aws_dev {
    __login_with_profile "Rooam-Dev-Admin-148761657612"
    awsca_token 148761657612
    # export CURRENT_AWS_ROOAM_PROFILE="dev"
}

# AWS Login shortcut
function awsl {
    aws_poweruser
}
