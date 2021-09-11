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

#' @title opcpu_fun
#' @export
ocpu_fun<-function(fun){

  function(...){fun(...) %>%
      ocpu_toJSON()
  }

}

#keep object class when forcing toJSON
#' @title dave_toJSON
#' @export
#' @import jsonlite
ocpu_toJSON<-function(x,...){

  .class<-class(x)
  check<-tryCatch(toJSON(x),error = function(e){NULL})

  if(!is.null(check)) return(list(results=check,class=.class))
  .class<-class(x)
  list(results = toJSON(x,force=TRUE),class=.class)

}

#' @title dave_fromJSON
#' @export
#' @import jsonlite
ocpu_fromJSON<-function(x){

  if(x$class %in% 'data.frame'){
    fromJSON(x$results) %>% as.data.frame()
  }

  obj<-x$results %>% fromJSON(.)
  class(obj)<-x$class
  obj
}


.ocpu_post<-function(fun,body,pkg_url = getOption('dave.stat_url'), base_url=getOption('open_cpu_url')){

  url<-paste0(base_url,pkg_url,fun)
  post_ocpu(url=url,body=body)
}

#' @title ocpu_post
#' @export
#' @import memoise
ocpu_post<-memoise::memoise(.ocpu_post)

