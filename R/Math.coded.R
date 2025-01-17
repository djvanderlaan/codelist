
#' @export
Math.code <- function (x, ...) {
  stop(gettextf("%s not meaningful for code objects", sQuote(.Generic))) 
}

