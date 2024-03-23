#' Convert vector with codes to factor using a code list
#' 
#' @param x vector with codes. Should be of the same type as the codes in the
#'   codelist.
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#'   is a valid code list.
#' @param missing convert codes that are missing value to missing values.
#' @param locale use the codes from the given locale. Should be character vector 
#'  of length 1.
#' @param droplevels remove labels that do not occur in \code{x}.
#'
#' @details
#' \code{labm} is a short hand for a call to \code{lab} with \code{missing =
#' FALSE}. It, therefore, keeps the codes that represent missing values as
#' non-missing values.
#'
#' @return 
#' A factor vector with the same length as \code{x}.
#'
#' @rdname lab
#' @export
lab <- function(x, codelist = attr(x, "codelist"), missing = TRUE, 
    locale = cllocale(codelist), droplevels = FALSE) {
  if (missing(codelist) && is.null(codelist)) 
    stop("x has no 'codelist' attribute. codelist has to be specified manually.")
  stopifnot(iscodelist(codelist))
  codelist <- clfilterlocale(codelist, preferred = locale)
  codes <- codelist$code
  labels <- codelist$label
  ok <- x %in% codes | is.na(x)
  if (!all(ok)) {
    wrong <- unique(x[!ok])
    wrong <- paste0("'", wrong, "'")
    if (length(wrong) > 5) 
      wrong <- c(utils::head(wrong, 5), "...")
    stop("Invalid values found in x: ", paste0(wrong, collapse = ","))
  }
  if (missing && utils::hasName(codelist, "missing")) {
    m <- match(x, codes)
    x[codelist$missing[m]] <- NA
    codes  <- setdiff(codes, codelist$code[codelist$missing])
    labels <- setdiff(labels, codelist$label[codelist$missing])
  }
  res <- factor(x, levels = codes, labels = labels) 
  if (droplevels) droplevels(res) else res
}

#' @rdname lab
#' @export
labm <- function(x, codelist = attr(x, "codelist"), missing = FALSE, 
    locale = cllocale(codelist), droplevels = FALSE) {
  lab(x, codelist, missing, locale, droplevels)
}

