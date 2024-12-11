;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services)
             (gnu home services dotfiles)
             (gnu home services shells)
             (gnu home services sway)
             (gnu home services xdg)
             (gnu home services fontutils)
             (gnu home services sound)
             (gnu home services desktop)
             (gnu packages rust-apps)
             (oc configurations sway-conf)
             (oc configurations fonts-conf))

(define %input-method-packages
  '("fcitx5"
    "fcitx5-configtool"
    "fcitx5-qt"
    "fcitx5-gtk"
    "fcitx5-gtk4"
    "fcitx5-rime"))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages
              `(,@%custom-fonts-packages
                ;,@%input-method-packages
                 "fastfetch"
                 "python-minimal"
                 "weechat"
                 ;"stow"
                 "eza"
                 "zoxide"
                 "racket-minimal"
                 "rust-analyzer"
                 "vim-guix-vim"
                 "gparted"
                 "lynx"
                 )))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list
     ;; `--dotfiles` option is unusable
     ;(service home-dotfiles-service-type
     ;         (home-dotfiles-configuration
     ;           (layout 'stow)
     ;           (directories (list "vim" "fastfetch"))))

     ;; Workaround for missing `--dotfiles` arg of stow
     (simple-service 'vimrc-file
                     home-files-service-type
                     `((".vimrc" ,(local-file "./vim/dot-vimrc"))))
     (simple-service 'tmux-conf-file
                     home-xdg-configuration-files-service-type
                     `(("tmux/tmux.conf" ,(local-file "./tmux/dot-config/tmux.conf"))))
     (simple-service 'gitconfig-file
                     home-files-service-type
                     `((".gitconfig"
                        ,(plain-file
                           "gitconfig"
                           "\
[init]
	defaultBranch = master
[user]
	email = self@origincode.me
	name = Kaiyang Wu"))))
     (simple-service 'foot-conf-file
                     home-xdg-configuration-files-service-type
                     `(("foot/foot.ini" ,(local-file "./foot/dot-config/foot/foot.ini"))))
     
     (service home-fish-service-type
              (home-fish-configuration
                (config `(,(plain-file "zoxide-init.fish"
                                       "zoxide init fish | source")
                           ,(plain-file "local-bin-path.fish"
                                        "fish_add_path $HOME/.local/bin")
                           ,(plain-file "disable-greeting.fish"
                                        "set -g fish_greeting")))
                (environment-variables '(("EDITOR" . "vim")
                                         ("MANWIDTH" . "80")))
                (aliases '(("l" . "eza -lah")
                           ("ll" . "eza -l")
                           ("la" . "eza -a")
                           ("lt" . "eza -lahT")
                           ("v" . "vim")
                           ("pd" . "prevd")
                           ("nd" . "nextd")
                           ("sysupg"
                            .
                            "guix pull; and sudo guix reconfigure /etc/config.scm; and guix home reconfigure dotfiles/home-configuration.scm")))
                (abbreviations '(("gcsm" . "git commit -S -s -m")))))

     (service home-dbus-service-type)

     (service home-sway-service-type
              custom-sway-configuration)

     (service home-xdg-user-directories-service-type)

     ;(service home-pipewire-service-type)

     (simple-service 'custom-fonts-conf
                     home-fontconfig-service-type
                     %custom-fonts-configuration)
     
     (simple-service 'lang-env-var
                     home-environment-variables-service-type
                     '(("LANG" . "zh_TW.UTF-8")))

     (simple-service 'input-method-env-vars
                     home-environment-variables-service-type
                     '(("QT_IM_MODULE" . "fcitx")
                       ("XMODIFIERS" . "@im=fcitx")
                       ("GTK_IM_MODULE" . "fcitx")))
     )))
