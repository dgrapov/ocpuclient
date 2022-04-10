#' @title ocpu_post
#' @param connection crul connection from HttpClient$new()
#' @param body
#' @param pkg_url path to package function e.g. ocpu/library/LIBRARY/R/FUNCTION
#' @param encode one of 'json', 'form' or a function to encode results
#' @param return_value logical return session calculated value
#'
#' @return list of meta including session, status and paths and optionaly result of the session call
#' @export
#'
#' @examples
ocpu_post <- function(connection,
                      body = NULL,
                      pkg_url = 'ocpu/library/dave.ml/R/rebuild_rfe',
                      encode = NULL,
                      return_value = FALSE) {

  #seems connection is modified in the global scope so need to set each call
  connection$headers$'Content-Type' <- NULL

  if (is.null(encode)) {
    .body <- body
  } else{

    if (encode == 'json') {
      connection$headers$'Content-Type' <- 'application/json'
      .body <- jsonlite::toJSON(body)
    }

    if (encode == 'form') {
      .body <- format_crul_input(body)
    }
  }

  res <-
    connection$post(path = pkg_url,
                    body = .body)


  out <- get_crul_results(res)

  if (return_value) {
    .session <- ocpu_session(out)
    if (!is.null(.session))
      out$results <- get_ocpu_obj(.session)
  }

  return(out)

}
