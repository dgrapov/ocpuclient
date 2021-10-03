#test connection
#' @title init_dave_ocpu
#' @export
init_ocpu<-function(open_cpu_url='http://localhost/ocpu/'){
  options('open_cpu_url' = open_cpu_url)
}

#keep object class when forcing toJSON
#' @title dave_toJSON
#' @export
#' @import jsonlite
ocpu_toJSON<-function(x,...){

  .class<-class(x)
  check<-tryCatch(toJSON(x),error = function(e){NULL})

  if(!is.null(check)) return(list(results=check,ocpu_class=.class))
  .class<-class(x)
  list(results = toJSON(x,force=TRUE),ocpu_class=.class)

}

#' @title dave_fromJSON
#' @export
#' @import jsonlite
ocpu_fromJSON<-function(x){

  if(x$ocpu_class %in% 'data.frame'){
    fromJSON(x$results) %>% as.data.frame()
  } else

  obj<-x$results %>% fromJSON(.)
  class(obj)<-x$ocpu_class
  obj
}


ocpu_post<-function(fun,body,pkg_url, base_url=getOption('open_cpu_url')){

  url<-paste0(base_url,pkg_url,fun)
  post_ocpu(url=url,body=body)
}

# seems memoization should be done at run time
##' @title ocpu_post
##' @export
##' @import memoise
##' @details can get fails to memoize if called from a shiny app
#ocpu_post<-memoise::memoise(.ocpu_post)


#' @export
#' @details used to serialize diverse classes to json
ocpu_fun<-function(fun,...){
  tmp<-do.call(fun,...)
  ocpu_toJSON(tmp)
}

#' @title ocpu_call
#' @export
#' @details call function and serialize results to json
ocpu_call <-
  function(fun,
           body = NULL,
           pkg_url = NULL,
           base_url = getOption('open_cpu_url')) {
    results <- error <- NULL

    out <- tryCatch(
       ocpu_post(
          fun = fun,
          body = body,
          pkg_url = pkg_url,
          base_url = base_url
      ),
      error = function(e) {
        list(results = results, error = as.character(e))
      }
    )


   #serialize class
    if(!is.null(out$results$ocpu_class)){
      out$results<- ocpu_fromJSON(out$results)
    }

    return(out)

  }

