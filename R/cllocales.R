#' @export
cllocales <- function(codelist) {
  if (hasName(codelist, "locale")) {
    codelist$locale |> unique() |> removena()
  } else NA_character_
}


removena <- function(x) {
  x[!is.na(x)]
}
