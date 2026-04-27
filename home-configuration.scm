;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.
(define-module (home-configuration)
               #:export (nvim-config-source))

(use-modules (gnu home)
	     (gnu packages)
	     (gnu packages shells)
	     (gnu packages vim)
	     (gnu packages version-control)
	     (gnu services)
	     (guix gexp)
	     (guix build utils)
	     (gnu home services)
	     (gnu home services shells)
	     (gnu home services dotfiles))







(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages (list "nss-certs"
					    "zoxide"
					    "tmux"
					    "man-pages"
					    "neovim"
					    "git"
					    "mtr"
					    "glibc-locales"
					    "less"
					    "bat"
					    "zsh"
					    "clang"
					    "ninja"
					    "cmake"
					    "guile-colorized"
					    "guile-readline"
					    "guile"
					    "texinfo"
					    "vim"
					    "make")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
    (append (list (service home-bash-service-type
			   (home-bash-configuration
			     (aliases '(("ls" . "ls --color=auto")))
			     (bashrc (list (local-file
					     ".bashrc"
					     "bashrc")))
			     (bash-logout (list (local-file
						  ".bash_logout"
						  "bash_logout")))))
		  (simple-service 'simple-envs-service
				  home-environment-variables-service-type
				  `(("EDITOR". ,(file-append neovim "/bin/nvim"))
				    ("SHELL" . ,(file-append zsh "/bin/bash"))
				    ("PATH". "/home/elysium/go/bin:$PATH")
				    ("ERL_AFLAGS" . "-kernel shell_history enabled")))
		  (service home-dotfiles-service-type 
			   (home-dotfiles-configuration (directories 
							  `("./dotfiles"))))
		  )
	    %base-home-services)))
