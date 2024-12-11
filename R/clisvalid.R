#' Check if the codelist is valid
#'
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#'   is a valid code list.
#'
#' @return
#' Returns \code{TRUE} when the code list is valid; returns a character vector
#' of length 1 with a description of the problem when it is not valid.
#'
#' @export
clisvalid <- function(codelist) {
  if (!is.data.frame(codelist)) return("Code list is not a data.frame")
  if (!utils::hasName(codelist, "code")) 
    return("Field 'code' is missing from code list.")
  if (!utils::hasName(codelist, "label")) 
    return("Field 'label' is missing from code list.")
  if (anyNA(codelist$code)) 
    return("Mising values in 'code' field.")
  if (!is.character(codelist$label)) 
    return("Field 'label' is not of type character.")
  if (utils::hasName(codelist, "parent")) {
    if (!sameclass(codelist$parent, codelist$code))
      return ("Class of 'parent' column is not equal to that of the 'code' column")
    if (!all(is.na(codelist$parent) | (codelist$parent %in% codelist$code)))
      return ("Not all codes in 'parent' column are present in 'code' column.")
    if (anyNA(cllevels(codelist))) 
      return ("Codelist does not form a proper hierarchy.")
  }
  if (anyNA(codelist$label)) 
    return("Mising values in 'label' field.")
  if (utils::hasName(codelist, "description")) {
    if (!is.character(codelist$description)) 
      return("Field 'description' is not of type character.")
  }
  if (utils::hasName(codelist, "locale")) {
    if (!is.character(codelist$locale)) 
      return("Field 'locale' is not of type character.")
    if (anyNA(codelist$locale)) 
      return("Missing values in 'locale' field.")
    locales <- unique(codelist$locale)
    codes <- unique(codelist$code)
    for (locale in locales) {
      sel <- codelist$locale == locale
      if (!all(codes %in% codelist$code[sel])) {
        return(paste0("Locale '", locale, "' does not contain all codes."))
      }
      if (anyDuplicated(codelist$code[sel])) {
        return(paste0("Locale '", locale, "' contains duplicated codes."))
      }
    }
  } else {
    if (anyDuplicated(codelist$code)) return("Duplicated codes.")
  }
  if (utils::hasName(codelist, "missing")) {
    if (!is.logical(codelist$missing) && !is.integer(codelist$missing) &&
      !(is.numeric(codelist$missing) && all(codelist$missing %in% c(0,1))))
      return("Field 'missing' cannot be interpreted as logical")
    if (anyNA(codelist$missing)) 
      return("Missing values in 'mising' field.")
  }
  TRUE
}

