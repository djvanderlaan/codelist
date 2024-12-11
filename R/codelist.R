#' Create a codelist object
#'
#' @param code a vector with the codes.
#'
#' @param label optional vector with the labels. Will be converted to character
#' and should have the same length as \code{code}. When \code{label} is not
#' given \code{code} is used for the labels.
#'
#' @param description optional vector with the descriptions of the codes. Will be
#' converted to character and should have the same length as \code{code}.
#'
#' @param parent optional vector with the parents of the codes. Should be of the
#' same type and length as \code{code} and should contain only values present in
#' \code{code} or missing values. This can be used to define simple hierarchies.
#' Codes with NA as their parent are the top-level (level 0) codes in the
#' hierarchy.
#'
#' @param locale optional vector with the locale of the labels, description etc.
#' of the code. This should be a character vector with the same length as
#' \code{code}. When the code list contains multiple locales each code should be
#' present in each locale.
#'
#' @param missing optional logical vector indicating whether or not the
#' corresponding code can be treated as a missing value. This can be used to
#' encode different types of missingness. 
#'
#' @return
#' Returns a \code{codelist} object which is a \code{data.frame} with at minimum
#' the columns 'code' and 'label' and optionally 'description', 'parent',
#' 'locale' and 'missing'. When \code{x} containds additional columns these are
#' kept. 
#' 
#' @export
codelist <- function(code, label = NULL, description = NULL, parent = NULL, 
    locale = NULL, missing = NULL) {
  if (missing(label) || is.null(label)) label <- as.character(code)
  label <- as.character(label)
  codelist <- data.frame(code, label)
  if (!missing(description) && !is.null(description))
    codelist$description <- as.character(description)
  if (!missing(parent) && !is.null(parent))
    codelist$parent <- parent
  if (!missing(locale) && !is.null(locale))
    codelist$locale <- as.character(locale)
  if (!missing(missing) && !is.null(missing))
    codelist$missing <- as.logical(missing)
  as.codelist(codelist)
}


