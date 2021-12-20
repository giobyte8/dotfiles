
# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

for f in "${HERE}"/../scripts/*.sh; do source $f; done
for f in "${HERE}"/../scripts/skt/*.sh; do source $f; done
