
#
# ~/.bash/svjson-prompt.zsh
#

# Load prompt utils (abbreviate_path, parse_git_branch, etc)
if [[ -f "$HOME/.bash/prompt-utils.sh" ]]; then
  source "$HOME/.bash/prompt-utils.sh"
fi

##################################################################################
# Bash Prompt
##################################################################################

abbreviate_path_zsh() {
  local path="$1"
  local base_limit="${2:-30}"
  local max_length

  if [[ "$path" == "$HOME"* ]]; then
    path="~${path#$HOME}"
  fi

  if [[ "$path" == "~" || "$path" == "/*" ]]; then
    echo "$path"
    return
  fi

  local IFS='/'
  local -a segments
  segments=(${(s:/:)path})

  local segment_count=${#segments[@]}
  local first="${segments[1]}"
  local keep_start=1
  if [[ "$first" == "~" ]]; then
    keep_start=2
  fi

  max_length=$(( base_limit + (segment_count * SEG_LIMIT_FACTOR) ))

  local abbreviated_path=""
  local i=1

  while (( i < keep_start )); do
    abbreviated_path+="${segments[i]}"
    if (( i < segment_count )); then
      abbreviated_path+="/"
    fi
    ((i++))
  done

  abbreviated_path+="${(j:/:)segments[keep_start,segment_count]}"

  if (( ${#abbreviated_path} <= max_length )); then
    echo "$abbreviated_path"
    return
  fi

  i=$keep_start
  while (( ${#abbreviated_path} > max_length && i < segment_count )); do
    if (( ${#segments[i]} > 1 )) && [[ "${segments[i]}" != .* ]]; then
      segments[i]="${segments[i]:0:1}"
    fi

    abbreviated_path=""
    for (( j = 1; j < segment_count; j++ )); do
      abbreviated_path+="${segments[j]}/"
    done
    abbreviated_path+="${segments[segment_count]}"
    ((i++))
  done

  echo "$abbreviated_path"
}

_git_prompt_segment() {
  local branch=$(parse_git_branch)
  if [[ -n "$branch" ]]; then
    echo "%F{55}%K{238} %F{16}$branch %F{238}%K{93}"
  else
    echo "%F{55}%K{93}"
  fi
}


# Construct Zsh prompt with proper escape handling
svjson_ps1() {
  precmd() {
    PROMPT='%{%f%k%}'
    PROMPT+='%F{16}%K{55} %F{141}%n@%m '
    PROMPT+="$(_git_prompt_segment) "
    PROMPT+='%F{16}%K{93}'
    PROMPT+="$(abbreviate_path_zsh ${PWD} 40) "
    PROMPT+='%F{93}%K{16}%{%f%k%} '
  }
  export _PS1="svjson"
}


bindkey -e

# Ensure cursor keys work correctly
autoload -Uz select-word-style
select-word-style bash

# Home / End / Ctrl+Left / Ctrl+Right
bindkey "\e[1~" beginning-of-line   # Home
bindkey "\e[4~" end-of-line         # End
bindkey "^[OH" beginning-of-line    # Home (some terms)
bindkey "^[OF" end-of-line          # End (some terms)
bindkey "\e[H" beginning-of-line    # Alternate Home
bindkey "\e[F" end-of-line          # Alternate End

# Ctrl+Arrow bindings (word navigation, bash-like)
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# Misc
bindkey '\e[3~' delete-char
