#
# lse: Inspects extensions found at a given path
#  Current path is used by default

function __lse_usage {
    cat <<'EOF'
Usage: lse [-r] [-h|--help] [PATH]

List file extensions found in PATH and print a count per extension.

Options:
  -r        Search recursively in PATH and its children
  -h        Show this help text
  --help    Show this help text

Arguments:
  PATH      Target directory. Defaults to the current directory.
EOF
}

function __lse_usage_error {
    echo "Try 'lse --help' for usage." >&2
}

function lse {
    local recursive="0"
    local target="$PWD"

    while [ $# -gt 0 ]; do
        case "$1" in
            -r)
                recursive="1"
                shift
                ;;
            -h|--help)
                __lse_usage
                return 0
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "lse: unknown option: $1" >&2
                __lse_usage_error
                return 1
                ;;
            *)
                break
                ;;
        esac
    done

    # Reject more than one positional path argument after option parsing.
    if [ $# -gt 1 ]; then
        echo "lse: too many arguments" >&2
        __lse_usage_error
        return 1
    fi

    # Override the default current directory when a path argument is provided.
    if [ $# -eq 1 ]; then
        target="$1"
    fi

    # Fail fast when the requested path does not exist or is not a directory.
    if [ ! -e "$target" ]; then
        echo "lse: path not found: $target" >&2
        return 1
    elif [ ! -d "$target" ]; then
        echo "lse: not a directory: $target" >&2
        return 1
    fi

    # Prefix dash-starting paths so find does not parse them as options.
    # Example: -logs becomes ./-logs.
    case "$target" in
        -*)
            target="./$target"
            ;;
    esac

    # Recursive mode removes the top-level-only depth restriction.
    if [ "$recursive" = "1" ]; then
        find "$target" -type f -name '*.*' | \
            sed 's/[^\.]*//' | \
            sed 's/.*\.//'   | \
            sort             | \
            uniq -c
    else
        find "$target" -maxdepth 1 -type f -name '*.*' | \
            sed 's/[^\.]*//' | \
            sed 's/.*\.//'   | \
            sort             | \
            uniq -c
    fi
}
