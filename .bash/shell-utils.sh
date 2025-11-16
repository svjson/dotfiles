#!/bin/sh
#
# ~/.bash/shell-utils.sh
#

##################################################################################
# Utility functions for abstracting away bash/zsh differences
##################################################################################

sv/bind-key() {
  local key="$1"
  local command="$2"

  if [[ -n "$_ZSH" ]]; then
    zle -N "$command"
    bindkey "$key" "$command"
  else
    bind -x "\"$key\": $command"
  fi
}
