
> ## Simple [`opencpu`](https://www.opencpu.org/) API client

### Installation

```r
install_github("dgrapov/ocpuclient")
```

### Summary
The purpose of this package is to create drop in replacements for native library functions to instead call the libraries' opencpu endpoints. This can be used to create a scalable microservice infrastructure to support many functions diverse compute requirements while reducing client dependancy imports.

This package easily handles calls to functions with references to objects created in other calls or sessions. It is simple to use native `httr` to call `opencpu` functions but it is a whole other story if you want to reuse objects created in other session calls. This package is the culmination of a brute force effort to use `httr`, `curl` and `crul` to create a simple `opencpu` client.

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


Client library `foo_bar.client` function for  `foo_bar::foo`

```r

#' @title ocpu_foo
#' @import ocpuclient
ocpu_foo  <- function(connection,
                     body = NULL,
                     pkg_url = 'ocpu/library/foo_bar/R/foo',
                     return_value =TRUE) {

  ocpu_post(
    connection,
    body = body,
    pkg_url = pkg_url,
    encode = 'json',
    return_value = return_value
  )

}
```

Use drop in replacement opencpu endpoint call

```r

library(ocpuclient)

#establish connection to opencpu server

connection<-HttpClient$new(url = 'http://localhost/ocpu/') # see library::crul for all options

body<-list(arg1=1)

(results<-ocpu_foo(body=body))

```

Reference objects created in other opencpu session calls
```r
body<-list(x=results)
(results<-ocpu_foo(body=body,pkg_url = 'ocpu/library/base/R/print',encode='form'))

```

Note, referencing objects created in previous sessions from `R` seems to require custom `form` encoding, see `ocpuclient::format_crul_input` for more details or use `encode = NULL` to passthrough custom encodings.  

