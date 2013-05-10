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


(keydef "C-c d" dash-at-point)


(defun sd/disable-electric-indent ()
  (set (make-local-variable 'electric-indent-functions)
       (list (lambda (arg) 'no-indent))))

;; fix electric indent in certain modes
(setq coffee-tab-width 2)
(add-hook 'coffee-mode-hook 'sd/disable-electric-indent)
(add-hook 'org-mode-hook 'sd/disable-electric-indent)
(add-hook 'markdown-mode-hook 'sd/disable-electric-indent)


;; js
(setq js3-indent-level 2)
(setq js3-auto-indent-p nil)


;; (require 'lein)
;; (setq lein-version "2.1.0")


;; search for word at point
;; (keydef "s-h" highlight-symbol-at-point)
;; (keydef "M-p" highlight-symbol-prev)
;; (keydef "M-n" highlight-symbol-next)


;; ;; search for word at point
;; (defun current-word-search ()
;;   "search forward for word under cursor"
;;   (interactive)
;;   (word-search-forward (current-word)))
;; (defun current-word-reverse-search ()
;;     "search backwards for word under cursor"
;;     (interactive)
;;     (word-search-backward (current-word)))
;; (keydef "s-s" current-word-search)
;; (keydef "s-r" current-word-reverse-search)


;; eshell
(add-hook 'eshell-mode-hook 'toggle-truncate-lines)
(add-hook 'eshell-preoutput-filter-functions 'ansi-color-apply)
(setq multi-eshell-shell-function '(eshell))
(setq multi-eshell-name "*eshell*")
(keydef "s-t" multi-eshell)

(defun sd/eshell-search-history ()
  (interactive)
  (insert (ido-completing-read "History: " (delete-dups (ring-elements eshell-history-ring)))))


;; fullscreen
(setq ns-use-native-fullscreen nil)
;; (keydef "s-F" toggle-frame-fullscreen)


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



;; separate OS X pasteboard from emacs kill-ring
;; (simpleclip-mode 1)


;; different keys
;; (setq ns-command-modifier   'meta
;;       ns-alternate-modifier 'super
;;       ns-function-modifier  'hyper)
(setq ns-right-command-modifier 'meta)


;; make current window dedicated
(defun toggle-current-window-dedication ()
  (interactive)
  (let* ((window    (selected-window))
         (dedicated (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated))
    (message "Window %sdedicated to %s"
             (if dedicated "no longer " "")
             (buffer-name))))
(keydef "s-S" toggle-current-window-dedication)


;; tagedit
(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))


;; ;; easier
;; (require 'browse-kill-ring)
;; (browse-kill-ring-default-keybindings)


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


;; you might want to change some of these:
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


;; this makes Cmd-Forwardslash comment or uncomment a line without having to highlight it
(defun sd/comment-or-uncomment-region-or-line ()
  (interactive)
  (if mark-active
      (call-interactively (function comment-or-uncomment-region))
    (save-excursion
      (beginning-of-line)
      (set-mark (point))
      (end-of-line)
      (call-interactively (function comment-or-uncomment-region)))))
(keydef "s-/" sd/comment-or-uncomment-region-or-line)


;; paredit
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))


;; auto-pair puncutation
;; (require 'autopair)
;; (defun sd/conditionally-enable-autopair-mode ()
;;   (run-at-time "0.1 sec" nil (lambda ()
;;                                (unless paredit-mode
;;                                  (autopair-mode)))))
;; (add-hook 'text-mode-hook 'sd/conditionally-enable-autopair-mode)


;; kinda like nerdtree
;; (require 'sr-speedbar)
;; (keydef "s-D" sr-speedbar-toggle)
;; (setq sr-speedbar-right-side nil)
;; (setq speedbar-show-unknown-files t)
;; (setq sr-speedbar-auto-refresh nil)


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


;; project management
;; (require 'project-buffers)
;; (keydef "C-x b" pb/switch-buffer-in-project)
;; (keydef "C-x C-b" ido-switch-buffer)
;; (keydef "C-x C-p" pb/switch-project)
(keydef "s-[" previous-buffer)
(keydef "s-]" next-buffer)
(keydef "C-x C-b")
;; (keydef "s-[" pb/previous-buffer-in-project)
;; (keydef "s-]" pb/next-buffer-in-project)

;; buffer management
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
  (-> 'defun)
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

;; clojure speclj stuff
(require 'clojure-test-mode)

(defcustom clojure-mode-test-dir-name "spec"
  "Usually 'test' but for speclj it should be 'spec'"
  :type 'string
  :group 'clojure-mode)

(defcustom clojure-mode-test-namespace-suffix "spec"
  "Usually 'test' but for speclj it should be 'spec'"
  :type 'string
  :group 'clojure-mode)

(defun clojure-in-tests-p ()
  (or (string-match-p (concat clojure-mode-test-namespace-suffix "\.") (clojure-find-ns))
      (string-match-p (concat "/" clojure-mode-test-dir-name) (buffer-file-name))))

(defun clojure-test-for (namespace)
  "Returns the path of the test file for the given namespace."
  (let* ((namespace (clojure-underscores-for-hyphens namespace))
         (segments (split-string namespace "\\.")))
    (format "%s%s/%s_%s.clj"
            (file-name-as-directory
             (locate-dominating-file buffer-file-name "src/"))
            clojure-mode-test-dir-name
            (mapconcat 'identity segments "/")
            clojure-mode-test-namespace-suffix)))





;; etags
;; (defun sd/jump-to-tag ()
;;   (interactive)
;;   (let* ((default-directory (locate-dominating-file default-directory ".git"))
;;          (tags-file-name "TAGS")
;;          (tags-table-list '("TAGS"))
;;          (tags-revert-without-query t)
;;          (shell-command "ctags -eR --langmap=Lisp:+.clj"))
;;     (call-interactively 'find-tag)))
;; (keydef "M-." sd/jump-to-tag)

(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
