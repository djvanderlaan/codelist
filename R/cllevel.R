#' @export
cllevel <- function(x, codelist) {
  if (!isTRUE(err <- checkwithcodelist(x, codelist, TRUE))) stop(err)
  codes <- codelist$code
  levels <- cllevels(codelist)
  levels[match(x, codes)]
}


#cllevel(c("A01", "B01"), cl)
#cllevel(c("A", "B01"), cl)
#cllevel(c("A", "B"), cl)
#cllevel(c("A01", "B03"), cl)
#cllevel(c("A01", NA), cl)
#cllevel(c(NA, NA), cl)
#cllevel(c(), cl)
#cllevel(c(1:2), cl)
#cllevel(c("A", "B01"), cl, unique = FALSE)


