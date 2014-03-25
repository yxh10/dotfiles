;; this doesnt seem to do anything :/
(setq erc-server "irc.freenode.net"
      erc-port 6667
      erc-nick "sdegutis"
      erc-user-full-name "sdegutis"
      erc-email-userid "sdegutis"
      erc-prompt-for-password nil
      erc-hide-list '("JOIN" "PART" "QUIT")
      erc-auto-query 'window-noselect
      erc-current-nick-highlight-type 'all)

(autoload 'erc "erc" nil t)
(eval-after-load 'erc
  '(progn
     (require 'erc-hl-nicks)))
