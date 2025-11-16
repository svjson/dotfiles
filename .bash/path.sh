# Define NVM_DIR
export NVM_DIR="$HOME/.nvm"

# Load nvm if it exists
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "$NVM_DIR/nvm.sh"
fi

# Explicitly add the bin path of the default Node version
if command -v nvm >/dev/null; then
  export PATH="$NVM_DIR/versions/node/$(nvm version default)/bin:$PATH"
fi

export PATH="$(cd /tmp/ && yarn global bin):${PATH}"

# pnpm
export PNPM_HOME="/home/svjson/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
