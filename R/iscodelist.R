#' Check if an object is a Code List
#'
#' @param x object to test.
#' 
#' @return 
#' Returns a logical of length 1. Returns \code{TRUE} is \code{x} is of type
#' \code{\link{codelist}} or a \code{data.frame} that conforms to the
#' requirements of a code list.
#'
#' @export
iscodelist <- function(x) {
  methods::is(x, "codelist") || isTRUE(isvalidcodelist(x))
}

