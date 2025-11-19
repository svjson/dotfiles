gp() {
  local PROFILE_FILE="${PROFILE_FILE:-$HOME/.gitprofiles}"
  local PROFILE="$1"

  if [ -z "$PROFILE" ]; then
    echo "Usage: gp <profile>"
    return 1
  fi

  if ! grep -q "^\[$PROFILE\]" "$PROFILE_FILE"; then
    echo "Profile '$PROFILE' not found in $PROFILE_FILE"
    return 1
  fi

  # Extract profile section into a variable
  local SECTION
  SECTION=$(awk -v profile="$PROFILE" '
    $0 ~ "^\\[" profile "\\]" { in_section=1; next }
    in_section && /^\[/ { in_section=0 }
    in_section { print }
  ' "$PROFILE_FILE" | sed '/^\s*$/d; /^\s*#/d')

  if [ -z "$SECTION" ]; then
    echo "No settings found under [$PROFILE]"
    return 1
  fi

  echo "Applying Git profile: $PROFILE"
  echo

  # Apply each key=value as git config
  while IFS='=' read -r key value; do
    key="$(echo "$key" | xargs)"
    value="$(echo "$value" | xargs)"
    [ -z "$key" ] && continue

    # Remove old value first
    git config --unset-all "$key" >/dev/null 2>&1 || true

    echo "  git config $key \"$value\""
    git config "$key" "$value"
  done <<< "$SECTION"

  echo
  echo "Done."
}
