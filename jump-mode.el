(provide 'jump-mode)

(setq load-path (cons "~/emacs/modes/jump-mode/src" load-path))
(setq load-path (cons "~/emacs/modes/jump-mode/src/jumps" load-path))

(require 'jump-init)
(require 'jump-mode-init)
(require 'jump-rules)

;; jumps
(require 'const-jump)
(require 'let-jump)
