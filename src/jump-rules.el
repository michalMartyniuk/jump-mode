;; -*- lexical-binding: t -*-
(provide 'jump-rules)

(defun jump-build-rules (rules-list)
  (mapcar (lambda (el) (apply 'jump-add-rule el)) rules-list)
)

(defun jump-add-rule (field-name key rule)
  (defvar jump-rules)
  ;;; Add field with rules if it doesn't exist, update otherwise.
  (let ((updated-field) (updated-rules))
    (setq updated-field (jump-update-field field-name key rule jump-rules))
    (setq updated-rules (jump-update-rules updated-field jump-rules))
    (setq jump-rules updated-rules)
  )
)

(defun jump-update-field (field-name key rule rules)
  (let ((updated-field)
        (field-rules)
        (get-field-rules (lambda (field-name rules) (cdr (assoc field-name rules))))
        (create-field
          (lambda (field-name field-rules) (append `(,field-name) field-rules))
        )
        (update-field-rules)
       )
      (setq update-field-rules (lambda (key rule field-rules)
          (let ((remove-rule) (insert-rule))
            (setq remove-rule (lambda (key rules)
              (seq-remove (lambda (el) (eq key (car el))) rules)))
            (setq insert-rule (lambda (key rule rules)
              (append rules `((,key . ,rule)))))

            ;;; remove old rule from rules
            (setq field-rules (funcall remove-rule key field-rules))
            ;;; add new rule to rules
            (setq field-rules (funcall insert-rule key rule field-rules))
          )
        )
      )
      ;;;get field rules
      (setq field-rules (funcall get-field-rules field-name rules))
      ;;; create updated field-rules - remove old rule and insert new
      (setq field-rules (funcall update-field-rules key rule field-rules))
      ;;; create updated field
      (setq updated-field (funcall create-field field-name field-rules))
  )
)

(defun jump-update-rules (updated-field rules)
  (let* (
    (updated-rules)
    (field-name)
    (remove-field (lambda (field-name rules)
        (seq-remove (lambda (el) (eq field-name (car el))) rules)))
        (add-field (lambda (new-field rules) (append  rules `(,new-field)))))

    (setq field-name (car updated-field))
    ;;; remove old field from rules
    (setq updated-rules (funcall remove-field field-name rules))
    ;;; add new updated field to rules
    (setq updated-rules (funcall add-field updated-field updated-rules))
  )
)

(defun get-field-rules (field-name rules) (cdr (assoc field-name rules)))

(defun get-field-func (field-name key rules)
  (cdr (assoc key (get-field-rules field-name rules)))
)

(defun jump-rule-exists (field-name key rules)
  (let ((field-rules))
    (setq field-rules (get-field-rules field-name rules))
    (seq-filter (lambda (el) (eq key (car el))) field-rules)
  )
)



