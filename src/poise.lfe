(defmodule poise
  (export all))

(include-lib "poise/include/poise.lfe")

(defun generate (((match-site routes routes opts opts)))
  ;; extract config options from opts, in particular, the output directory
  ;; XXX iterate items in routes map
  'TBD)
