(defrecord route
  path
  func
  data)

(defrecord options
  output-dir)

(defrecord site
  (routes '())
  (opts 'undefined))
