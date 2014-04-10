;; when in mac os x
(when (equal window-system 'ns)
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize) ;; set $PATH properly
  (global-unset-key (kbd "s-p"))    ;; stop asking to print
  (global-set-key (kbd "s-z") 'undo-tree-undo)
  (global-set-key (kbd "s-Z") 'undo-tree-redo)
  (setq locate-command "mdfind")         ;; use spotlight, not locate
  (set-face-font 'default "Menlo-12.0")  ;; use nice font

  ;; buffer management
  (global-set-key (kbd "s-[") 'previous-buffer)
  (global-set-key (kbd "s-]") 'next-buffer)
  (global-unset-key (kbd "C-x C-b"))
  (global-set-key (kbd "s-{") '(lambda () (interactive) (other-window -1)))
  (global-set-key (kbd "s-}") 'other-window)
  (global-set-key (kbd "<C-s-up>")     'buf-move-up)
  (global-set-key (kbd "<C-s-down>")   'buf-move-down)
  (global-set-key (kbd "<C-s-left>")   'buf-move-left)
  (global-set-key (kbd "<C-s-right>")  'buf-move-right)

  ;; makes Cmd-Shift-N open a new window with a blank buffer
  (global-set-key (kbd "s-N") 'sd/new-blank-bufer))



;; when in arch linux
(when (equal window-system 'x)
  (setq mouse-autoselect-window t)

  ;; buffer management
  (global-set-key (kbd "M-[") 'previous-buffer)
  (global-set-key (kbd "M-]") 'next-buffer)
  (global-unset-key (kbd "C-x C-b"))
  (global-set-key (kbd "C-M-[") '(lambda () (interactive) (other-window -1)))
  (global-set-key (kbd "C-M-]") 'other-window)
  ;; (global-set-key (kbd "<C-s-up>")     'buf-move-up)
  ;; (global-set-key (kbd "<C-s-down>")   'buf-move-down)
  ;; (global-set-key (kbd "<C-s-left>")   'buf-move-left)
  ;; (global-set-key (kbd "<C-s-right>")  'buf-move-right)

  (global-set-key (kbd "C-c g") 'magit-status))
