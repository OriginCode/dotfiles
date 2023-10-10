#set -g fish_greeting

function fish_greeting
    set task_count (task status:pending count)
    if test $task_count -gt 0
        echo "You have $task_count task(s) to do!"
        task
    end
end

fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g theme_color_scheme nord
set -g theme_display_user yes
set -g theme_display_hostname yes
set -g theme_display_date no
set -g theme_show_exit_status yes

set -x EDITOR vim

thefuck --alias | source

starship init fish | source

# opam configuration
source /home/origincode/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/origincode/.ghcup/bin # ghcup-env
