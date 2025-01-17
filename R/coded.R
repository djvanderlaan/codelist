#' Coded vector
#' 
#' A coded vector is a vector with an associated code list. The values in the
#' codelist should come from this code list. The values also have an associated
#' label and optionally additional properties such as a description. See
#' \code{\link{codelist}} for more information on what should and could be in a
#' code list. 
#'
#' @param x vector to convert to coded vector
#' @param codelist codelist to associate with the values in \code{x}
#' @param ... Ignored; used to pass extra arguments to other methods
#'
#' @details
#' When \code{codelist} is omitted in case \code{x} is a factor, a code list is
#' generated from the factor values. 
#'
#' @return
#' Returns an object of type 'coded'. Except when \code{x} is a factor, \code{x}
#' keeps classes and attributes assiated with \code{x}. This object is a copy of
#' \code{x} with a \code{codelist} attribute added. 
#'
#' When \code{x} is a factor \code{x} is converted to an integer vector. The
#' labels are the levels of the factor.
#'
#' @examples
#'
#' x <- coded(c(1,4,2), codelist(codes = 1:4, labels = letters[1:4]))
#' print(x)
#' labels(x)
#'
#' x <- coded(factor(letters[1:3]))
#' print(x)
#' attr(x, "codelist")
#'
#' @export
coded <- function(x, codelist, ...) {
  UseMethod("coded")
}

#' @export
coded.default <- function(x, codelist = attr(x, "codelist"), ...) {
  if (!is.codelist(codelist)) codelist <- as.codelist(codelist)
  if (!isTRUE(err <- check_against_codelist(x, codelist)))
    stop(err)
  attr(x, "codelist") <- codelist
  class(x) <- c("coded", attr(x, "class"))
  x
}

#' @export
coded.factor <- function(x, codelist = attr(x, "codelist"), ...) {
  if (missing(codelist) && is.null(codelist)) {
    codelist <- codelist(codes = seq_len(nlevels(x)), labels = levels(x))
    x <- as.integer(x)
  } else {
    if (!is.codelist(codelist)) codelist <- as.codelist(codelist)
    if (is.factor(codelist$code)) {
      codelist$code <- as.character(codelist$code)
      x <- as.character(x)
    } else if (is.character(codelist$code)) {
      x <- as.character(x)
    #} else if (is.numeric(codelist$code)) {
    #  x <- as.integer(x)
    } else {
      stop("Codes in codelist should be character when x is factor.")
    }
  }
  if (!isTRUE(err <- check_against_codelist(x, codelist)))
    stop(err)
  attr(x, "levels") <- NULL
  attr(x, "codelist") <- codelist
  class(x) <- "coded"
  x
}

