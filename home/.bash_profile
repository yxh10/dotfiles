#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
