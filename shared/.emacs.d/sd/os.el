;; when in mac os x
(when (equal window-system 'ns)
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize) ;; set $PATH properly
  (global-unset-key (kbd "s-p"))    ;; stop asking to print
  (global-set-key (kbd "s-z") 'undo-tree-undo)
  (global-set-key (kbd "s-Z") 'undo-tree-redo)
  (setq locate-command "mdfind")         ;; use spotlight, not locate
  (set-face-font 'default "Menlo-12.0")) ;; use nice font

(when (equal window-system 'x)
  (setq mouse-autoselect-window t))
