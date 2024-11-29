
#' Get the code belonging to a given label
#' 
#' @param x character vector with labels.
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#'   is a valid code list or and object that has a 'codelist' attribute
#'   containing a codelist.
#' @param locale use the codes from the given locale. Should be character vector 
#'  of length 1.
#'
#' @return
#' Returns a vector of codes. Will give an error when one of the labels cannot
#' be found in the codelist for the given locale.
#'
#' @seealso
#' See \code{\link{lab}} for an alternative in comparisons.
#'
#' @examples
#' data(objectcodes)
#' data(objectsales)
#' objectsales$product <- coded(objectsales$product, objectcodes)
#'
#' code(c("Hammer", "Electric Drill"), objectsales$product)
#'
#' @export
code <- function(x, codelist, locale = cllocale(codelist)) {
  if (!is.null(attr(codelist, "codelist"))) {
    # Assume we got a variable with a codelist and not the codelist
    codelist <- attr(codelist, "codelist")
  }
  cl <- clfilterlocale(codelist, preferred = locale)
  m <- match(x, cl$label)
  if (all(is.na(m)) && missing(locale) && sum(!is.na(x))>0) {
    # Check other locales
    m2 <- match(x, codelist$label)
    if (!any(is.na(m2) & !is.na(x))) {
      warning("Labels not found in current locale, but present in other locales. Ignoring locale.")
      m <- m2
      cl <- codelist
    }
  }
  if (any(is.na(m) & !is.na(x))) stop("Labels not present in codelist in current locale.")
  # Check for duplicate labels; then no unique code
  tmp <- cl$label[cl$label %in% x]
  tmp <- tmp[duplicated(tmp)]
  if (length(tmp)) {
    stop("Labels are not unique. Therefore it is not possible to determine ",
      "a unique code. Duplicated labels: ", 
      paste0("'", tmp, "'", collapse = ","))
  }
  cl$code[m]
}

