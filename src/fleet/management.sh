#!/bin/env bash
# Fleet management shortcuts

# NOTES>
#  - Query all labels:
#    docker inspect --format '{{json .Config.Labels}}' <fldev-jaeger-1>

function fps {
  local group=$1

  # Bypass label filtering if group isn't provided
  if [ -z "$group" ]; then
    fps backbone
    echo
    fps telemetry
    echo
    fps apps
    return 0
  fi

  # Simpler, but not sorting supported
  # docker ps \
  #   --filter "label=fl.group=$group" \
  #   --format 'table {{.Label "com.docker.compose.service"}}\t{{.Names}}\t{{.Status}}' \
  # | sed '1s/^service/SERVICE/'

  # Manually sort and format the output using `sort` and `column`
  {
    printf 'SERVICE\tNAME\tSTATUS\n'
    docker ps \
      --filter "label=fl.group=$group" \
      --format '{{.Label "com.docker.compose.service"}}\t{{.Names}}\t{{.Status}}' |
      sort -t $'\t' -k1,1 -k2,2
  } | column -t -s $'\t'
}
