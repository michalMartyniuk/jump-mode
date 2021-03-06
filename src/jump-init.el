;; -*- lexical-binding: t -*-
(provide 'jump-init)

(defun jump-init (start-point build-func patterns rules)
  (interactive)
  (defvar jump-point-active)
  (defvar jump-rules)
  (defvar jump-start-point)
  (defvar jump-patterns)
  (defvar jump-points)
  (jump-reset)
  (setq jump-start-point start-point)
  (setq jump-patterns patterns)
  (setq jump-points nil)
  (jump-build-rules rules)
  (let ()
    (progn (evil-first-non-blank)
     (funcall build-func)
     (setq jump-points (patterns-to-fields jump-patterns))
     (goto-char (cdr (nth 0 jump-points)))
     (setq jump-point-active (car (nth 0 jump-points)))
     (jump-mode)
     (evil-insert-state)
    )
  )
)

(defun jump-reset ()
  (defvar jump-point-active)
  (defvar jump-rules)
  (defvar jump-start-point)
  (defvar jump-patterns)
  (setq jump-point-active nil)
  (setq jump-rules nil)
  (setq jump-start-point nil)
  (setq jump-patterns nil)
)


(defun patterns-to-fields (patterns)
  (defvar jump-start-point)
  (let ((fields) (current-point) (names) (jump-point) (jump-points))
    (setq current-point (point))
    (goto-char jump-start-point)
    (setq names (seq-map (lambda (el) (car el)) patterns))
    (setq fields (cl-mapcar (lambda (el)
                              (setq jump-point (re-search-forward (car (nthcdr 1 el))))
                              (unless (not (car (nthcdr 2 el)))
                                (setq jump-point (funcall (car (nthcdr 2 el))))
                              )
                              jump-point
                            ) patterns ))
    (setq jump-points (cl-mapcar 'cons names fields))
    (goto-char current-point)
    jump-points
  )
)


(defun jump-get-fields (assoc-list)
  (cl-mapcar (lambda (el) (cdr el)) assoc-list)
)

(defun jump-to-field (direction)
  (defvar jump-point-active)
  (defvar jump-patterns)
  (let* ((next)
        (prev)
        (lower)
        (higher)
        (jump-points (patterns-to-fields jump-patterns))
        (fields (jump-get-fields jump-points))
       )
    (cond
      ((string= direction "previous")
        (setq lower (seq-filter (lambda (el) (< el (point))) fields))
        (setq prev (seq-max lower))
        (goto-char prev)
        (setq jump-point-active (car (rassq prev jump-points)))
      )

      ((string= direction "next")
        (setq higher (seq-filter (lambda (el) (> el (point))) fields))
        (setq next (seq-min higher))
        (goto-char next)
        (setq jump-point-active (car (rassq next jump-points)))
      )
    )
  )
)

(defun jump-key-func (key)
  (interactive)
  (funcall (get-field-func jump-point-active key jump-rules))
)





;; Development/testing functions
(defun jump-to-next-point ()
  (interactive)
  (jump-to-field "next")
)

(defun jump-to-prev-point ()
  (interactive)
  (jump-to-field "previous")
)

(defun jump-get-names (assoc-list)
  (cl-mapcar (lambda (el) (car el)) assoc-list)
)

(defun jump-get-fields (assoc-list)
  (cl-mapcar (lambda (el) (cdr el)) assoc-list)
)


