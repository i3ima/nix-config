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



;; My dotfiles with neo(vim) config as a submodule :3
(define dotfiles-source
  (origin
    (method git-fetch)
    (uri (git-reference
           (url "https://github.com/i3ima/dotfiles.git")
           (commit "77a8c0b1104f6fb17d92d25b8e0b91650ca3cb1e")
           (recursive? #t)))
    (file-name (git-file-name "dotfiles-recursive" "77a8c0"))
    (sha256
      (base32 "0p0llsaymdlpwfklvcv78c2dg9b3zdjjqzng7q89q5kfgk8qkl78"))))

;; Erlang package variant to disable fucking WxWidgets that pulls whole GTK3 and GNOME stuff,
;; which result in incredibly long compilation
(define-public erlang-no-wx
  (package
    (inherit erlang)
    (name "erlang")
    (version "24.3.4.12")
    (inputs
      (modify-inputs (package-inputs erlang)
        (delete "wxwidgets")))
    (arguments (substitute-keyword-arguments (package-arguments erlang) 
      ((#:configure-flags flags)
       `(append ,flags
                (list "--disable-wx")))))))

;; Propagate to rebar3 variant, which has Erlang as dependency
;; rebar3 itself needed for erlang_ls LSP server 
(define rebar3-no-wx
  (package/inherit rebar3
    (name "rebar3-no-wx")
    (native-inputs
      (modify-inputs (package-native-inputs rebar3)
        (replace "erlang" erlang-no-wx)))))


;; Pin some packages versions
(define node-22
  (specification->package "node@22.14.0"))

(define python-3.10
  (specification->package "python@3.10.19"))

(define python-pip-25
  (specification->package "python-pip@25.1.1"))

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
                       (guix-defaults? #t)
                       (aliases '(("ls" . "ls --color=auto")))))
                  (simple-service 'simple-envs-service
                      home-environment-variables-service-type
                      `(("EDITOR". ,(file-append neovim "/bin/nvim"))
                        ("SHELL" . ,(file-append zsh "/bin/zsh"))
                        ("PATH". "/home/elysium/go/bin:$PATH")
                        ("ERL_AFLAGS" . "-kernel shell_history enabled")))
                  (simple-service 'dotfiles-from-git
                      home-xdg-configuration-files-service-type
                      `(("nvim" ,(file-append dotfiles-source "/.config/nvim"))
                        ("tmux" ,(file-append dotfiles-source "/.config/tmux"))))
                  )
            %base-home-services)))
