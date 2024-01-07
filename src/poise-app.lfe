(defmodule poise-app
  (behaviour application)
  ;; app implementation
  (export
   (start 2)
   (stop 1)))

(include-lib "logjam/include/logjam.hrl")

;;; --------------------------
;;; application implementation
;;; --------------------------

(defun start (_type _args)
  (logger:set_application_level 'poise 'info)
  (logjam:set-dev-config)
  (log-info "Starting poise application ...")
  (poise-sup:start_link))

(defun stop (_state)
  (poise-sup:stop)
  'ok)
