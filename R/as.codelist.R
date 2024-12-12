#' Convert an object to a codelist object
#'
#' @param x data.frame with the code list
#' @param code the name of the column in \code{x} containing the codes.
#' @param label the name of the column in \code{x} containing the labels of 
#'   the codes.
#' @param description the name of the column in \code{x} containing the labels
#'   of the codes.
#' @param parent the name of the column in \code{x} containing the parents
#'   of the codes in case of a hierarchical code list.
#' @param locale the name of the column in \code{x} containing the locale of 
#'   the corresponding row. 
#' @param missing the name of the column in \code{x} indicating whether or not 
#'   a given code should be treated as missing values.
#' @param ... used to pass extra arguments on to other methods.
#'
#' @details
#' When there is no column with the name given by \code{label} in \code{x}, a
#' new column 'label' is derived containing codes converted to character.
#'
#' @seealso
#' \code{\link{codelist}} for a description of the \code{codelist} object.
#'
#' @return
#' Returns a \code{\link{codelist}} object which is a \code{data.frame} with at
#' minimum the columns 'code' and 'label' and optionally 'description',
#' 'parent', 'locale' and 'missing'. When \code{x} contains additional columns
#' these are kept. 
#' 
#' @rdname as.codelist
#' @export
as.codelist <- function(x, ...) {
  UseMethod("as.codelist")
}


#' @rdname as.codelist
#' @export
as.codelist.data.frame <- function(x, code = names(x)[1], label = names(x)[2], 
    description = "description", parent = "parent", locale = "locale",
    missing = "missing", ...) {
  if (!is.data.frame(x)) stop("x should be a data.frame")
  if (!ncol(x) >= 1) stop("x should have at least 1 column")
  # Make sure the columns have the correct name
  if (utils::hasName(x, code)) 
    names(x)[names(x) == code] <- "code"
  if (utils::hasName(x, label)) {
    names(x)[names(x) == label] <- "label"
  } else {
    x$label <- as.character(x$code)
  }
  if (utils::hasName(x, description)) 
    names(x)[names(x) == description] <- "description"
  if (utils::hasName(x, parent)) 
    names(x)[names(x) == parent] <- "parent"
  if (utils::hasName(x, locale)) 
    names(x)[names(x) == locale] <- "locale"
  if (utils::hasName(x, missing)) {
    names(x)[names(x) == missing] <- "missing"
    x$missing <- as.logical(x$missing)
  }
  if (!isTRUE(err <- clisvalid(x))) stop(err)
  structure(x, class = c("codelist", "data.frame"))
}

