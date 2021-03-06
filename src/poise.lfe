(defmodule poise
  (export all))

(include-lib "poise/include/poise.lfe")

(defun site (route-list opts-map)
  (make-site
    routes (lists:map (match-lambda ((`(,p ,f))
                        (make-route path p func f)))
                      route-list)
    opts (make-options output-dir
                       (maps:get 'output-dir opts-map))))

(defun generate-route
  ((output-dir (match-route path path func func))
    (let ((filename (filename:join output-dir path)))
      (filelib:ensure_dir filename)
      (case (file:write_file filename (list_to_binary (funcall func)))
        ('ok (io:format "Created ~s.~n" `(,filename)))))))

(defun generate
  (((= (match-site
         routes routes
         opts (= (match-options
                   output-dir output-dir) opts)) data))
  (lists:map (lambda (x) (generate-route output-dir x)) routes)
  'ok))

;; XXX See if we can get this one working:
; (defmodule poise
;   (export all))

; (include-lib "poise/include/poise.lfe")

; (defun site (route-list opts-map)
;   (make-site
;     routes (lists:map (match-lambda
;                         ((`(,p ,f)) (when (is_function f))
;                           (make-route path p func f))
;                         ((`(,p ,d))
;                           (make-route path p data d)))
;                       route-list)
;     opts (make-options output-dir
;                        (maps:get 'output-dir opts-map))))

; (defun generate-route
;   ((output-dir (match-route path path func func)) (when (is_function func))
;     (generate-route
;       output-dir
;       (make-route path path data (funcall func))))
;   ((output-dir (match-route path path data data))
;     (let ((filename (filename:join output-dir path)))
;       (filelib:ensure_dir filename)
;       (case (file:write_file filename (list_to_binary data))
;         ('ok (io:format "Created ~s.~n" `(,filename)))
;         (err err)))))

; (defun generate
;   (((= (match-site
;          routes routes
;          opts (= (match-options
;                    output-dir output-dir) opts)) data))
;   (lists:map (lambda (x) (generate-route output-dir x)) routes)
;   'ok))
