#' Label character vector as label to use in comparisons with a coded vector
#'
#' @param x character vector that is to be interpreted as a label. If \code{x}
#' is not a character vector it will be converted to one using
#' \code{as.character}.
#'
#' @return 
#' Returns a character vector with the class "label". 
#'
#' @seealso
#' Uses \code{\link{code}}.
#'
#' @examples
#' data(objectcodes)
#' data(objectsales)
#' objectsales$product <- coded(objectsales$product, objectcodes)
#' 
#' objectsales$product == lab("Hammer")
#' subset(objectsales, product == lab("Hammer"))
#' 
#' # This is the same as
#' subset(objectsales, product == code("Hammer", product))
#' 
#'@export 
lab <- function(x) {
  structure(as.character(x), class = "label")
}
