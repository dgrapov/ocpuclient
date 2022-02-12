#functions for interacting with curl system commands
#useful for passing unquoted opencpu session ids

#' @title ocpu_session
#' @export
#' @details get ocpu results session
ocpu_session<-function(x){
  x$results$headers$'x-ocpu-session'
}

#' @title get_ocpu_obj
#' @export
#' @details get ocpu results based on session
get_ocpu_obj<-function(session,open_cpu_url=options('open_cpu_url')){
  session_url<-paste0(open_cpu_url,'/tmp/',session,'/R/.val/rds')
  readRDS(gzcon(curl::curl(session_url)))
}

#create args from a named list
#' @title to_args
#' @export
#' @details convert a named list to 'name1=value1&name2=value2'
to_args<-function(x){
  paste0(paste(names(x),x,sep='='),collapse="&")
}

#' @title .quote
#' @export
#' @details add extra quotes around expression
.quote<-function(x,sep="'"){
  paste0(sep,x,sep)
}

#' @title curl_post
curl_post <-
  function(args,
           fun_url = 'library/dave.ml/R/get_model_perf',
           open_cpu_url = options('open_cpu_url')) {

    url <- paste0(open_cpu_url, fun_url)
    args_string <- to_args(args)
    cmd <- paste0("curl -i -v ", url, ' -d ', args_string)
    result <- base::system(cmd, intern = TRUE)
    #ugly - get status, header, session - can inferr all others
    status <- grepl('HTTP/1.1', result)
    status <- strsplit(result[status][3], ' ')[[1]][2]
    session <- grepl('X-ocpu-session: ', result)
    session <- gsub('X-ocpu-session: ', '', result[session][2])

    list(status = status,
         session = session,
         cmd = cmd)
  }

#' @title cPOST
#' @param args named string which will be converted to 'name1=value1&name2=value2'
#' @export
#' @details pass POST to system curl command. Useful for passing unquoted (unquotable?) opencpu session object references.
cPOST <-
  function(args,
           fun_url,
           open_cpu_url = options('open_cpu_url'),
           return_value = TRUE) {
    res <-
      curl_post(args = args,
                fun_url = fun_url,
                open_cpu_url = open_cpu_url)

    results <- error <- NULL
    if (res$status != '201') {
      error <- res$status
      return(list(results = results, error = error))
    } else {
      if (return_value) {
        results <- get_ocpu_obj(res$session)
      }

      list(res, results = results, error = error)
    }

  }
