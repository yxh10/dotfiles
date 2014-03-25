;; ido-mode
(require 'ido-ubiquitous)
(ido-mode 1)
(ido-ubiquitous-mode 1)
(setq ido-default-file-method 'selected-window)

;; ido-vertical-mode
(require 'ido-vertical-mode)
(ido-vertical-mode)

;; smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(setq smex-key-advice-ignore-menu-bar t) ;; maybe this speeds smex up?
