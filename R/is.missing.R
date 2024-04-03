#' Find out which elements of a vector have missing values
#'
#' @param x vector for which the missing elements have to be detected.
#'
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#'   is a valid code list.
#'
#' @details
#' Unlike \code{\link{is.na}} \code{is.missing} will also return \code{TRUE} for
#' elements of \code{x} whose values are indicated in the code list to be
#' missing values. For that to work \code{codelist} needs to be a valid
#' \code{\link{codelist}} with a 'missing' column. This column needs to be
#' interpretable as a logical vector. When \code{codelist} is missing or does
#' not contain a 'missing' column the result of \code{is.missing} is the same as
#' \code{\link{is.na}}.
#'
#' @return
#' Returns a logical vector of the same length as \code{x} with \code{TRUE}
#' indicating corresponing values in \code{x} that can be considered to be
#' missing.
#'
#' @export
is.missing <- function(x, codelist = attr(x, "codelist")) {
  if (is.data.frame(codelist) && utils::hasName(codelist, "missing")) {
    if (!utils::hasName(codelist, "code")) 
      stop("Invalid codelist: 'code' column is missing.")
    missing_codes <- codelist$code[as.logical(codelist$missing)]
    is.na(x) | (x %in% missing_codes)
  } else {
    is.na(x)
  }
}

