
alias ls='ls --color=auto'
alias ll='ls -al'
alias grep='grep --color=auto'

alias actclean='docker rm -f $(docker ps -a --filter "name=act" -q 2>/dev/null) 2>/dev/null || true'

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
