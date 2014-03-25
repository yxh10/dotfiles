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

;; makes Cmd-Shift-N open a new window with a blank buffer
(defun sd/new-blank-bufer ()
  (interactive)
  (make-frame)
  (switch-to-buffer (generate-new-buffer-name "untitled"))
  (text-mode))
(global-set-key (kbd "s-N") 'sd/new-blank-bufer)
