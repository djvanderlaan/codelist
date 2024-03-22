

#' Get the locale to use with the codelist
#'
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#'   is a valid code list.
#' @param preferred the preferred locale. If missing or not present in the 
#'   code list. The first locale in the code list will be used.
#'
#' @return
#' A character vector of length 1 with the locale. Can be \code{NA} when the 
#' codelist does not use a locale.
#'
#' @export
cllocale <- function(codelist, 
    preferred = getOption("CLLOCALE", NA_character_)) {
  locales <- cllocales(codelist)
  if (preferred %in% locales) {
    preferred
  } else {
    head(locales, 1)
  }
}

