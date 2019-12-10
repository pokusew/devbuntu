###
# BASH configuration for non-login shell
###


###
# HSTR
# Easily view, navigate and search your command history
# with shell history suggest box for Bash and zsh.
# source: https://github.com/dvorka/hstr
###
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
# export HISTCONTROL=ignorespace # leading space hides commands from history
export HISTCONTROL=ignoreboth    # see https://askubuntu.com/a/15929
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hh -k \C-j"'; fi


###
# bash-powerline
# Powerline for Bash in pure Bash script.
# source: https://github.com/riobard/bash-powerline
###
source ~/.bash-powerline.sh


###
# nvm
# source: https://github.com/creationix/nvm
###
source ~/nvm-init.sh


###
# Git shortcuts
###
alias gst="git status"


###
# yarn shortcuts
###
alias yarn-ui="yarn upgrade-interactive"
alias yarn-gui="yarn global upgrade-interactive"


###
# utils
###
alias clean-history="rm ~/.bash_history"
