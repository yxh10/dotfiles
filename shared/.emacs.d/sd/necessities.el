;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; editing multiple lines/things
(autoload 'mc/edit-lines "multiple-cursors" nil t)
(autoload 'mc/add-cursor-on-click "multiple-cursors" nil t)
(autoload 'mc/mark-all-like-this-dwim "multiple-cursors" nil t)
(global-set-key (kbd "C-<return>") 'mc/edit-lines)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(global-set-key (kbd "C->") 'mc/mark-all-like-this-dwim)

;; better find-file
(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; rainbow parens
(autoload 'rainbow-delimiters-mode "rainbow-delimiters" nil t)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; paredit
(autoload 'enable-paredit-mode "paredit" nil t)
(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook           'enable-paredit-mode)

;; enable markdown
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

(defun sd/open-projects-dir ()
  (interactive)
  (find-file "~/projects"))

(global-set-key (kbd "C-x r b") 'sd/open-projects-dir)

(defun sd/choose-project ()
  (interactive)
  (let* ((long-filenames (directory-files "~/projects" t "^[^.]"))
         (short-filenames (mapcar 'file-name-nondirectory long-filenames))
         (chosen (ido-completing-read "History: " short-filenames))
         (full-chosen (concat "~/projects/" chosen)))
    (find-file full-chosen)))

(defun sd/choose-emacs-config-file ()
  (interactive)
  (let* ((long-filenames (directory-files (concat user-emacs-directory "sd") t "^[^.]"))
         (short-filenames (mapcar 'file-name-nondirectory long-filenames))
         (chosen (ido-completing-read "History: " short-filenames))
         (full-chosen (concat user-emacs-directory "sd/" chosen)))
    (find-file full-chosen)))

(global-set-key (kbd "C-c e") 'sd/choose-emacs-config-file)
(global-set-key (kbd "C-c p") 'sd/choose-project)

(defun sd/sudo-open ()
  (interactive)
  (find-file (concat "/sudo::" (ido-read-file-name "Sudo find file:"))))

(global-set-key (kbd "C-c C-f") 'sd/sudo-open)
