;; -*- lexical-binding: t -*-
(provide 'jump-init)

(defun jump-init (start-point build-func patterns rules)
  (interactive)
  (defvar update-fields '())
  (defvar jump-field-active)
  (defvar jump-rules)
  (setq jump-rules '())
  (jump-build-rules rules)
  (let ((names-fields))
    (progn (evil-first-non-blank)
     (funcall build-func)
     (setq update-fields (patterns-to-fields start-point patterns))
     (setq names-fields (funcall update-fields))
     (goto-char (cdr (nth 0 names-fields)))
     (setq jump-field-active (car (nth 0 names-fields)))
     (jump-mode)
    )
  )
)

(defun patterns-to-fields (start-point patterns)
  (let ((fields) (current-point) (names) (names-fields))
    (lambda ()
      (setq current-point (point))
      (goto-char start-point)
      (setq names (seq-map (lambda (el) (car el)) patterns))
      (setq fields (cl-mapcar (lambda (el)
                                (re-search-forward (car (cdr el)))
                              ) patterns ))
      (setq names-fields (cl-mapcar 'cons names fields))
      (goto-char current-point)
      names-fields)
  )
)

(defun jump-to-field (direction)
  (defvar update-fields)
  (defvar jump-field-active)
  (defvar jump-SPC)
  (defvar jump-RET)
  (let ((next)
        (prev)
        (lower)
        (higher)
        (fields)
        (names-fields)
        ;; (key-func-SPC (lambda (field-name) (get-field-func field-name 'SPC jump-rules)))
        ;; (key-func-RET (lambda (field-name) (get-field-func field-name 'RET jump-rules)))
        (get-fields (lambda (assoc-list) (cl-mapcar (lambda (el) (cdr el)) assoc-list)))
      )
    (setq names-fields (funcall update-fields))
    (setq fields (funcall get-fields names-fields))

    (cond
        ((string= direction "previous")
          (setq lower (seq-filter (lambda (el) (< el (point))) fields))
          (setq prev (seq-max lower))
          (goto-char prev)
          (setq jump-field-active (car (rassq prev names-fields)))
          ;; (setq jump-SPC (funcall key-func-SPC jump-field-active))
          ;; (setq jump-RET (funcall key-func-RET jump-field-active))
        )

        ((string= direction "next")
          (setq higher (seq-filter (lambda (el) (> el (point))) fields))
          (setq next (seq-min higher))
          (goto-char next)
          (setq jump-field-active (car (rassq next names-fields)))
          ;; (setq jump-SPC (funcall key-func-SPC jump-field-active))
          ;; (setq jump-RET (funcall key-func-RET jump-field-active))
        )
    )
  )
)

(defun jump-key-func (key)
  (interactive)
  (funcall (get-field-func jump-field-active key jump-rules))
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


