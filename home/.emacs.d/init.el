(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; vendor
(add-to-list 'load-path "~/.emacs.d/vendor/")

;; theme
(setq custom-safe-themes t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; "customize"
(setq custom-file "~/.emacs.d/my-custom.el")
(load custom-file)

;; defaults
(set-display-table-slot standard-display-table 0 ?~)
(setq require-final-newline t)
(setq-default indent-tabs-mode nil)                         ;; use spaces everywhere, not tabs
(setq-default truncate-lines t)                             ;; dont line-wrap
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(global-hl-line-mode 1)                                     ;; highlight current line
(delete-selection-mode 1)                                   ;; makes typing or inserting over selected text delete it first
(setq inhibit-startup-echo-area-message "sdegutis")
(setq-default cursor-type 'box)
(fset 'yes-or-no-p 'y-or-n-p)
(blink-cursor-mode -1)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; more defaults
(require 'dired-x) ;; for C-x C-j
(fringe-mode 0)
(setq initial-scratch-message "")
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq-default dired-auto-revert-buffer t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)      ;; stop beeping at me
(setq blink-matching-paren nil)        ;; rainbow-parens makes this useless
(setq scroll-conservatively 10000)     ;; makes scrolling smoother
(setq auto-window-vscroll nil)         ;; ditto
;; (setq scroll-margin 7)              ;; might be useful but i found it slightly buggy
;; (setq scroll-step 1)                ;; ditto
(setq vc-follow-symlinks t)            ;; so git doesn't have to ask to follow symlinks
(setq-default dired-use-ls-dired nil)  ;; apple's ls doesnt support --dired
(setq bookmark-sort-flag nil)

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

;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; auto-indent on <enter>
(add-hook 'prog-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline-and-indent)))

;; show only useful info in mode line
(setq-default mode-line-format '("%e" (:eval (list " %* " mode-line-buffer-identification
                                                   "  %3l  " (abbreviate-file-name default-directory)
                                                   " " mode-line-modes
                                                   " " mode-line-misc-info))))

;; load my init files
(mapc 'load (directory-files (concat user-emacs-directory user-login-name) t "^[^#].*el$"))

;; resize buffers
(require 'windsize)
(windsize-default-keybindings)

;; trying to save my left pinky
(setq ns-right-command-modifier 'control)
(setq ns-command-modifier 'super)

;; make buffer names betterly unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-strip-common-suffix t)

;; editing multiple lines/things
(require 'multiple-cursors)
(global-set-key (kbd "C-<return>") 'mc/edit-lines)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(global-set-key (kbd "C->") 'mc/mark-all-like-this-dwim)

;; like Cmd-T, but only works inside version-controlled repos
(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; rainbow parens
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; paredit
(autoload 'enable-paredit-mode "paredit" nil t)
(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook           'enable-paredit-mode)

;; kinda like vim's J
(global-set-key (kbd "M-k") '(lambda () (interactive) (join-line 1)))

;; enable markdown
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

(find-file "~/projects")
