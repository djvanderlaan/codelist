#' Get the number of hierarchical levels in a code list
#' 
#' @param codelist the \code{\link{codelist}} for which to determine the number
#' of levels.
#'
#' @return
#' A single integer value (>= 1) with the number of levels.
#' 
#' @export
cl_nlevels <- function(codelist) {
  level <- cl_levels(codelist) 
  as.integer(max(level) + 1)
}
