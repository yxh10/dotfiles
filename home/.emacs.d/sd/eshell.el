(add-hook 'eshell-mode-hook 'toggle-truncate-lines)
(add-hook 'eshell-preoutput-filter-functions 'ansi-color-apply)
(autoload 'chruby "chruby")

(defun sd/open-new-eshell ()
  (interactive)
  (eshell 'ignored-value))
(global-set-key (kbd "s-t") 'sd/open-new-eshell)

(defun sd/eshell-search-history ()
  (interactive)
  (insert (ido-completing-read "History: " (delete-dups (ring-elements eshell-history-ring)))))

;; make Cmd-K clear eshell
(defun sd/clear-eshell-buffer ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "s-k") 'sd/clear-eshell-buffer)
            (define-key eshell-mode-map (kbd "M-r") 'sd/eshell-search-history)
            (setq pcomplete-cycle-completions nil)))
