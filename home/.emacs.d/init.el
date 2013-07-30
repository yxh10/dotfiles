(require 'package)
(set 'package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)



;; disable backup and auto-save
(setq backup-inhibited t)
(setq auto-save-default nil)
(setq make-backup-files nil)
(auto-save-mode -1)
(setq create-lockfiles nil)




(require 'windsize)
(windsize-default-keybindings)




;; eshell
(add-hook 'eshell-mode-hook 'toggle-truncate-lines)
(add-hook 'eshell-preoutput-filter-functions 'ansi-color-apply)
(setq multi-eshell-shell-function '(eshell))
(setq multi-eshell-name "*eshell*")
(keydef "s-t" multi-eshell)

(defun sd/eshell-search-history ()
  (interactive)
  (insert (ido-completing-read "History: " (delete-dups (ring-elements eshell-history-ring)))))


;; remove Cmd-K binding
(keydef "s-k")


;; make Cmd-K clear eshell
(defun sd/clear-eshell-buffer ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))
(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "s-k") 'sd/clear-eshell-buffer)
            (define-key eshell-mode-map (kbd "M-r") 'sd/eshell-search-history)))



(setq ns-right-command-modifier 'super)
;; (setq ns-command-modifier 'control)


;; tagedit
(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))


;; make buffer names betterly unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-strip-common-suffix t)


;; load your favorite color theme here
(setq custom-safe-themes t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")


;; make use of vendor dir
(add-to-list 'load-path "~/.emacs.d/vendor/")


;; change file "customize" saves to. you can pretty much ignore this.
(setq custom-file "~/.emacs.d/my-custom.el")
(load custom-file)


;; ok fine
(set-display-table-slot standard-display-table 0 ?~)


(electric-indent-mode 1)                                 ;; makes Enter indent stuff intelligently
(setq-default indent-tabs-mode nil)                      ;; use spaces everywhere, not tabs
(setq-default truncate-lines t)                          ;; dont line-wrap
(setq require-final-newline t)                           ;; makes files always end with a newline
(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; delete trailing whitespace on save
;; (global-hl-line-mode 1)                                  ;; highlight current line
(delete-selection-mode 1)                                ;; makes typing or inserting over selected text delete it first
(setq inhibit-startup-echo-area-message user-login-name)      ;; put your username here
(setq-default cursor-type 'box)
(fset 'yes-or-no-p 'y-or-n-p)
(blink-cursor-mode -1)


;; utf8
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)


;; editing multiple lines/things
(require 'multiple-cursors)
(keydef "C-<return>" mc/edit-lines)
(keydef "C-S-<mouse-1>" mc/add-cursor-on-click)
(keydef "C->" mc/mark-all-like-this-dwim)


;; prefer to split windows side by side
(setq split-height-threshold nil)
(setq split-width-threshold 200)


;; dont wrap lines when editing plain text
(add-hook 'text-mode-hook 'toggle-word-wrap)
(add-hook 'text-mode-hook 'toggle-truncate-lines)


;; like Cmd-T, but only works inside version-controlled repos
(keydef "C-x f" find-file-in-repository)


;; rainbow parens
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
(require 'magit)
(keydef "s-G" magit-status)
(setq git-commit-confirm-commit nil) ;; comment this line out to let
                                     ;; emacs warn you that your
                                     ;; commit message is just awful

(keydef "s-C-g" (shell-command "open -agitx ."))
(keydef "s-T" (shell-command "open -aterminal ."))


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
(keydef "s-F" sd/git-grep)


;; buffer management
(keydef "s-[" previous-buffer)
(keydef "s-]" next-buffer)
(keydef "C-x C-b")
(keydef "s-{" (other-window -1))
(keydef "s-}" other-window)
(keydef "<C-s-up>"     buf-move-up)
(keydef "<C-s-down>"   buf-move-down)
(keydef "<C-s-left>"   buf-move-left)
(keydef "<C-s-right>"  buf-move-right)


;; ido-mode
(ido-mode 1)
(ido-ubiquitous-mode 1)
(ido-vertical-mode)
(setq ido-default-file-method 'selected-window)


;; smex
(smex-initialize)
(keydef "M-x" smex)
(keydef "M-X" smex-major-mode-commands)
(setq smex-key-advice-ignore-menu-bar t) ;; maybe this speeds smex up?


;; undo-tree
(global-undo-tree-mode)


;; when in mac os x
(when (equal window-system 'ns)
  (exec-path-from-shell-initialize)      ;; set $PATH properly
  (keydef "s-p")                         ;; stop asking to print
  (keydef "C-z")                         ;; stop minimizing
  (keydef "s-z" undo-tree-undo)
  (keydef "s-Z" undo-tree-redo)
  (setq locate-command "mdfind")         ;; use spotlight, not locate
  (set-face-font 'default "Menlo-12.0")) ;; use nice font


;; kinda like vim's J
(keydef "M-k" (join-line 1))


;; makes Cmd-Shift-N open a new window with a blank buffer
(defun sd/new-blank-bufer ()
  (interactive)
  (make-frame)
  (switch-to-buffer (generate-new-buffer-name "untitled"))
  (text-mode))
(keydef "s-N" sd/new-blank-bufer)


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
(auto-insert-mode) ;; for new .el files mainly



(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)



;; ;; M-{, M-} are a bit more awkward on my pinky
;; (keydef "C-s-[" backward-paragraph)
;; (keydef "C-s-]" forward-paragraph)


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
(add-to-list 'auto-mode-alist '("\\.hiccup\\'" . clojure-mode))
(define-clojure-indent
  (defroutes 'defun)
  (before 'defun)
  (routes 'defun)
  (describe 'defun)
  (before-all 'defun)
  (after-all 'defun)
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
