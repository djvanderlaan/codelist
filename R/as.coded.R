

#' Convert object to coded
#'
#' @param x object to convert
#' 
#' @return
#' Returns an object of type \code{\link{coded}}.
#'
#' @details
#' By default objects are first converted to factor using
#' \code{\link{as.factor}} before being converted to coded using
#' \code{\link{coded}}.
#'
#' @rdname as.coded
#' @export
as.coded <- function(x) {
  UseMethod("as.coded")
}

#' @rdname as.coded
#' @export
as.coded.coded <- function(x) {
  x
}

#' @rdname as.coded
#' @export
as.coded.default <- function(x) {
  coded(as.factor(x))
}

