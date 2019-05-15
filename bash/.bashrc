#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

. /usr/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
