;; -*- lexical-binding: t -*-
(provide 'let-jump)

(defun let-jump-init ()
  (interactive)
  (jump-init (point) 'let-jump-func (let-jump-patterns) (let-jump-rules-list))
)

(defun let-jump-patterns ()
'((variables ")\n"
    (lambda nil (backward-char 2) (point))
  )
  (body "\n\t"))
)

(defun let-jump-func ()
  (interactive)
  (insert "(let ()\n\t\n)")
)

(defun let-jump-rules-list ()
  '(
    (variables semicolon (lambda nil (jump-to-next-point)))
    (variables RET (lambda nil (insert "()") (backward-char)))
    (body semicolon (lambda nil (jump-to-prev-point)))
   )
)
