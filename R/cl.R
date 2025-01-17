#' Get the code list associated with the object
#'
#' @param x the object to get the \code{\link{codelist}} from.
#'
#' @return 
#' An object of type 'codelist'.
#'
#' @export
cl <- function(x) {
  UseMethod("cl")
}

#' @rdname cl
#' @export
cl.default <- function(x) {
  as.codelist(attr(x, "codelist"))
}

#' @rdname cl
#' @export
cl.code <- function(x) {
  as.codelist(attr(x, "codelist"))
}

