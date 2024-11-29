(define-module (oc configurations sway-conf)
  #:export (%custom-sway-packages
            custom-sway-configuration)

  #:use-module (guix gexp)
  #:use-module (gnu home services sway)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages image))

(define %custom-sway-packages
  (list "foot" "grim" "wl-clipboard"))

(define custom-sway-configuration
  (sway-configuration
    (variables
      `((mod . "Mod1")
        (up . "l")
        (down . "k")
        (left . "j")
        (right . "semicolon")
        (term . ,#~(string-append #$foot "/bin/foot"))
        ,@(map (lambda (x) `(,(string->symbol (string-append "ws" x))
                              . ,x))
               (map number->string (iota 10 1)))
        ))

    (keybindings
      `(; launch terminal
        ($mod+Return . "exec $term")

        ; kill focused window
        ($mod+Shift+q . "kill")

        ; start fuzzel program launcher
        ;($mod+d . ,#~(string-append "exec " #$fuzzel "/bin/fuzzel"))

        ; change focus
        ($mod+$left . "focus left")
        ($mod+$down . "focus down")
        ($mod+$up . "focus up")
        ($mod+$right . "focus right")
        ($mod+Left . "focus left")
        ($mod+Down . "focus down")
        ($mod+Up . "focus up")
        ($mod+Right . "focus right")

        ; move focused window
        ($mod+Shift+$left . "move left")
        ($mod+Shift+$down . "move down")
        ($mod+Shift+$up . "move up")
        ($mod+Shift+$right . "move right")
        ($mod+Shift+Left . "move left")
        ($mod+Shift+Down . "move down")
        ($mod+Shift+Up . "move up")
        ($mod+Shift+Right . "move right")

        ; enter fullscreen mode for the focused container
        ($mod+Shift+space . "floating toggle")

        ; change focus between tiling / floating windows
        ($mod+space . "focus mode_toggle")

        ; move the currently focused window to the scratchpad
        ($mod+Shift+minus . "move scratchpad")

        ; show the next scratchpad window
        ($mod+minus . "scratchpad show")

        ; lock the screen
        ;($mod+o . ,#~(string-append "exec " #$swaylock "/bin/swaylock"))

        ; resize mode
        ($mod+r . "mode resize")

        ; switch to workspace
        ,@(map (lambda (x) `(,(string->symbol (string-append "$mod+" x))
                              . ,(string-append "workspace number $ws" x)))
               (map number->string (iota 9 1)))
        ($mod+0 . "workspace number $ws10")

        ; move focused container to workspace
        ,@(map (lambda (x) `(,(string->symbol (string-append "$mod+Shift+" x))
                              . ,(string-append "move container to workspace number $ws" x)))
               (map number->string (iota 9 1)))
        ($mod+Shift+0 . "move container to workspace number $ws10")

        ; reload the configuration file
        ($mod+Shift+c . "reload")
        ; exit sway
        ($mod+Shift+e
          . ,#~(string-append
                 "exec " #$sway "/bin/swaynag "
                 "-t warning "
                 "-m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' "
                 "-B 'Yes, exit sway' "
                 "'" #$sway "/bin/swaymsg exit'"))

        ; screenshots
        (Print
          . ,#~(string-append "exec " #$grim "/bin/grim " "~/Pictures/screenshot.png"))
        (Ctrl+Print
          . ,#~(string-append "exec " #$grim "/bin/grim - | " #$wl-clipboard "/bin/wl-copy"))
        ))

    (startup-programs `(,#~(string-append #$foot "/bin/foot")))

    (bar (sway-bar
           (status-command "while date +'%Y-%m-%d %X'; do sleep 1; done")))

    (inputs (list
              (sway-input
                (identifier "9610:30:Pine64_Pinebook_Pro_Touchpad")
                (disable-while-typing #t)
                (tap #t)
                (extra-content '("natural_scroll enabled"
                                 "middle_emulation enabled")))))

    (extra-content '("font pango:monospace 11"
                     "floating_modifier $mod"
                     ))))
