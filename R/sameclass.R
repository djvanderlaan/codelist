
sameclass <- function(x, y) {
  ischar <- function(x) {
    is.character(x) || is.factor(x)
  }
  if (is.numeric(x) && is.numeric(y)) {
    TRUE
  } else if (ischar(x) && ischar(y)) {
    TRUE
  } else {
    isTRUE(all.equal(class(x), class(y)))
  }
}

