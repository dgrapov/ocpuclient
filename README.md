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

### Useful functions
* `ocpu_post` - memoised `POST` to open cpu server and combined `GET` of results
* `ocpu_fun_toJSON` - call function and return results as json including custom classes
