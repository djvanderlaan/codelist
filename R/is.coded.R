#' Check if object is a coded
#'
#' @param x object to check
#'
#' @return
#' Returns a logical of length 1 indicating whether or not \code{X} is of 
#' type 'coded'.
#'
#' @export
is.coded <- function(x) {
  methods::is(x, "coded")
}
