
#' @export
Ops.coded <- function(e1, e2) {
  valid_operations <- c("==", "!=")
  if (!(.Generic %in% valid_operations)) {
    stop("'", .Generic, "' is not meaningful for coded objects.")
  } 

  if (is.coded(e2)) {
    if (!isTRUE(all.equal(attr(e1, "codelist"), attr(e2, "codelist")))) 
      stop("Codelist of rhs does not match that of the lhs.")
  }
  codelist <- attr(e1, "codelist")
  if (methods::is(e2, "label")) {
    e2 <- codes(e2, cl(e1))
  } else if (ischar(e2) && ischar(codelist$code)) {
    e2 <- as.character(e2)
  } else if (all(is.na(e2))) {
    # Do nothing
  } else if (!sameclass(codelist$code, e2)) {
    stop("RHS not of the same class as the used codes of the LHS.")
  }
  if (!all(e2 %in% codelist$code | is.na(e2))) 
    stop("Invalid codes used in RHS")
  class(e1) <- NULL
  NextMethod(.Generic)
}

