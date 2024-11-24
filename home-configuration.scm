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
             (gnu home services shells))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages (list "zoxide"
                                            "racket-minimal"
                                            "rust-cargo"
                                            "vim-full"
                                            "rust-analyzer"
                                            "fastfetch"
                                            "stow")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list 
     ;; `--dotfiles` option is unusable
     ;(service home-dotfiles-service-type
     ;         (home-dotfiles-configuration
     ;           (layout 'stow)
     ;           (directories (list "vim" "fastfetch"))))

     (service home-files-service-type
              `((".vimrc" ,(local-file "./vim/dot-vimrc"))))

     (service home-fish-service-type
              (home-fish-configuration
                (config `(,(plain-file "zoxide-init.fish"
                                       "zoxide init fish | source")
                           ,(plain-file "local-bin-path.fish"
                                        "fish_add_path $HOME/.local/bin")
                           ,(plain-file "disable-greeting.fish"
                                        "set -g fish_greeting")))
                (environment-variables '(("EDITOR" . "vim")
                                         ("MANWIDTH" . "80"))))))))
