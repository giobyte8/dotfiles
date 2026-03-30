
# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPTS="$(realpath $HERE/../scripts)"
SRC_DIR="$(realpath $HERE/../src)"

# -------------------------------------------------------------------
# Source common scripts

for f in "${SCRIPTS}"/*.sh; do source $f; done
for f in "${SRC_DIR}"/*.sh; do source $f; done


# -------------------------------------------------------------------
# Source scripts based on hostname

hostname=$(hostname)
if [ "$hostname" = "CQ76DCFF2Y" ]; then
    # echo "Sourcing scripts for 'amex' env"
    for f in "${SCRIPTS}"/amex/*.sh; do source $f; done
fi

if [ "$hostname" = "redbox" ]; then
    # echo "Sourcing scripts for 'redbox' env"
    for f in "${SCRIPTS}"/rbx/*.sh; do source $f; done
fi