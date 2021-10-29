if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g theme_color_scheme nord
set -g theme_display_user yes
set -g theme_display_hostname yes
set -g theme_display_date no
set -g theme_show_exit_status yes

thefuck --alias | source
