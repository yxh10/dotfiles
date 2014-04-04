(add-hook 'eshell-mode-hook 'toggle-truncate-lines)
(add-hook 'eshell-preoutput-filter-functions 'ansi-color-apply)

(setq eshell-banner-message "ready.\n")

(defun sd/open-new-eshell-here ()
  (interactive)
  (eshell 'ignored-value))

(defun sd/open-new-eshell-at-project-root ()
  (interactive)
  (let ((default-directory (or (magit-get-top-dir default-directory)
                               default-directory)))
    (eshell 'ignored-value)))

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

(global-set-key (kbd "s-y") 'sd/open-new-eshell-here)
(global-set-key (kbd "s-t") 'sd/open-new-eshell-at-project-root)

(setq eshell-prompt-function (lambda ()
                               (concat
                                "\n"
                                (abbreviate-file-name
                                 (eshell/pwd))
                                (if (= (user-uid) 0) " # " " $ "))))
