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
