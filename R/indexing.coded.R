
#' @export
`[.code` <- function(x, ...) {
  y <- NextMethod(x)
  class(y) <- oldClass(x)
  attr(y, "codelist") <- attr(x, "codelist")
  y
}

#' @export
`[<-.code` <- function(x, ..., value) {
  if (is.code(value)) {
    if (!isTRUE(all.equal(attr(x, "codelist"), attr(value, "codelist")))) 
      stop("Codelist of value does not match that of the vector assigned to.")
  }
  codelist <- attr(x, "codelist")
  if (methods::is(value, "label")) {
    value <- codes(value, codelist)
  } else if (ischar(value) && ischar(codelist$code)) {
    value <- as.character(value)
  } else if (all(is.na(value))) {
    # Do nothing
  } else if (!sameclass(codelist$code, value)) {
    stop("value not of the same class as the used code.")
  }
  if (!all(value %in% codelist$code | is.na(value))) 
    stop("Invalid codes used in value.")
  class <- oldClass(x)
  class(x) <- NULL
  x[...] <- value
  class(x) <- class
  x
}


#' @export
`[[.code` <- function(x, ...) {
  y <- NextMethod(x)
  class(y) <- oldClass(x)
  attr(y, "codelist") <- attr(x, "codelist")
  y
}

#' @export
`[[<-.code` <- function(x, ..., value) {
  if (is.code(value)) {
    if (!isTRUE(all.equal(attr(x, "codelist"), attr(value, "codelist")))) 
      stop("Codelist of value does not match that of the vector assigned to.")
  }
  codelist <- attr(x, "codelist")
  if (methods::is(value, "label")) {
    value <- codes(value, codelist)
  } else if (ischar(value) && ischar(codelist$code)) {
    value <- as.character(value)
  } else if (all(is.na(value))) {
    # Do nothing
  } else if (!sameclass(codelist$code, value)) {
    stop("value not of the same class as the used code.")
  }
  if (!all(value %in% codelist$code | is.na(value))) 
    stop("Invalid codes used in value.")
  class <- oldClass(x)
  class(x) <- NULL
  x[[...]] <- value
  class(x) <- class
  x
}

