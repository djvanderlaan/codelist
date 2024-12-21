#' Get the hierarchical level for each code in a code list
#'
#' @param codelist the \code{\link{codelist}} for which to determin the levels.
#' 
#' @details
#' Levels are numbered with 0 being the top-most level, which contains code
#' without parent (parent missing). In level 1 are codes that have a parent in
#' level 0. Etc.
#' 
#' When the code list does not have a 'parent' column, all codes are in level 0.
#' @return
#' An integer vector with the same length as the number of rows in the code
#' list.
#' 
#' @examples
#' data(objectcodes)
#' cl_levels(objectcodes)
#'
#' @export
cl_levels <- function(codelist) {
  if (!utils::hasName(codelist, "parent")) return(integer(nrow(codelist)))
  levels <- ifelse(is.na(codelist$parent), 0L, NA_integer_)
  if (all(is.na(levels))) 
    stop("There does not seem to be a toplevel code (with <NA> as parent)")
  current_level <- 1L
  while (TRUE) {
    l <- codelist$code[!is.na(levels) & levels == current_level-1L]
    if (length(l) == 0) break
    s <- codelist$parent %in% l
    s <- s & is.na(levels)
    levels[s] <- current_level
    current_level <- current_level+1L
  }
  levels
}

