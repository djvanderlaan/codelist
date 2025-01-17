#' @export
str.code <- function(object, ...) {
  #class(object) <- setdiff(class(object), "code")
  attr(object, "codelist") <- NULL
  NextMethod(object = object)
}

