# poise

[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe-badge]][lfe]
[![Erlang Versions][erlang-badge]][versions]
[![Tag][github-tag-badge]][github-tag]

[![Project Logo][logo]][logo-large]

*An LFE Library for framework-agnostic generation of static HTML content*


#### Contents

* [About](#about-)
* [Usage](#usage-)
  * [Site Definition](#site-definition-)
  * [Static Content Generation](#static-content-generation-)
* [Additional Features](#additional-features-)
* [License](#license-)


## About [&#x219F;](#contents)

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


## Usage [&#x219F;](#contents)

NOTE: This is a new project in an alpha release. Please test and submit tickets!


### Site Definition [&#x219F;](#contents)

Definte a site:

```cl
(include-lib "poise/include/poise.lfe")

(make-site
  routes (list
           (make-route path "index.html"
                       func (lambda () (index-page)))
           (make-route path "about.html"
                       func (lambda () (about-page))))
  opts (make-options output-dir "static"))
```

There is a convenience function provided that makes this easier (and is
thus the recommended approach):

```cl
(poise:site
  `(("index.html" ,#'index-page/0)))
    ("about.html" ,#'about-page/0))))
  #m(output-dir "static"))
```

In both of the above cases, you'd want to assign the results to a variable,
e.g., `site-data`.


### Static Content Generation [&#x219F;](#contents)

Generate the site:

```cl
(poise:generate site-data)
```

That's it!


## Additional Features [&#x219F;](#contents)

TBD (See upcoming [feature tickets](https://github.com/lfex/poise/issues?q=is%3Aissue+is%3Aopen+label%3Afeature))


## License [&#x219F;](#contents)

Copyright © 2017-2024, Duncan McGreggor

Apache License, Version 2.0


----
<a name="footnote1">1</a>
[https://www.merriam-webster.com/dictionary/poise](https://www.merriam-webster.com/dictionary/poise)


[//]: ---Named-Links---

[project-logo]: https://raw.githubusercontent.com/lfex/poise/main/priv/images/logo.png
[project-logo-large]:https://raw.githubusercontent.com/lfex/poise/main/priv/images/logo-large.png
[org]: https://github.com/lfex
[github]: https://github.com/lfex/poise
[gh-actions-badge]: https://github.com/lfex/poise/workflows/ci%2Fcd/badge.svg
[gh-actions]: https://github.com/lfex/poise/actions
[lfe]: https://github.com/lfe/lfe
[lfe badge]: https://img.shields.io/badge/lfe-2.1+-blue.svg
[erlang badge]: https://img.shields.io/badge/erlang-23+-blue.svg
[versions]: https://github.com/lfex/poise/blob/master/.github/workflows/cicd.yml
[github tags]: https://github.com/lfex/poise/tags
[github tags badge]: https://img.shields.io/github/tag/lfex/poise.svg
[github downloads]: https://img.shields.io/github/downloads/atom/atom/total.svg
[hex badge]: https://img.shields.io/hexpm/v/poise.svg
[hex package]: https://hex.pm/packages/poise
[hex downloads]: https://img.shields.io/hexpm/dt/poise.svg
