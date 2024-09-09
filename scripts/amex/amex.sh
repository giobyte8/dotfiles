
function proxy-set {
    # TODO: Use -s argument to show/no show logging

    #echo "Setting proxy variables"

    export http_proxy=http://proxy.aexp.com:8080
    export https_proxy=http://proxy.aexp.com:8080
    export HTTPS_PROXY=http://proxy.aexp.com:8080
    export HTTP_PROXY=http://proxy.aexp.com:8080
}

function proxy-unset {
    unset HTTPS_PROXY
    unset HTTP_PROXY
    unset http_proxy
    unset https_proxy

    echo "Proxy variables are now unset"
}

function proxy-status {
    echo "Proxy variables:"
    echo " HTTP_PROXY=${HTTP_PROXY}"
    echo " HTTPS_PROXY=${HTTPS_PROXY}"
    echo " http_proxy=${http_proxy}"
    echo " https_proxy=${https_proxy}"
}


# Automatically set proxy variables on shell startup
proxy-set
