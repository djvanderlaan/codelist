#' @export
clfilterlocale <- function(codelist, 
    preferred = getOption("CLLOCALE", NA_character_)) {
  locale <- cllocale(codelist, preferred)
  if (hasName(codelist, "locale")) {
    if (is.na(locale)) {
      codelist[is.na(codelist$locale), , drop = FALSE]
    } else {
      codelist[codelist$locale == locale, , drop = FALSE]
    }
  } else {
    codelist
  }
}
