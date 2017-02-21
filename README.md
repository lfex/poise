# poise

[![][project-logo]][project-logo-source]

*An LFE Library for the Framework-agnostic Generation of Static HTML Content*


## About

<em><strong>poise</strong></em>, n. <sup>[1](#footnote1)</sup>

1. a stably balanced state; equilibrium
1. easy self-possessed assurance of manner; gracious tact in coping or
   handling; the pleasantly tranquil interaction between persons of poise; a
   particular way of carrying oneself; bearing, carriage

`poise` aims to be as simple and unopinionated solution as possible to the
problem of generating static site content in the LFE/Erlang/BEAM world of web
development. It boils down to two primary operations:

* `make-site` - a record consturctor that takes a site data structure and
  content-generation related options
* `generate` - a function that iterates through the paths and functions in the
  site data structure, saving them to a conifigured output directory

The poise LFE library is inspired by the Clojure
[statis](https://github.com/magnars/stasis) project which accomplishes the
same goals for the Clojure ecosystem.


## Usage

NOTE: This is a new project, WIP -- not ready for use yet!


### Site Definition

Definte a site:

```cl
(include-lib "poise/include/poise.lfe")

(make-site
  routes (list
           (make-route path "/index.html"
                       function #'index-page/0)
           (make-route path "/about.html"
                       function #'about-page/0))
  opts (make-options output-dir "static"))
```

There is a convenience function provided that makes this easier:

```cl
(poise:site
  #m("/index.html" #'index-page/0
     "/about.html" #'about-page/0)
  #m(output-dir "static"))
```

In both of the above cases, you'd want to assign the results to a variable,
e.g., `site-data`.


### Static Content Generation

Generate the site:

```cl
(poise:generate site-data)
```

That's it!


## Additional Features

TBD


----
<a name="footnote1">1</a>
[https://www.merriam-webster.com/dictionary/poise](https://www.merriam-webster.com/dictionary/poise)


<!-- Named page links below: /-->

[project-logo]: resources/images/logo.png
[project-logo-large]: resources/images/logo-large.png
