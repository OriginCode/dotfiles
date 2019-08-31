function l
    ls -lah $argv
end

function ls
    command ls --color=tty $argv
end

function sysupg
    sudo pacman -Sy; and sudo powerpill -Suw $argv; and yay -Su $argv
    yay -Qtdq | ifne sudo pacman -Rsc -
end

set fish_function_path $fish_function_path "/usr/lib/python3.7/site-packages/powerline/bindings/fish"
powerline-setup

if status is-interactive 
and not set -q TMUX
    exec tmux
end
clear
