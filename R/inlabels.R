#' Match codes based on label
#' 
#' @param x vector with codes. Should be of the same type as the codes in the
#'   codelist.
#' @param label vector with labels. 
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#'   is a valid code list or and object that has a 'codelist' attribute
#'   containing a codelist.
#' @param locale use the codes from the given locale. Should be character vector 
#'  of length 1.
#'
#' @return
#' A logical vector of the same length as \code{x} indicating for each value if
#' the code has a label present in \code{labels}.
#'
#' @export
inlabels <- function(x, labels, codelist = attr(x, "codelist"), 
    locale = cllocale(codelist)) {
  x %in% code(labels, codelist)
}

