#' Convert object to code
#'
#' @param x object to convert
#' 
#' @return
#' Returns an object of type \code{\link{code}}.
#'
#' @details
#' By default objects are first converted to factor using
#' \code{\link{as.factor}} before being converted to code using
#' \code{\link{as.code}}.
#'
#' @rdname as.code
#' @export
as.code <- function(x) {
  UseMethod("as.code")
}

#' @rdname as.code
#' @export
as.code.code <- function(x) {
  x
}

#' @rdname as.code
#' @export
as.code.default <- function(x) {
  code(as.factor(x))
}

