(defmodule poise
  (export all))

(include-lib "poise/include/poise.lfe")

(defun site (route-map opts-map)
  ;; XXX convert route-map to records
  ;; XXX convert opts-map to record
  ;; XXX feed both into site record
  )

(defun generate (((match-site routes routes opts opts)))
  ;; XXX extract config options from opts, in particular, the output directory
  ;; XXX iterate items in routes map
  'TBD)
