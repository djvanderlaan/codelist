
#' Check if the values in x match those in the code list
#' 
#' @param x the vector with values to check
#' @param codelist a codelist
#' @param check_codelist check if codelist is a valid code list
#'
#' @return
#' When \code{X} is not valid the function returns a character vector with the
#' reason why \code{x} is not valie. When \code{x} is valid it returns the value
#' \code{TRUE}. Therefore, the result cannot directly be used in, for example,
#' an \code{if} statement. Use \code{\link{isTRUE}}. 
#'
checkwithcodelist <- function(x, codelist, check_codelist = TRUE) {
  if (check_codelist) {
    if (!isTRUE(err <- isvalidcodelist(codelist))) return(err)
  }
  if (length(x) == 0 || all(is.na(x))) return(TRUE)
  codes <- codelist$code
  ok <- x %in% codes | is.na(x)
  if (!all(ok)) {
    wrong <- unique(x[!ok])
    wrong <- paste0("'", wrong, "'")
    if (length(wrong) > 5) 
      wrong <- c(utils::head(wrong, 5), "...")
    paste0("Invalid values found in x: ", paste0(wrong, collapse = ","))
  } else TRUE
}
