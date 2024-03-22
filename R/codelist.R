#' Create a Code List object
#'
#' @param x data.frame with the code list
#' @param code the name of the column in \code{x} containing the codes.
#' @param label the name of the column in \code{x} containing the labels of 
#'   the codes.
#' @param descriptions the name of the column in \code{x} containing the labels
#'   of the codes.
#' @param parent the name of the column in \code{x} containing the parents
#'   of the codes in case of a hierarchical code list.
#' @param locale the name of the column in \code{x} containing the locale of 
#'   the corresponding row. 
#'
#'
#' @return
#' Returns a \code{codelist} object which is a \code{data.frame} with at minimum
#' the columns 'code' and 'label' and optionally 'description', 'parent', and
#' 'locale'. When \code{x} containds additional columns these are kept. 
#' 
#' @export
codelist <- function(x, code = "code", label = "label", 
    description = "description", parent = "parent", locale = "locale",
    missing = "missing") {
  if (!is.data.frame(x)) stop("x should be a data.frame")
  # Make sure the columns have the correct name
  if (hasName(x, code)) 
    names(x)[names(x) == code] <- "code"
  if (hasName(x, label)) 
    names(x)[names(x) == label] <- "label"
  if (hasName(x, description)) 
    names(x)[names(x) == description] <- "description"
  if (hasName(x, parent)) 
    names(x)[names(x) == parent] <- "parent"
  if (hasName(x, locale)) 
    names(x)[names(x) == locale] <- "locale"
  if (hasName(x, missing)) {
    names(x)[names(x) == missing] <- "missing"
    x$missing <- as.logical(x$missing)
  }
  if (!isTRUE(err <- isvalidcodelist(x))) stop(err)
  structure(x, class = c("codelist", "data.frame"))
}

