
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Load postgres tools
#   Installed without installing the full db
#   See: https://stackoverflow.com/a/49689589/3211029
if [ -d "/opt/homebrew/opt/libpq/bin" ]; then
    PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi
