
#' Filter an hierarchical Code List on given hierarchical levels
#'
#' @param codelist a \code{\link{codelist}} object.
#' @param level vector with levels on which to filter.
#'
#' @return 
#' Returns a \code{\link{codelist}}.
#' 
clfilterlevel <- function(codelist, level) {
  if (length(level) != 1) stop("level should be length 1")
  if (is.na(level)) return(codelist)
  levels <- cllevels(codelist)
  if (!(level %in% levels)) stop("level '", level, "' not found in levels of codelist")
  codelist[level == levels, , drop = FALSE]
}

