
#' @export
coded <- function(x, codelist, ...) {
  UseMethod("coded")
}

#' @export
coded.default <- function(x, codelist = attr(x, "codelist"), ...) {
  if (!isTRUE(err <- checkwithcodelist(x, codelist)))
    stop(err)
  attr(x, "codelist") <- codelist
  class(x) <- c("coded", attr(x, "class"))
  x
}

#' @export
coded.factor <- function(x, codelist = attr(x, "codelist"), ...) {
  if (missing(codelist) && is.null(codelist)) {
    codelist <- codelist(data.frame(code = seq_len(nlevels(x)), 
        label <- levels(x)))
    x <- as.integer(x)
  }
  if (is.factor(codelist$code)) {
    codelist$code <- as.character(codelist$code)
    x <- as.character(x)
  } else if (is.character(codelist$code)) {
    x <- as.character(x)
  } else if (is.numeric(codelist$code)) {
    x <- as.integer(x)
  } else {
    stop("Codes in codelist should be either character or numeric.")
  }
  if (!isTRUE(err <- checkwithcodelist(x, codelist)))
    stop(err)
  attr(x, "levels") <- NULL
  attr(x, "codelist") <- codelist
  class(x) <- "coded"
  x
}

