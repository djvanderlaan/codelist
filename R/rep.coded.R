#' @export
rep.coded <- function(x, ...) {
  old_class <- class(x)
  attr <- attributes(x)
  res <- NextMethod()
  class(res) <- old_class
  attributes(res) <- attr
  res
}
