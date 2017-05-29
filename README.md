<!-- README.md is generated from README.Rmd. Please edit that file -->


# vetr - Keep the Garbage Out

[![](https://travis-ci.org/brodieG/vetr.svg?branch=master)](https://travis-ci.org/brodieG/vetr)
[![](https://codecov.io/github/brodieG/vetr/coverage.svg?branch=master)](https://codecov.io/github/brodieG/vetr?branch=master)
[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)

## Garbage In...

R is flexible about data structures so any user-facing code you write must vet
inputs.  If you enforce structural requirements for function parameters your
code will be more robust.  It will also be easier to use since errors will be
reported by documented functions and not from deep in the bowels of un-exported
code.

`vetr` takes the tedium out of comprehensive vetting by allowing you to express
structural requirements in a declarative style with templates, and by
auto-generating human-friendly error messages.  It is written in C to minimize
the overhead of parameter checks in your functions.

## Declarative Checks with Templates

Declare a template that an object should conform to, and let `vetr` take care of
the rest:


```r
vet(numeric(1L), 1:3)
## [1] "`1:3` should be length 1 (is 3)"
vet(numeric(1L), "hello")
## [1] "`\"hello\"` should be type \"numeric\" (is \"character\")"
vet(numeric(1L), 42)
## [1] TRUE
```

This becomes particularly powerful with complex objects:


```r
tpl <- list(numeric(1L), list(dat=matrix(numeric(), 3), mode=character(1L)))
obj1 <- list(42, list(rbind(1:5, 1:5, 1:5), letters))
obj2 <- list(42, list(dat=rbind(1:5, 1:5, 1:5), mode=letters))
obj3 <- list(42, list(dat=rbind(1:5, 1:5, 1:5), mode="foo"))
vet(tpl, obj1)
## [1] "`names(obj1[[2]])` should be type \"character\" (is \"NULL\")"
vet(tpl, obj2)
## [1] "`obj2[[2]]$mode` should be length 1 (is 26)"
vet(tpl, obj3)
## [1] TRUE
```

Notice how the error message tells you what the object should be, what it is,
and also provides an expression pointing to the exact sub-location in the object
where the error is.

You can augment templates with custom vetting tokens to check values in addition
to structure:


```r
vet(numeric(1L) && . > 0, 1:3)
## [1] "`1:3` should be length 1 (is 3)"
vet(numeric(1L) && . > 0, -42)
## [1] "`-42 > 0` is not TRUE (FALSE)"
vet(numeric(1L) && . > 0, 42)
## [1] TRUE
```

If you are vetting function inputs, you can use the `vetr` function, which works
just like `vet` except that is streamlined for use within functions:


```r
fun <- function(x, y) {
  vetr(numeric(1L), logical(1L))
  TRUE   # do work...
}
fun(1:2, "foo")
## Error in fun(x = 1:2, y = "foo"): For argument `x`, `1:2` should be length 1 (is 2)
fun(1, "foo")
## Error in fun(x = 1, y = "foo"): For argument `y`, `"foo"` should be type "logical" (is "character")
```

## Installation

`vetr` is available on CRAN.  It has no dependencies.


```r
install.packages('vetr')
## Warning: package 'vetr' is not available (for R version 3.3.3)
```

## Related Packages

* [valaddin](https://github.com/egnha/valaddin)
* [ensurer](https://github.com/smbache/ensurer)
* [types](https://github.com/jimhester/types)
* [argufy](https://github.com/gaborcsardi/argufy)

## Acknowledgements

