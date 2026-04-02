;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.

;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (gnu packages shells)
             (gnu packages linux)
             (gnu system locale)
             (gnu bootloader u-boot))
(use-service-modules networking ssh desktop)

;; SSH Authorized Keys
(define ssh-authorized-keys
  (list
   (plain-file
    "origincode-yubikey"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPuGg1xLtrbcFk1JfD0/Xgkd43XgYN29Vl853J5JmMwq cardno:16_059_579")
   (plain-file
    "origincode-ameto"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLTRo1i4QW+cs+3H5ao9cz5Cn+aS48PkvcvTzH2FekF origincode@ameto")))

(define admin-packages
  (specifications->packages
       (list "vim" "htop" "curl" "wget" "tmux" "git" "tree" "rsync" "brightnessctl")))

(operating-system
 (locale "en_US.utf8")
 (timezone "America/Los_Angeles")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "celica")
 (sudoers-file
  (plain-file "sudoers"
              "\
root ALL=(ALL) ALL
%wheel ALL=(ALL) NOPASSWD: ALL\n"))
 (locale-definitions
   (cons* (locale-definition
	    (name "zh_TW.UTF-8")
	    (source "zh_TW"))
	  (locale-definition
	    (name "zh_CN.UTF-8")
	    (source "zh_CN"))
	  (locale-definition
	    (name "ja_JP.UTF-8")
	    (source "ja_JP"))
	  %default-locale-definitions))
 ;; The list of user accounts ('root' is implicit).
 (users (cons* (user-account (name "origincode")
                             (comment "Kaiyang Wu")
                             (group "users")
                             (home-directory "/home/origincode")
                             (shell (file-append fish "/bin/fish"))
                             (supplementary-groups
                              '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))
 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append admin-packages
                    %base-packages))

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (cons*
    ;; Add this machine to hosts file
    (simple-service 'add-extra-hosts
		    hosts-service-type
		    (list (host "192.168.1.113" "celica" '("celica"))))
    ;; To configure OpenSSH, pass an 'openssh-configuration'
    ;; record as a second argument to 'service' below.
    (service openssh-service-type
	     (openssh-configuration
	       (authorized-keys `(("origincode" ,@ssh-authorized-keys)
				  ("root" ,@ssh-authorized-keys)))
	       (permit-root-login 'prohibit-password)
	       (password-authentication? #t)))

    (service elogind-service-type
	     (elogind-configuration
	       (handle-lid-switch-external-power 'ignore)))

    (service wpa-supplicant-service-type)
    (service network-manager-service-type)

    (udev-rules-service 'brightnessctl brightnessctl)
    ;; This is the default list of services we
    ;; are appending to.
    %base-services))
 (initrd-modules '())
 (kernel linux-libre-arm64-generic)
 (bootloader (bootloader-configuration
              (bootloader u-boot-pinebook-pro-rk3399-bootloader)
              (targets '("/dev/mmcblk2"))))
 ;(bootloader (bootloader-configuration
 ;             (targets '("/dev/mmcblk1"))
 ;             (bootloader u-boot-bootloader)))
 (file-systems (cons (file-system (device (file-system-label "Guix_image"))
                                  (mount-point "/")
                                  (type "ext4"))
                     %base-file-systems))
 (swap-devices
   (list
     (swap-space
       (target "/swapfile")
       (dependencies (filter (file-system-mount-point-predicate "/")
			     file-systems))))))
