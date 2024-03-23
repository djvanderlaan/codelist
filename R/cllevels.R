
cllevels <- function(codelist) {
  if (utils::hasName(codelist, "level")) return(codelist$level)
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
