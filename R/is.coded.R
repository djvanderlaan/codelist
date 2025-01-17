#' Check if object is a code
#'
#' @param x object to check
#'
#' @return
#' Returns a logical of length 1 indicating whether or not \code{X} is of 
#' type 'code'.
#'
#' @export
is.code <- function(x) {
  methods::is(x, "code")
}
