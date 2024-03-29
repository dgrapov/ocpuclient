% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/POST.R
\name{ocpu_post}
\alias{ocpu_post}
\title{ocpu_post}
\usage{
ocpu_post(
  connection,
  body = NULL,
  pkg_url = "ocpu/library/dave.ml/R/rebuild_rfe",
  encode = NULL,
  return_value = FALSE
)
}
\arguments{
\item{connection}{crul connection from HttpClient$new()}

\item{pkg_url}{path to package function e.g. ocpu/library/LIBRARY/R/FUNCTION}

\item{encode}{one of 'json', 'form' or a function to encode results}

\item{return_value}{logical return session calculated value}
}
\value{
list of meta including session, status and paths and optionaly result of the session call
}
\description{
ocpu_post
}
