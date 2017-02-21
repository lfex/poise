# poise

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

----
<a name="footnote1">1</a>
[https://www.merriam-webster.com/dictionary/poise](https://www.merriam-webster.com/dictionary/poise)
