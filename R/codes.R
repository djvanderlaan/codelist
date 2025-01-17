#' Get the codes belonging to given labels
#' 
#' @param x character vector with labels.
#'
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#' is a valid code list or and object that has a 'codelist' attribute
#' containing a codelist.
#' 
#' @param locale use the codes from the given locale. Should be a character vector 
#' of length 1.
#' 
#' @param ... used to pass arguments to other methods.
#'
#' @details
#' \code{tocodes} has the same functionality as a call to \code{codes.default}. 
#'
#' @return
#' Returns a vector of codes. Will give an error when one of the labels cannot
#' be found in the codelist for the given locale. When \code{x} is an object of
#' type 'code' the codes themselves are returned stripped from the 'code'
#' class and with the 'codelist' attribute removed.
#'
#' @seealso
#' See \code{\link{as.label}} for an alternative in comparisons.
#'
#' @examples
#' data(objectcodes)
#' data(objectsales)
#' objectsales$product <- code(objectsales$product, objectcodes)
#'
#' codes(c("Hammer", "Electric Drill"), objectcodes)
#' codes(c("Hammer", "Electric Drill"), cl(objectsales$product))
#'
#' @rdname codes
#' @export
codes <- function(x, ...) {
  UseMethod("codes")
}

#' @rdname codes
#' @export
codes.default <- function(x, codelist, locale = cl_locale(codelist), ...) {
  if (!is.null(attr(codelist, "codelist"))) {
    # Assume we got a variable with a codelist and not the codelist
    stop("FOOOOOOO")
    codelist <- attr(codelist, "codelist")
  }
  cl <- cl_filter(codelist, locale = locale)
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

#' @rdname codes
#' @export
codes.code <- function(x, ...) {
  res <- x
  class(res) <- setdiff(class(res), "code")
  attr(res, "codelist") <- NULL
  res
}

#' @rdname codes
#' @export
tocodes <- function(x, codelist, locale = cl_locale(codelist)) {
  codes.default(x, codelist = codelist, locale = locale)
}

