;;;; This poise module, unlike the other one, doesn't use records (except
;;;; in matching options). Additionally, the equipoise module doesn't support
;;;; passed functions, only passed data.
(defmodule equipoise
  (export all))

(defun generate-route
  ((output-dir `(,path ,data))
    (let ((filename (filename:join output-dir path)))
      (filelib:ensure_dir filename)
      (case (file:write_file filename data)
        ('ok (io:format "Created ~s.~n" `(,filename)))
        (err err)))))

(defun generate
  ((routes `#m(output-dir ,o))
    (lists:map (lambda (x) (generate-route o x)) routes)
    'ok))
