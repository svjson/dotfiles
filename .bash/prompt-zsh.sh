#
# ~/.bash/prompt-zsh.sh
#

##################################################################################
# Zsh Prompt
##################################################################################

SEG_LIMIT_FACTOR=3
source ~/.bash/svjson-prompt.zsh
export SEG_LIMIT_FACTOR=3
standard_ps1() {
  precmd() {
    PROMPT='%F{81}%n@%m %1~ $%f '
  }
  PROMPT='%F{81}%n@%m %1~ $%f '
  export _PS1="standard"
}

toggle_ps1() {
  if [[ "$_PS1" == "svjson" ]]; then
    standard_ps1
  else
    svjson_ps1
  fi
}

svjson_ps1

sv/bind-key "\C-_" toggle_ps1

##################################################################################
# Init zsh-autosuggestions
##################################################################################
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

ZSH_AUTOSUGGEST_STRATEGY=(completion history)


##################################################################################
# Disable autocomp caching, because it's stupid.
##################################################################################

# Disable zcompdump completely
ZDOTDIR=${ZDOTDIR:-$HOME}
ZSH_COMPDUMP=/dev/null  # tell compinit not to write to a real file

# Always reinit completions from scratch
autoload -Uz compinit
compinit -i
