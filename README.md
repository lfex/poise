# poise

[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe-badge]][lfe]
[![Erlang Versions][erlang-badge]][versions]
[![Tag][github-tag-badge]][github-tag]

[![Project Logo][logo]][logo-large]

*An LFE Library for framework-agnostic generation of static HTML content*


#### Contents

* [About](#about-)
* [Prerequisites](#prerequisites-)
* [Usage](#usage-)
* [Name](#name-)
* [License](#license-)


## About [&#x219F;](#contents)

This project is getting an overhaul to allow for better control over rendered Markdown in static sites. Progress is being tracked here:

* [poise redesign](https://github.com/lfex/poise/issues/8)

`poise` aims to be as simple and unopinionated solution as possible to the
problem of generating static site content in the LFE/Erlang/BEAM world of web
development. 

While early versions of the poise LFE library were inspired by the Clojure
[statis](https://github.com/magnars/stasis), in more recent years the Rust-based project [Zola](https://github.com/getzola/zola) has informed our design decisiions (in particular the areas where we found it inflexible).

## Prerequisites [&#x219F;](#contents)

Before building with `rebar3`, one needs to have the following installed:

* `gcc`, `make`, and related tools (also `git`)
* The Rust build tool `cargo` preferably installed using [rustup](https://rustup.rs/)
* The Markdown AST-parser `mdsplode` (installed using `cargo`)
* The `jq` and `oniguruma` libraries (used for querying JSON)
* Erlang and `rebar3`

To set up the environment variables required by [mdsplod](https://crates.io/crates/mdsplode), you need to follow the instructions provided [here](https://github.com/oxur/mdsplode/blob/release/0.4.x/docs/jq-support.md). Once that's done, you will be able to run the following:

``` shell
cargo install mdsplode
rebar3 compile
rebar3 lfe repl
```

## Usage [&#x219F;](#contents)

You can start `poise` in the LFE REPL with the following:

``` lisp
(poise:start)
```

The following are useful to check that the Rust binary is working with LFE:

``` lisp
(sploder:version)
(sploder:ping)
(sploder:echo "this is a test")
```

You can use a test file to check out some of the content-parsing functionality:

``` lisp
(sploder:read 'md "priv/testing/learn.md"))
(sploder:frontmatter)
(sploder:query "'.children.nodes[] | select((.depth == 3) and .source == \"Getting Started\")'")
```

## Name [&#x219F;](#contents)

<em><strong>poise</strong></em>, n. <sup>[1](#footnote1)</sup>

1. a stably balanced state; equilibrium
1. easy self-possessed assurance of manner; gracious tact in coping or
   handling; the pleasantly tranquil interaction between persons of poise; a
   particular way of carrying oneself; bearing, carriage

## License [&#x219F;](#contents)

Copyright © 2017-2024, Duncan McGreggor

Apache License, Version 2.0


----
<a name="footnote1">1</a>
[https://www.merriam-webster.com/dictionary/poise](https://www.merriam-webster.com/dictionary/poise)


[//]: ---Named-Links---

[logo]: https://raw.githubusercontent.com/lfex/poise/main/priv/images/logo.png
[logo-large]: https://raw.githubusercontent.com/lfex/poise/main/priv/images/logo-large.png
[org]: https://github.com/lfex
[github]: https://github.com/lfex/poise
[gh-actions-badge]: https://github.com/lfex/poise/workflows/ci%2Fcd/badge.svg
[gh-actions]: https://github.com/lfex/poise/actions
[lfe]: https://github.com/lfe/lfe
[lfe-badge]: https://img.shields.io/badge/lfe-2.1+-blue.svg
[erlang-badge]: https://img.shields.io/badge/erlang-23+-blue.svg
[versions]: https://github.com/lfex/poise/blob/master/.github/workflows/cicd.yml
[github-tag]: https://github.com/lfex/poise/tags
[github-tag-badge]: https://img.shields.io/github/tag/lfex/poise.svg
