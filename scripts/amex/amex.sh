
function proxy-set {
    # TODO: Use -s argument to show/no show logging

    #echo "Setting proxy variables"

    export http_proxy=http://proxy.aexp.com:8080
    export https_proxy=http://proxy.aexp.com:8080
    export HTTPS_PROXY=http://proxy.aexp.com:8080
    export HTTP_PROXY=http://proxy.aexp.com:8080

    export {NO_PROXY,no_proxy}=".americanexpress.com,.aexp.com,localhost,127.0.0.1"
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
