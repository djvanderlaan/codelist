library(codelist)
source("helpers.R")

cl <- codelist(
    codes = c("A", "B", "X"),
    labels = c("A", "B", "X"),
    missing = c(FALSE, FALSE, TRUE)
  )

# Codelist missing
x <- c("A", "X", NA)
res <- is.missing(x)
expect_equal(res, c(FALSE, FALSE, TRUE))
# Codelist not missing; regular use
x <- c("A", "X", NA)
res <- is.missing(x, codelist = cl)
expect_equal(res, c(FALSE, TRUE, TRUE))
# Codelist as attribute missing; regular use
x <- c("A", "X", NA)
attr(x, "codelist") <- cl
res <- is.missing(x)
expect_equal(res, c(FALSE, TRUE, TRUE))

# integer missing
cl <- data.frame(
      code = c("A", "B", "X"),
      label = c("A", "B", "X"),
      missing = c(0, 0, 1)
    )
x <- c("A", "X", NA)
res <- is.missing(x, codelist = cl)
expect_equal(res, c(FALSE, TRUE, TRUE))

# No missing codes
cl <- codelist(
      codes = c("A", "B", "X"),
      labels = c("A", "B", "X"),
      missing = c(0, 0, 0)
    )
x <- c("A", "X", NA)
res <- is.missing(x, codelist = cl)
expect_equal(res, c(FALSE, FALSE, TRUE))
# All missing codes
cl <- codelist(
      codes = c("A", "B", "X"),
      labels = c("A", "B", "X"),
      missing = c(1, 1, 1)
    )
x <- c("A", "X", NA)
res <- is.missing(x, codelist = cl)
expect_equal(res, c(TRUE, TRUE, TRUE))

# Missing missing
cl <- codelist(
      codes = c("A", "B", "X"),
      labels = c("A", "B", "X")
    )
x <- c("A", "X", NA)
res <- is.missing(x, codelist = cl)
expect_equal(res, c(FALSE, FALSE, TRUE))

# Empty x
cl <- codelist(
      codes = c("A", "B", "X"),
      labels = c("A", "B", "X"),
      missing = c(FALSE, FALSE, TRUE)
    )
x <- character(0)
res <- is.missing(x, codelist = cl)
expect_equal(res, logical(0))

# No code list
x <- c("A", "X", NA)
res <- is.missing(x)
expect_equal(res, c(FALSE, FALSE, TRUE))

