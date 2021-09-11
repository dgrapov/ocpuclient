
#' @param ... see httr::POST
#' @details submit POST request, process and return results or error
#' @return list of results and error
#' @export
#' @import httr curl
post_ocpu<-function(..., return_value=TRUE){

  out<-list(results=NULL,error=NULL)

  res<-POST(...,encode='json',verbose())

  #error at API layer
  if(status_code(res) >=400){

    out['error']<-rawToChar(res$content)
    return(out)
  }

  res_headers<-headers(res)
  res_url<-res_headers$location

  #all endpoints
  locs<-readLines(curl(res_url))

  value<-'R/.val' # results
  error<-'console' # error message


  if(value %in% locs){

    tmp<-paste0(value,'/json')
    tmp<-paste0(res_url,tmp)
    .name<-'results'

  } else {
    #R error
    tmp<-error
    tmp<-paste0(res_url,tmp)
    .name<-'error'

  }

  if(return_value){

    res<-fromJSON(readLines(curl(tmp)))

  } else {

    res<-list(locations=locs,headers=res_headers)

  }


  if(!'list' %in% class(res)){
    out[[.name]]<-list(res)
  } else {
    out[[.name]]<-res
  }

  return(out)


}


