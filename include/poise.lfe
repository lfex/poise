(defrecord route
  path
  function)

(defrecord options
  output-dir)

(defrecord site
  (routes '())
  (opts 'undefined)
