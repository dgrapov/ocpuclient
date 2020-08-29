## simple opencpu API client


### Installation
```r
install_github("dgrapov/ocpuclient")
```

### Call [CTSgetR]() for metabolite identifier translations
```r
#translate
library(ocpuclient)

base_url<-'http://localhost/ocpu/' # see here how to launch API:
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
