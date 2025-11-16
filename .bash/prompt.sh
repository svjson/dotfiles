
##################################################################################
# Bash Prompt
##################################################################################

SEG_LIMIT_FACTOR=3
source ~/.bash/svjson-prompt.bash

standard_ps1() {
  PS1='\u@\h:\W\$ '
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
