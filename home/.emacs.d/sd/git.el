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

;; bind git-grep to Cmd-Shift-F
(global-set-key (kbd "s-F") 'sd/git-grep)

;; so git doesn't have to ask to follow symlinks
(setq vc-follow-symlinks t)
