#' Label character vector as label to use in comparisons with a coded vector
#'
#' @param x character vector that is to be interpreted as a label. If \code{x}
#' is not a character vector it will be converted to one using
#' \code{as.character}.
#'
#' @return 
#' Returns a character vector with the class "label". This can be used in
#' comparisons to a 'coded' vector, or to assign to a 'coded' vector.
#'
#' @seealso
#' Uses \code{\link{codes}}.
#'
#' @examples
#' data(objectcodes)
#' data(objectsales)
#' objectsales$product <- coded(objectsales$product, objectcodes)
#'
#' objectsales$product[1] <- as.label("Hammer")
#' 
#' objectsales$product == as.label("Hammer")
#' subset(objectsales, product == as.label("Hammer"))
#' 
#' # This is the same as
#' subset(objectsales, product == codes("Hammer", cl(product)))
#' 
#'@export 
as.label <- function(x) {
  structure(as.character(x), class = "label")
}
