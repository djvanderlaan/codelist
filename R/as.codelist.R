#' Convert an object to a codelist object
#'
#' @param x data.frame with the code list
#'
#' @param code the name of the column in \code{x} containing the codes.
#'
#' @param label the name of the column in \code{x} containing the labels of the
#' codes.
#'
#' @param description the name of the column in \code{x} containing the labels
#' of the codes.
#'
#' @param parent the name of the column in \code{x} containing the parents of
#' the codes in case of a hierarchical code list.
#'
#' @param locale the name of the column in \code{x} containing the locale of
#' the corresponding row. 
#'
#' @param missing the name of the column in \code{x} indicating whether or not
#' a given code should be treated as missing values.
#'
#' @param format the format of data.frame. In case of 'wide', it is assummed that
#' columns are repeated for each locale. For example there are columns
#' 'label_locale1' and 'label_locale2'. In case of 'regular' there are multiple
#' rows one for each locale.
#'
#' @param locales only used for \code{format = "wide"}. The locales in the data
#' set.
#' 
#' @param locale_sep the separator separating the locale from the column name.
#' This is interpreted as a regular expression (see the 'split' argument of
#' \code{\link{strsplit}}). The part of the column name until the first
#' separator is the column name; the remainder the locale name. 
#'
#' @param ... used to pass extra arguments on to other methods.
#'
#'
#' @details
#' When there is no column with the name given by \code{label} in \code{x}, a
#' new column 'label' is derived containing codes converted to character.
#'
#' @seealso
#' \code{\link{codelist}} for a description of the \code{codelist} object.
#'
#' @return
#' Returns a \code{\link{codelist}} object which is a \code{data.frame} with at
#' minimum the columns 'code' and 'label' and optionally 'description',
#' 'parent', 'locale' and 'missing'. When \code{x} contains additional columns
#' these are kept. 
#'
#' @examples
#'
#' # Examples below show the same codelist in both regular and wide format
#' dta <- data.frame(codes = c(1:3, 1:3), 
#'   labels = c(letters[1:3], LETTERS[1:3]), 
#'   locale = c("en", "en", "en", "nl" ,"nl" ,"nl"))
#' as.codelist(dta, format = "regular")
#'
#' dta <- data.frame(codes = 1:3, labels_en = letters[1:3], 
#'   labels_nl = LETTERS[1:3])
#' as.codelist(dta, format = "wide")
#' 
#' @rdname as.codelist
#' @export
as.codelist <- function(x, ...) {
  UseMethod("as.codelist")
}

#' @rdname as.codelist
#' @export
as.codelist.codelist <- function(x, ...) {
  x
}

#' @rdname as.codelist
#' @export
as.codelist.data.frame <- function(x, code = names(x)[1], label = names(x)[2], 
    description = "description", parent = "parent", locale = "locale",
    missing = "missing", 
    format = c("regular", "wide"), locales = NULL, locale_sep = "[-_@. ]", 
    ...) {
  if (!is.data.frame(x)) stop("x should be a data.frame")
  if (!ncol(x) >= 1) stop("x should have at least 1 column")
  if (any(duplicated(names(x)))) stop("x has duplicated column names")
  # Handle different formats
  format <- match.arg(format)
  if (format == "wide") {
    if (missing(code)) code <- NULL
    if (missing(label)) label <- NULL
    return(as.codelist_wide(x, code, label, description, parent, missing, 
        locales, locale_sep, ...))
  }
  # Make sure the columns have the correct name
  orignames <- names(x)
  if (code %in% orignames) {
    names(x)[orignames == "code"] <- "code.orig"
    names(x)[orignames == code] <- "code"
  }
  if (label %in% orignames) {
    names(x)[orignames == "label"] <- "label.orig"
    names(x)[orignames == label] <- "label"
  } else {
    x$label <- as.character(x$code)
  }
  if (description %in% orignames) {
    names(x)[orignames == "description"] <- "description.orig"
    names(x)[orignames == description] <- "description"
  }
  if (parent %in% orignames) {
    names(x)[orignames == "parent"] <- "parent.orig"
    names(x)[orignames == parent] <- "parent"
  }
  if (locale %in% orignames) {
    names(x)[orignames == "locale"] <- "locale.orig"
    names(x)[orignames == locale] <- "locale"
  }
  if (missing %in% orignames) {
    names(x)[orignames == "missing"] <- "missing.orig"
    names(x)[orignames == missing] <- "missing"
    x$missing <- as.logical(x$missing)
  }
  if (!isTRUE(err <- cl_is_valid(x))) stop(err)
  structure(x, class = c("codelist", "data.frame"))
}




as.codelist_wide <- function(x, code = NULL, label = NULL, 
      description = "description", parent = "parent", missing = "missing", 
      locales = NULL, locale_sep = "[-_@. ]", verbose = 1, ...) {
  # Split the column names on locale_sep - everything after the first separator
  # could be a locale name; the remainer the actual column names
  nchar <- strsplit(names(x), locale_sep) |> sapply(FUN = \(x) nchar(x[1]))
  names <- substr(names(x), 1, nchar)
  possible_locales <- substr(names(x), nchar+2, 100000L)
  # Determine the column name (without locale) that contains the code and 
  # the column names that contains the label
  if (missing(code) || is.null(code)) code <- names[1]
  if (missing(label) || is.null(label)) label <- names[2]
  # When the locale is not given we take all columns with labels and look what
  # the 'locales' are that are used in these columns
  if (missing(locales) || is.null(locales))  {
    locales <- possible_locales[names == label]
    if (verbose > 0) {
      message(paste0("Locales detected: ", 
          paste0("'", locales, "'", collapse = ", "), "."))
    }
  }
  if (length(locales) == 0 || all(locales == "")) 
    stop("No locales found in x.")
  if (anyNA(locales)) stop("Missing values in locales.")
  # Besides the label there can also be other column that have diferent values
  # for different locales; look for thore
  localised_columns <- lapply(locales, function(locale) {
    grep(paste0(locale_sep, locale, "$"), names(x))
  })
  ncol <- sapply(localised_columns, length) |> unique() #|> length()
  if (any(ncol) == 0) stop("Could not find columns with locale in x.")
  if (length(ncol) != 1) stop("The number of columns varies per locale.")
  non_localised_columns <- setdiff(seq_len(ncol(x)), unlist(localised_columns))
  # Get a codelist for each locale
  res <- lapply(seq_along(locales), function(i) {
    sel <- c(non_localised_columns, localised_columns[[i]]) |> sort()
    tmp <- x[, sel, drop = FALSE]
    names(tmp) <- gsub(paste0(locale_sep, locales[i], "$"), "", names(tmp))
    tmp$locale <- locales[i]
    tmp
  })
  res <- do.call(rbind, res)
  # Convert to codelist
  as.codelist(res, code = code, label = label, description = description, 
    parent = parent, missing = missing, locale = "locale", ...)
}

