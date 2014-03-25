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
;; (global-hl-line-mode 1)                                     ;; highlight current line
(delete-selection-mode 1)                                   ;; makes typing or inserting over selected text delete it first
(setq inhibit-startup-echo-area-message "sdegutis")
(setq-default cursor-type 'box)
(fset 'yes-or-no-p 'y-or-n-p)
(blink-cursor-mode -1)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; disable backup, auto-save, and lock files
(setq-default backup-inhibited t)
(setq-default auto-save-default nil)
(setq create-lockfiles nil)

;; start at home
(setq default-directory (concat (getenv "HOME") "/"))

;; auto-indent on <enter>
(add-hook 'prog-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline-and-indent)))

;; erc
(require 'erc)
(setq erc-hide-list '("JOIN" "PART" "QUIT"))
(setq erc-auto-query 'window-noselect)
(require 'erc-hl-nicks)

;; resize buffers
(require 'windsize)
(windsize-default-keybindings)

;; eshell
(add-hook 'eshell-mode-hook 'toggle-truncate-lines)
(add-hook 'eshell-preoutput-filter-functions 'ansi-color-apply)
(global-set-key (kbd "s-t") 'sd/open-new-eshell)
(autoload 'chruby "chruby")

(defun sd/open-new-eshell ()
  (interactive)
  (eshell 'ignored-value))

(defun sd/eshell-search-history ()
  (interactive)
  (insert (ido-completing-read "History: " (delete-dups (ring-elements eshell-history-ring)))))


;; remove Cmd-K binding
(global-unset-key (kbd "s-k"))


;; make Cmd-K clear eshell
(defun sd/clear-eshell-buffer ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "s-k") 'sd/clear-eshell-buffer)
            (define-key eshell-mode-map (kbd "M-r") 'sd/eshell-search-history)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (setq pcomplete-cycle-completions nil)))


;; TODO: I know I should be using the right-command button for stuff
;;       to save my left pinky, but it's a difficult and awkward habit
;;       to get into.

;; (setq ns-right-command-modifier 'super)
;; (setq ns-command-modifier 'control)



;; make buffer names betterly unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-strip-common-suffix t)


;; editing multiple lines/things
(require 'multiple-cursors)
(global-set-key (kbd "C-<return>") 'mc/edit-lines)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(global-set-key (kbd "C->") 'mc/mark-all-like-this-dwim)


;; prefer to split windows side by side
(setq split-height-threshold nil)
(setq split-width-threshold 200)


;; dont wrap lines when editing plain text
(add-hook 'text-mode-hook 'toggle-word-wrap)
(add-hook 'text-mode-hook 'toggle-truncate-lines)


;; like Cmd-T, but only works inside version-controlled repos
(global-set-key (kbd "C-x f") 'find-file-in-repository)



;; rainbow parens
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)

;; paredit
(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook           'enable-paredit-mode)


;; git integration. use Cmd-Shift-G to open it.
(add-to-list 'load-path "~/.emacs.d/vendor/magit/")
(require 'magit)
(global-set-key (kbd "s-G") 'magit-status)
(setq git-commit-confirm-commit nil)


;; shortcuts for my convenience
(global-set-key (kbd "s-C-g") '(lambda () (interactive) (shell-command "open -agitx .")))
(global-set-key (kbd "s-T")   '(lambda () (interactive) (shell-command "open -aterminal .")))


;; git grep
(defun sd/git-grep (regexp &optional files)
  (interactive
   (progn
     (grep-compute-defaults)
     (let* ((regexp (grep-read-regexp))
            (files (grep-read-files regexp)))
       (list regexp files))))
  (when (and (stringp regexp) (> (length regexp) 0))
    (require 'grep)
    (let ((command (grep-expand-template "git --no-pager grep --untracked -n -e <R> -- '<F>'" regexp files))
          (default-directory (magit-get-top-dir default-directory)))
      (add-to-history 'grep-history command)
      (compilation-start command 'grep-mode))))
(global-set-key (kbd "s-F") 'sd/git-grep)




;; buffer management
(require 'buffer-move)
(global-set-key (kbd "s-[") 'previous-buffer)
(global-set-key (kbd "s-]") 'next-buffer)
(global-unset-key (kbd "C-x C-b"))
(global-set-key (kbd "s-{") '(lambda () (interactive) (other-window -1)))
(global-set-key (kbd "s-}") 'other-window)
(global-set-key (kbd "<C-s-up>")     'buf-move-up)
(global-set-key (kbd "<C-s-down>")   'buf-move-down)
(global-set-key (kbd "<C-s-left>")   'buf-move-left)
(global-set-key (kbd "<C-s-right>")  'buf-move-right)




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



;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)


;; when in mac os x
(when (equal window-system 'ns)
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize) ;; set $PATH properly
  (global-unset-key (kbd "s-p"))    ;; stop asking to print
  (global-unset-key (kbd "C-z"))    ;; stop minimizing
  (global-set-key (kbd "s-z") 'undo-tree-undo)
  (global-set-key (kbd "s-Z") 'undo-tree-redo)
  (setq locate-command "mdfind")         ;; use spotlight, not locate
  (set-face-font 'default "Menlo-12.0")) ;; use nice font


;; kinda like vim's J
(global-set-key (kbd "M-k") '(lambda () (interactive) (join-line 1)))


;; makes Cmd-Shift-N open a new window with a blank buffer
(defun sd/new-blank-bufer ()
  (interactive)
  (make-frame)
  (switch-to-buffer (generate-new-buffer-name "untitled"))
  (text-mode))
(global-set-key (kbd "s-N") 'sd/new-blank-bufer)


;; enable markdown
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))


;; these just give emacs sane defaults. you can pretty much ignore them:
(require 'dired-x) ;; for C-x C-j
(fringe-mode 0)
(setq initial-scratch-message "")
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq-default dired-auto-revert-buffer t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)                   ;; makes emacs stop beeping at you
(setq blink-matching-paren nil)                     ;; rainbow-parens makes this useless
(setq scroll-conservatively 10000)                  ;; makes scrolling smoother
(setq auto-window-vscroll nil)                      ;; ditto
;; (setq scroll-margin 7)                           ;; might be useful but i found it slightly buggy
;; (setq scroll-step 1)                             ;; ditto
(setq vc-follow-symlinks t)                         ;; so git doesn't have to ask to follow symlinks
(setq-default dired-use-ls-dired nil)               ;; mac's ls doesnt support --dired
(setq bookmark-sort-flag nil)



(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)



;; ;; M-{, M-} are a bit more awkward on my pinky
;; (global-set-key (kbd "C-s-[") backward-paragraph)
;; (global-set-key (kbd "C-s-]") forward-paragraph)


;; show only useful info in mode line
(setq-default mode-line-format '("%e"
                                 (:eval
                                  (list
                                   " %* "
                                   mode-line-buffer-identification
                                   "  %3l  "
                                   (abbreviate-file-name default-directory)
                                   " "
                                   mode-line-modes
                                   " "
                                   mode-line-misc-info))))


;; clojure stuff
(require 'clojure-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(define-clojure-indent
  (defroutes 'defun)
  (routes 'defun)
  (describe 'defun)
  (at-media 'defun)
  (around 'defun)
  (it 'defun)
  (list 'defun)
  (cond 'defun)
  (:use nil)
  (:require nil)
  (:import nil)
  (GET 2)
  (POST 2)
  (PUT 2)
  (DELETE 2)
  (HEAD 2)
  (ANY 2)
  (context 1))


(eshell)
