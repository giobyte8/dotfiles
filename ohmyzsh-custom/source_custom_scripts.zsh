
# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPTS="$(realpath $HERE/../scripts)"

for f in "${SCRIPTS}"/*.sh; do source $f; done
for f in "${SCRIPTS}"/skt/*.sh; do source $f; done
