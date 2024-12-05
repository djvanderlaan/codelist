#' @export
print.coded <- function(x, ...) {
  xx <- x
  attr(xx, "codelist") <- NULL
  attr(xx, "class") <- setdiff(class(x), "coded")
  print(xx, quote = FALSE, ...)
  codelist <- attr(x, "codelist")
  codelist <- filtercodelist(codelist, locale = NA)
  width <- getOption("width")
  header <- "Codelist:"
  str <- paste0(codelist$code, "(=", codelist$label, ")")
  colsep = " " 
  n <- length(str)
  width <- width - (nchar(header, "w") + 3L + 1L + 3L)
  lenl  <- cumsum(nchar(str, "w") + nchar(colsep, "w"))
  maxl  <- if (n <= 1L || lenl[n] <= width) n else 
            max(1L, which.max(lenl > width) - 1L)
  drop  <- length(str) > maxl
  if (drop) {
    cat(
      format(n), 
      header, 
      paste(c(str[1L:max(1, maxl - 1)], "..."), sep = colsep)
    )
    if (maxl > 1) cat(str[n])
    cat("\n")
  } else {
    cat(
      header, 
      paste(str, sep = colsep),
      "\n"
    )
  }
}

