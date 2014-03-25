(setq erc-hide-list '("JOIN" "PART" "QUIT")
      erc-auto-query 'window-noselect)

(autoload 'erc "erc" nil t)
(eval-after-load 'erc
  '(progn
     (require 'erc-hl-nicks)))
