#' Get the number of hierarchical levels in a code list
#' 
#' @param codelist the codelist for which to determine the number of levels.
#'
#' @return
#' A single integer value (>= 1) with the number of levels.
#' 
#' @export
clnlevels <- function(codelist) {
  level <- cllevels(codelist) 
  as.integer(max(level) + 1)
}
