;; -*- lexical-binding: t -*-
(provide 'let-jump)

(defun let-jump-init ()
  (interactive)
  (jump-init (point) 'let-jump-func (let-jump-patterns) (let-jump-rules-list))
)

(defun let-jump-patterns ()
'((variables "(elo)" (lambda nil (print "siema")))
  (body "\n\t lsdkfjsdl" (lambda nil (print "siema dwa"))))
)

;; (funcall (tt-patterns (let-jump-patterns)))

(defun tt-patterns (patterns)
  (let ()
    (lambda ()
      ;; (setq names (seq-map (lambda (el) (car el)) patterns))
    (cl-mapcar (lambda (el) (car (nthcdr 1 el))) patterns )
      ;; (setq names-fields (cl-mapcar 'cons names fields)
    )
  )
)

(defun let-jump-func ()
  (interactive)
  (insert "(let ()\n\t\n)")
)


(defun let-jump-rules-list ()
  '((variables SPC (lambda nil (jump-to-next-point)))
    (variables RET (lambda nil (insert "()") (backward-char)))
   )
)
