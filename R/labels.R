#' Convert vector with codes to factor using a code list
#' 
#' @param object vector with codes. Should be of the same type as the codes in
#' the codelist.
#'
#' @param x vector with codes. Should be of the same type as the codes in the
#' codelist.
#'
#' @param codelist a \code{\link{codelist}} object or a \code{data.frame} that
#' is a valid code list.
#'
#' @param missing convert codes that are missing value to missing values.
#'
#' @param locale use the codes from the given locale. Should be character
#' vector of length 1.
#'
#' @param droplevels remove labels that do not occur in \code{x}.
#'
#' @param ... ignored
#'
#' @details
#' \code{to_labels} calls \code{labels.code} directly and is meant as a
#' substitute for \code{labels.code} for objects that are not of type 'code'.
#' 
#' @return 
#' A factor vector with the same length as \code{x}.
#'
#' @examples
#' data(objectsales)
#' data(objectcodes)
#' objectsales$product <- code(objectsales$product, objectcodes)
#' 
#' labels(objectsales$product) |> 
#'   table(useNA = "ifany")
#' labels(objectsales$product, missing = FALSE) |> 
#'   table(useNA = "ifany")
#' labels(objectsales$product, droplevels = TRUE) |> 
#'   table(useNA = "ifany")
#'
#' to_labels(c("A", "B"), codelist = objectcodes)
#' # is the same as 
#' labels.code(c("A", "B"), codelist = objectcodes)
#'
#' @rdname labels
#' @export labels.code
#' @exportS3Method base::labels
labels.code <- function(object, missing = TRUE, droplevels = FALSE, 
    codelist = attr(object, "codelist"), locale = cl_locale(codelist), ...) {
  if (missing(codelist) && is.null(codelist)) 
    stop("object has no 'codelist' attribute. codelist has to be specified manually.")
  stopifnot(is.codelist(codelist))
  codelist <- cl_filter(codelist, locale = locale)
  codes <- codelist$code
  labels <- codelist$label
  ok <- as.vector(object) %in% codes | is.na(object)
  if (!all(ok)) {
    wrong <- unique(object[!ok])
    wrong <- paste0("'", wrong, "'")
    if (length(wrong) > 5) 
      wrong <- c(utils::head(wrong, 5), "...")
    stop("Invalid values found in object: ", paste0(wrong, collapse = ","))
  }
  if (missing && utils::hasName(codelist, "missing")) {
    m <- match(object, codes)
    codelist$missing <- as.logical(codelist$missing)
    object[codelist$missing[m]] <- NA
    codes  <- setdiff(codes, codelist$code[codelist$missing])
    labels <- setdiff(labels, codelist$label[codelist$missing])
  }
  res <- factor(object, levels = codes, labels = labels) 
  if (droplevels) droplevels(res) else res
}

#' @rdname labels
#' @export
to_labels <- function(x, codelist = attr(x, "codelist"), missing = TRUE, 
    droplevels = FALSE, locale = cl_locale(codelist)) {
  labels.code(x, missing = missing, droplevels = droplevels, 
    codelist = codelist, locale = locale)
}

