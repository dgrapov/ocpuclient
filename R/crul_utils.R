#functions for interacting with crul calls to opencpu

#' @title ocpu_session
#' @export
#' @details get ocpu results session
ocpu_session<-function(x){
  x$meta$session
}

#' @title get_ocpu_obj
#' @export
#' @details get ocpu results based on session
get_ocpu_obj<-function(session,open_cpu_url=options('open_cpu_url')){
  session_url<-paste0(open_cpu_url,'/tmp/',session,'/R/.val/rds')
  readRDS(gzcon(curl::curl(session_url)))
}

#' @title session_list_item
#' @export
#' @details get list element by name from obj created in a previous session
session_list_item<-function(obj,name){
  obj[[name]]
}


#' @title get_crul_results
#' @param res crul response object
#' @import crul
#' @export
get_crul_results<-function(res){

  #headers

  headers <- tryCatch(res$response_headers,error=function(e){e})

  if("error" %in% class(headers)){

    return(
      list(
        meta = list(
          session = NULL,
          status = NULL
        ),
        paths = NULL
      )
    )

  }

  list(
    meta = list(
      session = headers$`x-ocpu-session`,
      status = res$status_code
    ),
    paths = strsplit(res$parse(), '\n')[[1]] #error messages will get sent here as well
  )

}

#' @title .quote
#' @export
#' @details add extra quotes around expression
.quote<-function(x,sep="'"){
  paste0(sep,x,sep)
}


#' @title format_crul_input
#' @param body
#'
#' @return
#' @export
#'
#' @examples
format_crul_input<-function(body){

  #omit session references
  #convert characters to quotes
  #convert lists to json

  is_session<-function(x){
    tryCatch(!is.null(x$meta$session),error=function(e){FALSE})
  }

  crul_format<-function(x){

    if(is_session(x)) return(ocpu_session(x))

    if(is.list(x) | length(x) >1) return(toJSON(x))

    if(is.character(x) & length(x) == 1) return(.quote(x))

    return(x)

  }

  lapply(body,  crul_format)

}

#' @title get_ocpu_list_item
#' @param connection
#' @param body
#'
#' @return named element from objects created in other sessions
#' @export
#'
#' @examples
get_ocpu_list_item <- function(connection, body) {
  pkg_url <- 'ocpu/library/ocpuclient/R/session_list_item'

  headers <- connection$headers$'Content-Type'
  connection$headers$'Content-Type' <- NULL

  body$obj<-ocpu_session(body$obj)
  body$name<-.quote(body$name)
  res <-
    connection$post(path = pkg_url,
                    body = body)


  connection$headers$'Content-Type' <- headers

  get_crul_results(res)

}
