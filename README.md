---
output:
  html_document:
    highlight: tango
    keep_md: yes
    theme: readable
---

> ## Simple [`opencpu`](https://www.opencpu.org/) API client

### Installation

```r
install_github("dgrapov/ocpuclient")
```

### Summary
The purpose of this package is to create drop in replacements for native library functions to instead call the libraries' opencpu endpoints. This can be used to create a scalable microservice infrastructure to support many functions diverse compute requirements while reducing client dependancy imports.

### Example
The following describes an example workflow for creating an opencpu client function for package `foo_bar`.

Native function in library `foo_bar`

```r

#' @title foo
#' @export
foo<-function(...){
  paste0('That is ', ifelse(sample(c(FALSE,TRUE), size=1),'bar','foo'))
}

```

Wrapper function in library `foo_bar` to handle custom results serialization to json, etc

```r
.foo<-function(...){
  ocpu_toJSON(foo(...))
}

```

Client library `foo_bar.client` function for  `foo_bar::foo`

```r

#' @title ocpu_foo
#' @import ocpuclient
ocpu_foo  <- function(fun = '.foo',
                      body = NULL,
                      pkg_url = 'library/foo/R/',
                      base_url = 'http://localhost/ocpu/') {
  ocpu_call(fun,
            body,
            pkg_url,
            base_url)
}

```

Use drop in replacement opencpu endpoint call

```r

library(ocpuclient)

body<-list(arg1=1)

ocpu_foo(body=body)

```

