#' Create a codelist object
#'
#' @param codes a vector with the codes.
#'
#' @param labels optional vector with the labels. Will be converted to character
#' and should have the same length as \code{codes}. When \code{labels} is not
#' given \code{as.character(codes)} is used for the labels.
#'
#' @param descriptions optional vector with the descriptions of the codes. Will be
#' converted to character and should have the same length as \code{codes}.
#'
#' @param parent optional vector with the parents of the codes. Should be of the
#' same type and length as \code{codes} and should contain only values present in
#' \code{codes} or missing values. This can be used to define simple hierarchies.
#' Codes with NA as their parent are the top-level (level 0) codes in the
#' hierarchy.
#'
#' @param locale optional vector with the locale of the labels, descriptions etc.
#' of the codes. This should be a character vector with the same length as
#' \code{codes}. When the code list contains multiple locales each code should be
#' present in each locale.
#'
#' @param missing optional logical vector indicating whether or not the
#' corresponding code can be treated as a missing value. This can be used to
#' encode different types of missingness. 
#'
#' @return
#' Returns a \code{codelist} object which is a \code{data.frame} with at minimum
#' the columns 'code' and 'label' and optionally 'description', 'parent',
#' 'locale' and 'missing'. See below for a description of the columns:
#'
#' \item{code}{The codes. It is expected that these are either characters or
#' integers although other types are probably supported. For a given locale (see
#' below) they should be unique. Missing values are not allowed.}
#'
#' \item{label}{The labels of the codes. These are characters. Missing values
#' are not allowed.} 
#'
#' \item{description}{Optional. The description of the codes. These are characters.
#' Missing values are not allowed.}
#'
#' \item{missing}{Optional. Logical vector indicating whether or not the
#' corresponding code can be treated as a special value. This can be used to
#' have different codes for different types of missingness. Missing values are
#' not allowed.}
#'
#' \item{locale}{Optional. Character vector indicating for the given row 
#' which locale the label and description belong to. The default use is to have
#' different translations of the labels and descriptions. However, this can also
#' be used, for example, to specify short and long labels. When there is more
#' than one locale, there should be multiple lines for each code, one for each
#' locale.}
#'
#' \item{parent}{Optional. The parent of the code. This can be used to specify
#' simple hierarchies. These should be of the same type as the 'code' column and
#' values should be present in the 'code' column or be 'NA'. When the parent is
#' 'NA' it is assumed this is a top level code. The hierarchy should form a
#' tree.}
#'
#' The validity of the code list can be checked using \code{\link{cl_is_valid}}.
#' 
#' @export
codelist <- function(codes, labels = NULL, descriptions = NULL, parent = NULL, 
    locale = NULL, missing = NULL) {
  if (missing(labels) || is.null(labels)) labels <- as.character(codes)
  labels <- as.character(labels)
  codelist <- data.frame(code = codes, label = labels)
  if (!missing(descriptions) && !is.null(descriptions))
    codelist$description <- as.character(descriptions)
  if (!missing(parent) && !is.null(parent))
    codelist$parent <- parent
  if (!missing(locale) && !is.null(locale))
    codelist$locale <- as.character(locale)
  if (!missing(missing) && !is.null(missing))
    codelist$missing <- as.logical(missing)
  as.codelist(codelist)
}

