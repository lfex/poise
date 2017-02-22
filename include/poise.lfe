(defrecord route
  path
  func)

(defrecord options
  output-dir)

(defrecord site
  (routes '())
  (opts 'undefined))
