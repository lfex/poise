(defmodule sploder
  (export all))

(include-lib "logjam/include/logjam.hrl")

;;; mdSplode shell commands

(defun banner ()
  (poise:raw "banner"))

(defun echo (msg)
  (poise:raw (++ "echo " msg)))

(defun help ()
  (poise:raw "help"))

(defun history ()
  (poise:raw "history"))

(defun ping ()
  (poise:raw "ping"))

(defun query (q-str)
  (poise:raw (++ "query " q-str)))

(defun read (type file)
  (poise:raw (++ "read " type " " file)))

(defun show (cmd)
  (poise:raw (++ "show " cmd)))

(defun version ()
  (poise:raw "version"))
