alias l "exa -lah"
alias ll "exa -l"
alias la "exa -a"
alias ls exa

alias pc "proxychains -q"
alias cp "cp --reflink"

function sysupg
    sudo aptitude update; and sudo apt-fast full-upgrade; and sudo apt autoremove
end

fish_add_path $HOME/.local/bin $HOME/.cargo/bin

#set fish_function_path $fish_function_path "/usr/lib/python3.8/site-packages/powerline/bindings/fish"
#powerline-setup
