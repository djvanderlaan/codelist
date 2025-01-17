#' Recode codes to a higher level in a hierarchy
#'
#' @param x vector of codes to record. This can be an object of type
#' \code{\link{code}}. 
#'
#' @param level level to which to cast the codes.
#'
#' @param codelist the \code{\link{codelist}} for the codes. This code list
#' should be hierarchical will the cast have effect.
#'
#' @param over_level how to handle codes that are in a higher level than the
#' level that is cast to. The default 'error' will generate an error; 'missing'
#' will result in missing values for those codes; 'ignore' will keep these
#' codes.
#'
#' @param filter_codelist if \code{TRUE} codes with a level lower than the lever
#' cast to will be removed from the code list that is returned with the result. 
#'
#' @details
#' When handling codes that are in a higher level than the level that is cast
#' to, codes that are missing values are ignored as these are often in the
#' highest level.
#'
#' @return
#' A vector with the same length as \code{x}.
#' 
#' @examples
#' cl <- codelist(
#'     codes = c("A", "B", "A1", "A2", "B1", "B2", "A1.1", "B2.2", "X"),
#'     parent = c(NA, NA, "A", "A", "B", "B", "A1", "B2", NA),
#'     missing = c(0, 0, 0, 0, 0, 0, 0, 0, 1)
#'   )
#' x <- code(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
#' levelcast(x, 1)
#' levelcast(x, 2, over_level = "ignore")
#' levelcast(x, 0)
#'
#'@export
levelcast <- function(x, level, codelist = attr(x, "codelist"), 
    over_level = c("error", "missing", "ignore"),
    filter_codelist = TRUE) {
  over_level <- match.arg(over_level)
  stopifnot(is.numeric(level), length(level) == 1, !is.na(level))
  level <- as.integer(level)
  # Get the levels in the code list
  levels <- cl_levels(codelist)
  if (level > max(levels) | level < 0)
    stop("Requested level is not present in codelist")
  # Ignore missing values
  if (utils::hasName(codelist, "missing")) {
    levels[codelist$missing] <- NA
  }
  # Check if we currently have code with a higher level than requested
  if (over_level != "ignore") {
    m <- match(x, codelist$code)
    levelsx <- levels[m]
    sel <- levelsx < level & !is.na(levelsx)
    if (any(sel)) {
      if (over_level == "error") {
        stop("Some of the codes in x are in a level < ", level, ".")
      } else {
        x[sel] <- NA
      }
    }
  }
  # Keep casting codes to a parent level until we have reached the level
  # we want
  while (TRUE) {
    m <- match(x, codelist$code)
    levelsx <- levels[m]
    sel <- levelsx > level & !is.na(levelsx)
    if (sum(sel) == 0) break
    parent <- codelist$parent[m]
    x[sel] <- parent[sel]
  }
  # Filter codelist
  if (filter_codelist) {
    codelist <- codelist[is.na(levels) | levels <= level, ]
    attr(x, "codelist") <- codelist
  }
  x
}

