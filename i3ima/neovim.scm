(define-module (i3ima neovim) #:export (conf)
	       #:use-module (guix git-download)
	       #:use-module (guix gexp)
	       #:use-module (guix))


(define conf-build
  #~(begin
      (mkdir #$output)
      (chdir #$output)
      (define nvim-ref git-reference (url "https://github.com/i3ima/kickstart.nvim.git") (commit "85edc99b0133b8dd701767216636a4636e547ae0"))
      (git-fetch nvim-ref 'sha256 (base32 "0hfkjw7d7l5hyjsq38vs42n57wh6w3xbw0msc8x9ch9ykzrp7w1h"))))

(define conf (gexp->derivation "neovim-conf" conf-build))
