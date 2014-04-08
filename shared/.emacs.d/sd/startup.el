;; theme
(setq custom-safe-themes t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; "customize"
(setq custom-file "~/.emacs.d/sd/custom.el")
(load custom-file)

;; startup stuff
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq initial-scratch-message "")
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message "sdegutis")


(setq default-frame-alist '((left-fringe . 0)
                            (right-fringe . 0)
                            (vertical-scroll-bars)))
;; defaults
(set-display-table-slot standard-display-table 0 ?~)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)
;; (global-hl-line-mode 1)
(delete-selection-mode 1)
(setq-default cursor-type 'box)
(fset 'yes-or-no-p 'y-or-n-p)
(blink-cursor-mode -1)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq ring-bell-function 'ignore)
(setq blink-matching-paren nil)
(setq scroll-conservatively 10000)     ;; makes scrolling smoother
(setq auto-window-vscroll nil)         ;; ditto
;; (setq scroll-margin 7)                 ;; these two lines seem to mess with eshell and probably
;; (setq scroll-step 1)                   ;; other stuff too. too bad, cuz they're so nice.

;; disable backup, auto-save, and lock files
(setq-default backup-inhibited t)
(setq-default auto-save-default nil)
(setq create-lockfiles nil)

;; prefer to split windows side by side
(setq split-height-threshold nil)
(setq split-width-threshold 200)

;; dont wrap lines when editing plain text
(add-hook 'text-mode-hook 'toggle-word-wrap)
(add-hook 'text-mode-hook 'toggle-truncate-lines)

;; M-{, M-} are rough on my left pinky
(global-set-key (kbd "s-k") 'backward-paragraph)
(global-set-key (kbd "s-j") 'forward-paragraph)

;; start at home
(setq default-directory (concat (getenv "HOME") "/"))

;; let me do advanced things
(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; auto-indent on <enter>
(add-hook 'prog-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline-and-indent)))

;; mode line
(setq-default mode-line-format '("%e" (:eval (list " %* " mode-line-buffer-identification
                                                   "  %3l  " (abbreviate-file-name default-directory)
                                                   " " mode-line-modes
                                                   " " mode-line-misc-info))))

;; trying to save my left pinky
(setq ns-right-command-modifier 'control)
(setq ns-command-modifier 'super)

;; join-line
(global-set-key (kbd "M-k") '(lambda () (interactive) (join-line 1)))

;; ambivalent
(global-set-key (kbd "s-K") '(lambda () (interactive) (kill-buffer)))

;; from macosx but generally useful
(global-unset-key (kbd "C-z"))    ;; stop minimizing
(global-unset-key (kbd "s-p"))    ;; stop asking to print
