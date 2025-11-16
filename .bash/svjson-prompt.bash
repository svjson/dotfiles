
# Load prompt utils (abbreviate_path, parse_git_branch, etc)
if [[ -f "$HOME/.bash/prompt-utils.sh" ]]; then
  source "$HOME/.bash/prompt-utils.sh"
fi

##################################################################################
# Bash Prompt
##################################################################################

git_prompt_segment() {
  local branch=$(parse_git_branch)
  if [[ -n "$branch" ]]; then
    printf "\e[38;5;22;48;5;40m \e[1;38;5;0;48;5;40m$branch \e[38;5;40;48;5;28m"
  else
    printf "\e[38;5;22;48;5;28m"
  fi
}

svjson_ps1() {
  PS1='\[\e[1;38;5;0;48;5;22m\] \u@\h $(git_prompt_segment)\[\e[1;38;5;0;48;5;28m\] $(abbreviate_path \w 40) \[\e[38;5;28;48;5;0m\]\[\e[0m\] '
  export _PS1="svjson"
}

