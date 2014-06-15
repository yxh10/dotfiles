(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; vendor
(add-to-list 'load-path "~/.emacs.d/vendor/")
(add-to-list 'load-path "~/.emacs.d/")

;; boot
(load "sd/startup")
(load "sd/necessities")
(load "sd/buffers")
(load "sd/clojure")
(load "sd/dired")
(load "sd/irc")
(load "sd/eshell")
(load "sd/git")
(load "sd/ido")
(load "sd/ruby")
(load "sd/os")
(load "sd/lua")

;; start in projects
(sd/open-projects-dir)
