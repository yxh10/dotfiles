;; resize buffers
(require 'windsize)
(windsize-default-keybindings)

;; make buffer names betterly unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-strip-common-suffix t)

(defun sd/new-blank-bufer ()
  (interactive)
  (make-frame)
  (switch-to-buffer (generate-new-buffer-name "untitled"))
  (text-mode))

(autoload 'buf-move-up "buffer-move" nil t)
(autoload 'buf-move-down "buffer-move" nil t)
(autoload 'buf-move-left "buffer-move" nil t)
(autoload 'buf-move-right "buffer-move" nil t)
