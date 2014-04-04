(when (equal window-system 'ns)
  (require 'rbenv)
  (global-rbenv-mode 1)
  (setq rbenv-executable "/usr/local/bin/rbenv"))
