export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto"

sd_retval_cond () {
   local ret_val=$?
   if [[ "$ret_val" = "0" ]]; then echo -e "$1"; else echo -e "$2"; fi
   return $ret_val
}

RESET='\[\e[0m\]'     BOLD='\[\e[1m\]'
YELLOW='\[\e[33m\]'   BLUE='\[\e[34m\]'
BLACK='\[\e[30m\]'    RED='\[\e[31m\]'
PINK='\[\e[35m\]'     CYAN='\[\e[36m\]'
GREEN='\[\e[32m\]'    GRAY='\[\e[37m\]'
export PS1="\n$BOLD$BLUE(\u) \$(sd_retval_cond '$GREEN' '$RED')[\$(sd_retval_cond woo \"aww \$?\")] $YELLOW(\$(date +%H:%M:%S)) $PINK\w\$(__git_ps1 ' $CYAN[%s]')\n$RESET$BLUE\$$RESET "

export CLICOLOR=1 # lets ls and stuff show colors
export EDITOR=vim

# ~/bin
export PATH="$HOME/bin:$PATH"

# ~/unix/bin
export PATH="$HOME/unix/bin:$PATH"

# leiningen
export PATH="$HOME/.lein/bin:$PATH"

# homebrew
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# bash completion
source /usr/local/etc/bash_completion
