## simple opencpu API client


### Installation
```r
install_github("dgrapov/ocpuclient")
```

### Call [CTSgetR](https://github.com/dgrapov/CTSgetR) for metabolite identifier translations
### See instructions showing how to launch API: https://github.com/dgrapov/CTSgetR#API
```r
#translate
library(ocpuclient)

base_url<-'http://localhost/ocpu/' # https://github.com/dgrapov/CTSgetR#API
endpoint<-'library/CTSgetR/R/CTSgetR'
url<-paste0(base_url,endpoint)

id <-
  c("C15973",
    "C00026")
from <- "KEGG"
to <- "PubChem CID"

body<-list(id=id,from=from,to=to,db_name=db_name)


post_ocpu(url=url,body=body)
```
