function l
    exa -lah $argv
end

function ll
    exa -l $argv
end

function la
    exa -a $argv
end

function ls
    exa
end

function sysupg
    sudo aptitude update; and sudo apt-fast upgrade; and sudo apt autoremove
end

function pc
    proxychains -q $argv
end

#set fish_function_path $fish_function_path "/usr/lib/python3.8/site-packages/powerline/bindings/fish"
#powerline-setup
