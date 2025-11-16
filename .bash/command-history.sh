
##################################################################################
# Global reverse-i-search with fzf
##################################################################################

# Enable shared global append-only history
if [[ -n "$_ZSH" ]]; then
  HISTFILE=~/.bash_history
  HISTSIZE=100000
  SAVEHIST=100000
  unsetopt APPEND_HISTORY
  unsetopt SHARE_HISTORY

  setopt INC_APPEND_HISTORY
  setopt APPEND_HISTORY
else
  shopt -s histappend
  PROMPT_COMMAND='history -a'
fi

sv/fzf-history-hybrid() {
  local cmd
  # Use fzf with a custom binding: Ctrl-e to "edit" instead of "run"
  cmd=$(tac ~/.bash_history | \
          fzf -e +s --prompt='Global history> ' --height=40% \
	            --border=top \
	            --scheme=path \
              --bind='ctrl-e:accept' \
              --expect=enter,ctrl-e)

  local key=$(head -1 <<< "$cmd")
  local selected=$(tail -n +2 <<< "$cmd")

  [[ -z "$selected" ]] && return


  if [[ -z "$_ZSH" ]]; then
    # Add to shell history
    history -s "$selected"

    # Bash-specific insertion
    READLINE_LINE="$selected"
    READLINE_POINT=${#READLINE_LINE}
  else
    # Add to shell history
    print -sr -- "$selected"

    # Zsh-specific insertion using zle
    LBUFFER+="$selected"
  fi
}

sv/bind-key "\C-r" sv/fzf-history-hybrid

