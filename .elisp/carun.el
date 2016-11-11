(defun carun-string-join (delim lst)
  (concat (car lst)
          (if (null (cdr lst)) ""
            (concat delim
                    (carun-string-join delim (cdr lst))))))

(defun carun-string-matches-internal (str n)
  (if (not (match-beginning n))
      ()
    (cons (substring str (match-beginning n) (match-end n))
          (carun-string-matches-internal str (+ n 1)))))

(defun carun-string-matches (match str)
  (if (not (string-match match str))
      ()
    (cons str
          (carun-string-matches-internal str 1))))

(defvar carun-command nil)
(defun carun-shell-command ()
  (shell-command carun-command "*Shell Command Output*" nil)
  (run-with-timer 1.0 nil
                  'delete-window
                  (get-buffer-window "*Shell Command Output*" t)))
 
(defun carun-exec ()
  (interactive)
  (let* ((carun-names (carun-string-matches "\\([^/]+\\)\\.\\([^\\.]+\\)$"
                                (buffer-file-name)))
         (carun-file (nth 1 carun-names))
         (carun-ext (nth 2 carun-names))
         (carun-comm (if carun-file (concat "./" carun-file) ""))
         (carun-read (read-string
                      "run-command: "
                      (if (not carun-command) carun-comm carun-command))))
    (setq carun-command carun-read)
    (carun-shell-command)))

(defun carun-exec-retry ()
  (interactive)
  (if (not carun-command)
      (carun-exec)
    (carun-shell-command)))

(provide 'carun)
