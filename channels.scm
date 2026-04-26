(use-modules (guix ci)
             (guix channels)
             (ice-9 copy-tree))

(define codeberg-channel (channel
    (name 'guix)
    (url "https://codeberg.org/guix/guix.git")
    (commit "ada3baa1b33bf88a74efcd6668a0ec48190a90c8")
    (introduction
      (make-channel-introduction
        "3512a3f318dd58ca00651150c3ac4ef9ff1bc16b"
        (openpgp-fingerprint
          "9847 81DE 689C 21C2 6418  0867 76D7 27BF F62C D2B5")))))

(list
  (channel
    (name 'nonguix)
    (url "https://gitlab.com/nonguix/nonguix")
    (commit "5e698d7a0a116e97ceec1768c8b19866a573dabf")
    ;; Enable signature verification:
    (introduction
      (make-channel-introduction
        "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
        (openpgp-fingerprint
          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
  codeberg-channel
  )

