#' Format a code object for pretty printing
#'
#' @param x a \code{\link{code}} object
#' @param maxlen maximum length of the label. A length of 0 or lower will
#' suppress adding the label to the output.
#' @param ... ignored
#'
#' When \code{maxlen} is one or larger function will add the label of the code
#' to the code in square brackets. When the label is larger than \code{maxlen}
#' the label will be truncated.
#'
#' @return
#' A character vector with the formatted code.
#'
#' @export
format.code <- function(x, maxlen = getOption("CLMAXLEN", 8L), ...) {
  uncoded <- function(x) {
    class(x) <- setdiff(class(x), "code")
    attr(x, "codelist") <- NULL
    x
  }
  if (maxlen <= 0 || is.na(maxlen) || is.null(maxlen)) {
    format(uncoded(x))
  } else {
    l <- as.character(to_labels(x, missing = FALSE))
    l <- ifelse(nchar(l) > maxlen, paste0(substr(l, 1L, maxlen-1L), "\u2026"), l)
    l <- ifelse(is.na(x), "", paste0("[", l, "]"))
    paste0(format(uncoded(x)), format(l))
  }
}

