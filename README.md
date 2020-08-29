## simple opencpu API client


### Installation
```r
install_github("dgrapov/ocpuclient")
```

### Call [CTSgetR]() for metabolite identifier translations
```r
#translate
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
