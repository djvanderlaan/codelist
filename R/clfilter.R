#' Filter a code list
#'
#' @param codelist a \code{\link{codelist}} object.
#'
#' @param locale use the codes from the given locale. Should be character
#' vector of length 1. When NA the default locale is used (as returned by
#' \code{\link{cllocale}}.
#'
#' @param levels vector with levels on which to filter an hierarchical code list.
#' Levels are numbered from 0 with 0 the topmost level. See 'Details'. When a
#' code list does not have a 'parent' column and is, therefore, not hierarchical
#' all codes are in level 0.
#'
#' @param check_levels if TRUE the parent column (if present) is removed from
#' the result when the resulting code list would not be a valid hierarchy.
#'
#' @details
#' When a code list has a 'parent' column. The codes without parent are assigned
#' level 0. Codes with a parent in level 0 are assigned to level 1. Etc. When
#' the code list does not have a 'parent' column all codes are assigned to level
#' 0 (all codes are in the top level).
#'
#' @return 
#' Returns a \code{\link{codelist}} with the selected encoding and/or levels.
#'
#' @export
clfilter <- function(codelist, locale, levels, check_levels = TRUE) {
  if (!missing(locale)) {
    if (is.na(locale)) locale <- cllocale(codelist)
    codelist <- clfilter_by_locale(codelist, locale)
  }
  if (!missing(levels)) {
    codelist <- clfilter_by_level(codelist, levels, check_levels)
  }
  codelist
}


clfilter_by_locale <- function(codelist, 
    preferred = getOption("CLLOCALE", NA_character_)) {
  locale <- cllocale(codelist, preferred)
  if (!(missing(preferred) || is.na(preferred)) && locale != preferred) {
    warning("Preferred locale not found. Using default of '", locale, "'.")
  }
  if (utils::hasName(codelist, "locale")) {
    if (is.na(locale)) {
      codelist[is.na(codelist$locale), , drop = FALSE]
    } else {
      codelist[codelist$locale == locale, , drop = FALSE]
    }
  } else {
    codelist
  }
}

clfilter_by_level <- function(codelist, level, check_levels = TRUE) {
  stopifnot(is.numeric(level))
  if (length(level) < 1) stop("level should be are least of length 1")
  if (any(is.na(level))) stop("Missing values in level.")
  levels <- cllevels(codelist)
  if (!all(level %in% levels)) {
    notfound <- level[!(level %in% levels)]
    stop("level '", paste0(notfound, collapse = "', '"), 
      "' not found in levels of codelist")
  }
  res <- codelist[levels %in% level, , drop = FALSE]
  if (check_levels && !all_highest_levels(level) && !is.null(res$parent)) 
    res$parent <- NULL
  res
}

all_highest_levels <- function(levels) {
  stopifnot(length(levels) > 0, !anyNA(levels))
  test <- seq(0, max(levels), by = 1)
  all(test %in% levels) 
}

