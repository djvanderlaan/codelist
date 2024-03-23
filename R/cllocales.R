

cllocales <- function(codelist) {
  if (utils::hasName(codelist, "locale")) {
    codelist$locale |> unique() |> removena()
  } else NA_character_
}


removena <- function(x) {
  x[!is.na(x)]
}
