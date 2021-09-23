#test connection
#' @title init_dave_ocpu
#' @export
init_dave_ocpu<-function(open_cpu_url='http://localhost/ocpu/'){
  options('open_cpu_url' = open_cpu_url)
}

#' #generic function combining main fun and json parsing
#' #' @title dave_fun_toJSON
#' #' @export
#' dave_fun_toJSON<-function(fun,args){
#'
#'   res<-do.call(fun,args)
#'
#'   ocpu_toJSON(res)
#'
#' }

##' @title opcpu_fun
##' @export
# ocpu_fun<-function(fun,...){
#
#   function(...){
#     ocpu_toJSON(do.call(fun,...))
#   }
# }

#keep object class when forcing toJSON
#' @title dave_toJSON
#' @export
#' @import jsonlite
ocpu_toJSON<-function(x,...){

  .class<-class(x)
  check<-tryCatch(toJSON(x),error = function(e){NULL})

  if(!is.null(check)) return(list(results=check,class=.class))
  .class<-class(x)
  list(results = toJSON(x,force=TRUE),dave_ocpu_class=.class)

}

#' @title dave_fromJSON
#' @export
#' @import jsonlite
ocpu_fromJSON<-function(x){

  if(x$dave_ocpu_class %in% 'data.frame'){
    fromJSON(x$results) %>% as.data.frame()
  }

  obj<-x$results %>% fromJSON(.)
  class(obj)<-x$dave_ocpu_class
  obj
}


.ocpu_post<-function(fun,body,pkg_url = getOption('dave.stat_url'), base_url=getOption('open_cpu_url')){

  url<-paste0(base_url,pkg_url,fun)
  post_ocpu(url=url,body=body)
}

#' @title ocpu_post
#' @export
#' @import memoise
#' @details can get fails to memoize if called from a shiny app
ocpu_post<-memoise::memoise(.ocpu_post)


#' @export
#' @details used to serialize diverse classes to json
ocpu_fun<-function(fun){
  fun(...) %>%
    ocpu_toJSON()
}

#' @title ocpu_call
#' @export
#' @details call function and serialize results to json
ocpu_call <-
  function(fun,
           body=NULL,
           pkg_url=NULL,
           base_url = getOption('open_cpu_url')) {

    results <- error <- NULL

    out <- tryCatch(
      list(
        results = ocpu_post(
          fun = fun,
          body = body,
          pkg_url = pkg_url,
          base_url = base_url
        ),
        error = error
      ),
      error = function(e) {
        list(results = results, error = as.character(e))
      }
    )


  .call<-tryCatch(out$results  %>% ocpuclient::ocpu_fromJSON(),error=function(e){as.character(e)})

  list(results=.call,error=c(out$error,.call$error))

  }

test<-function(){

  library(ocpuclient)
  library(dave.network)

  # .ocpu_metabolic_network<-ocpuclient::ocpu_fun('metabolic_network')

  #' @title ocpu_metabolic_network
  #' @export
  ocpu_metabolic_network <- function(
    body,
    pkg_url = getOption('dave.network_url'),
    base_url = getOption('open_cpu_url')) {

    f<-dave.network::metabolic_network
    fun<-ocpuclient::ocpu_fun('f')
    ocpu_call(fun,
              body,
              pkg_url,
              base_url)
  }


}

