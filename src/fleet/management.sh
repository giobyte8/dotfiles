#!/bin/env bash
# Fleet management shortcuts
#
# DEV NOTES:
#  - Query all container labels:
#    docker inspect --format '{{json .Config.Labels}}' <fldev-jaeger-1>


# Fleet management entry point
# Usage:
#   fl <command> [env|group] [group]
#
# Function body is wrapped in '()' rather than '{}' to
# use a subshell so `set -e` stops this command on failure
# without changing the calling interactive shell.
function fl() (
  set -e -o pipefail

  local cmd="$1"
  shift

  case "$cmd" in
    ps)
      __fps "$@"
      ;;
    up)
      __fup "$@"
      ;;
    *)
      __err "Unknown command '$cmd'"
      # TODO: Print usage information
      return 1
      ;;
  esac
)

# #####################################
# Subcommands

function __fps {
  local _ALL="-a"

  local host_path="$_ALL"
  local group="$_ALL"
  local d_filters=()

  # Read arguments for 'ps' subcommand
  case $# in
    0)
      # echo 'All service groups'
      ;;
    1)
      group="$(__resolve_group "$1")"
      ;;
    2)
      host_path="$(__resolve_host_cfg_path "$1")"
      group="$(__resolve_group "$2")"
      ;;
    *)
      __err 'Usage: fl ps group[|host group]'
      ;;
  esac

  # Filter by required host
  if [ "$host_path" != "$_ALL" ]; then
    d_filters+=(
      --filter
      "label=com.docker.compose.project.working_dir=$host_path"
    )
  fi

  # Filter by required group
  if [ "$group" = "$_ALL" ]; then
    d_filters+=(
      --filter
      "label=fl.group"
    )
  else
    d_filters+=(
      --filter
      "label=fl.group=$group"
    )
  fi

  # Format output columns to display
  local ps_colums
  ps_colums=$(printf '%s' \
    '{{.Label "fl.group"}}\t' \
    '{{.Label "com.docker.compose.service"}}\t' \
    '{{.Names}}\t' \
    '{{.Status}}'
  )

  # Pipeline Phase 1:
  #  1. `docker ps`: applies filters and outputs required columns.
  #  2. `sort`: orders rows by 1st, 2nd columns, group and service.
  #  3. `awk`: marks group changes with '__GROUP_BR__' and removes
  #      the internal group field.
  #
  # Pipeline Phase 2
  #  4. `column`: aligns the fields into a table format.
  #  5. `awk`: converts group markers into blank lines.
  {
    printf 'SERVICE\tCONTAINER\tSTATUS\n'

    docker ps \
      "${d_filters[@]}" \
      --format "$ps_colums" |
    sort -t $'\t' -k1,1 -k2,2 |
    awk -F $'\t' '
      NR > 1 && $1 != previous_group {
        print "__GROUP_BR__"
      }
      {
        previous_group = $1
        sub(/^[^\t]*\t/, "")
        print
      }
    '
  } |
  column -t -s $'\t' |
  awk '
    $0 == "__GROUP_BR__" { print ""; next }
    { print }
  '
}

function __fup {
  local _ALL="-a"
  local host="$FL_HOST" # Set to default value
  local group

  # Read arguments for 'up' subcommand
  case $# in
    0)
      # echo 'All service groups'
      ;;
    1)
      group="$(__resolve_group "$1")"
      ;;
    2)
      host="$1"
      group="$(__resolve_group "$2")"
      ;;
    *)
      __err 'Usage: fl up [host] [group]'
      ;;
  esac

  host_path="$(__resolve_host_cfg_path "$host")"
  cd "$host_path"

  # Group is set and not equal to '_ALL'
  if [ -n "$group" ] && [ "$group" != "$_ALL" ]; then
    # Start services for the specified group
    docker compose up -d $(__svcs_in_group "$group")
  else
    # Start all non-disabled services
    docker compose up -d $(__svcs_not_in_group "disabled")
  fi
}

# #####################################
# Argument resolvers

function __resolve_host_cfg_path {
  local host="$1"
  local host_path

  case "$host" in
    dev|d)
      host="dev"
      ;;
    m4|m)
      host="m4"
      ;;
    rbx|r)
      host="rbx"
      ;;
  esac

  # Verify host path existence
  host_path="$FL_HOME/hosts/$host"
  if [ ! -d "$host_path" ]; then
    __err "Host not found: '$host'"
  fi

  echo "$host_path"
}

function __resolve_group {
  local svc_group="$1"

  # case backbone|b|bb
  case "$svc_group" in
    -a)
      svc_group="-a"
      ;;
    backbone|b|bb)
      svc_group="backbone"
      ;;
    telemetry|t|tl)
      svc_group="telemetry"
      ;;
    apps|a)
      svc_group="apps"
      ;;
    *)
      __err "Unknown service group: '$svc_group'"
      ;;
  esac

  echo "$svc_group"
}

function __svcs_in_group {
  local svc_group="$1"

  docker compose config --format json |
    jq -r --arg group "$svc_group" '
      .services
      | to_entries[]
      | select(.value.labels["fl.group"] == $group)
      | .key
    '
}

function __svcs_not_in_group {
  local svc_group="$1"

  # labels[fl.group] != $group
  docker compose config --format json |
    jq -r --arg group "$svc_group" '
      .services
      | to_entries[]
      | select(.value.labels["fl.group"] != $group)
      | .key
    '
}

# #####################################
# Helper functions

# Log an error message and return 1.
# This 'return 1' propagates the error up the call chain
# and stops further execution.
function __err {
  echo "fl: "${1}"" >&2
  return 1
}
