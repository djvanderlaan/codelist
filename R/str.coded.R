#' @export
str.coded <- function(object, ...) {
  #class(object) <- setdiff(class(object), "coded")
  attr(object, "codelist") <- NULL
  NextMethod(object = object)
}

