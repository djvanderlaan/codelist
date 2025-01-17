#' @export
`length<-.code` <- function(x, value) {
  oldclass <- class(x)
  attr <- attributes(x)
  x <- NextMethod()
  attributes(x) <- attr
  class(x) <- oldclass
  x
}
