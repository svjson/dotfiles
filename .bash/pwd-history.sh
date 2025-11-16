
##################################################################################
# Pimp my cd, and global dir history search with fzf
##################################################################################

DIR_HISTORY="$HOME/.dir_history"
MAX_HISTORY_SIZE=150

if [[ -z "$_ZSH" ]]; then
  cd() {
    # Use the original cd command first
    command cd "$@" || return

    # Get the absolute path after the cd command
    local dir="$(pwd)"

    # Avoid duplicate entries using grep
    if ! grep -Fxq "$dir" "$DIR_HISTORY"; then
      echo "$dir" >> "$DIR_HISTORY"
    fi
  }
else
  chpwd() {
    # Get the absolute path after the cd command
    local dir="$(pwd)"

    # Avoid duplicate entries using grep
    if ! grep -Fxq "$dir" "$DIR_HISTORY"; then
      echo "$dir" >> "$DIR_HISTORY"
    fi
  }
fi

# Function to list and trim the history
cdhist() {
    # Trim the history to MAX_HISTORY_SIZE
    tail -n "$MAX_HISTORY_SIZE" "$DIR_HISTORY" > "$DIR_HISTORY.tmp"
    mv "$DIR_HISTORY.tmp" "$DIR_HISTORY"

    # Use fzf to select a directory
    local selection=$(cat "$DIR_HISTORY" | fzf --height 40% --scheme=path --border=top)

    # Simulate typing the command and pressing enter
    if [ -n "$selection" ]; then
      # Output the command to the prompt
      if [[ -z "$_ZSH" ]]; then
        READLINE_LINE="cd $selection"
        READLINE_POINT=${#READLINE_LINE}
      else
        # Zsh-specific insertion using zle
        LBUFFER+="cd $selection"
      fi
    fi

}

# Bind 'Ctrl-G' to cdhist function
sv/bind-key "\C-g" cdhist
