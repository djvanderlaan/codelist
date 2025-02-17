#' Get the locale to use with the codelist
#'
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#' is a valid code list.
#'
#' @param preferred the preferred locale. If missing or not present in the 
#' code list, the first locale in the code list will be used.
#'
#' @return
#' A character vector of length 1 with the locale. Can be \code{NA} when the 
#' codelist does not have locales.
#'
#' @export
cl_locale <- function(codelist, 
    preferred = getOption("CLLOCALE", NA_character_)) {
  locales <- cl_locales(codelist)
  if (preferred %in% locales) {
    preferred
  } else {
    utils::head(locales, 1)
  }
}

