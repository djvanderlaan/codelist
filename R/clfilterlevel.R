
# Filter an hierarchical Code List on given hierarchical levels
#
# @param codelist a \code{\link{codelist}} object.
#
# @param level vector with levels on which to filter.
#
# @param check_levels if TRUE the parent column (if present) is removed from
# the result when the resulting code list would not be a valid hierarchy.
#
# @return 
# Returns a \code{\link{codelist}} with the selected levels.
# 
clfilterlevel <- function(codelist, level, check_levels = TRUE) {
  stopifnot(is.numeric(level))
  if (length(level) < 1) stop("level should be are least of length 1")
  if (any(is.na(level))) stop("Missing values in level.")
  levels <- cllevels(codelist)
  if (!all(level %in% levels)) {
    notfound <- level[!(level %in% levels)]
    stop("level '", paste0(notfound, collapse = "', '"), 
      "' not found in levels of codelist")
  }
  res <- codelist[levels %in% level, , drop = FALSE]
  if (check_levels && !all_highest_levels(level) && !is.null(res$parent)) 
    res$parent <- NULL
  res
}

all_highest_levels <- function(levels) {
  stopifnot(length(levels) > 0, !anyNA(levels))
  test <- seq(0, max(levels), by = 1)
  all(test %in% levels) 
}

