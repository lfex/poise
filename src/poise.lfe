(defmodule poise
  ;; Convenience wrappers
  (export
   (start 0)
   (stop 0))
  ;; Plottah API
  ;;(export
  ;; )
  ;; Debug
  (export
   (echo 1)
   (pid 0)
   (ping 0)
   (raw 1)
   (state 0)))

(include-lib "poise/include/poise.lfe")
(include-lib "logjam/include/logjam.hrl")

;;; Constants

(defun APP () 'poise)
(defun SERVER () 'poise-svr)
;;(defun default-ms-delay () 100)
;;(defun default-ms-long-delay () 1000)

;;; Convenience wrappers

(defun start () (application:ensure_all_started (APP)))
(defun stop () (application:stop (APP)))

;;; Poise API

;; TBD

;;; Debug

(defun echo (msg)
  (gen_server:call (SERVER) `#(cmd echo ,msg)))

(defun pid ()
  (erlang:whereis (SERVER)))

(defun ping ()
  (gen_server:call (SERVER) `#(cmd ping)))

(defun state ()
  (gen_server:call (SERVER) `#(cmd state)))

(defun raw (raw-cmd)
  (gen_server:call (SERVER) `#(cmd mdsplode ,raw-cmd)))
