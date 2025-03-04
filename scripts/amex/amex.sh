env_file=""$(dirname "$0")"/.env"

function proxy-set {
    # TODO: Use -s argument to show/no show logging

    # Load sensitive info from .env file
    if [ -f "${env_file}" ]; then
        source "${env_file}"
    fi

    #echo "Setting proxy variables"
    proxy_url="http://${PROXY_USER}:${PROXY_PASS}@proxy.aexp.com:8080"
    #proxy_url=http://proxy.aexp.com:8080

    export http_proxy=$proxy_url
    export https_proxy=$proxy_url
    export HTTPS_PROXY=$proxy_url
    export HTTP_PROXY=$proxy_url

    export {NO_PROXY,no_proxy}=".americanexpress.com,.aexp.com,localhost,127.0.0.1,*.localstack.cloud"
}

function proxy-unset {
    unset HTTPS_PROXY
    unset HTTP_PROXY
    unset http_proxy
    unset https_proxy

    unset NO_PROXY
    unset no_proxy

    echo "Proxy variables are now unset"
}

function proxy-status {
    echo "Proxy variables:"
    echo " HTTP_PROXY=${HTTP_PROXY}"
    echo " HTTPS_PROXY=${HTTPS_PROXY}"
    echo " http_proxy=${http_proxy}"
    echo " https_proxy=${https_proxy}"

    echo
    echo " NO_PROXY=${NO_PROXY}"
    echo " no_proxy=${no_proxy}"
}


# Automatically set proxy variables on shell startup
proxy-set
