(provide 'jump-mode-init)

(setq jump-mode-abbrev-table nil)

;; MODE-MAP
(defvar jump-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "SPC") 'jump-mode-SPC)
    (define-key map (kbd "RET") 'jump-mode-RET)
  map)
)

(defvar jump-mode-hook nil)

;; MODE-ABBREVS
(define-abbrev-table 'jump-mode-abbrev-table
   '(
  ;;   (abbrevname expansion hook props)
    )
)

;; MODE-INIT

(defun jump-mode-SPC ()
  (interactive)
  (jump-key-func 'SPC)
)

(defun jump-mode-RET ()
  (interactive)
  (jump-key-func 'RET)
)

(define-derived-mode jump-mode emacs-lisp-mode "jump-mode"
  "Jump mode"
  (abbrev-mode 1)
  :lighter "jump-mode"
  :abbrev-table jump-mode-abbrev-table
  (evil-intercept-keymap-p jump-mode-map)
)

