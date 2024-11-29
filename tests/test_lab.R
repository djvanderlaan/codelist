library(codelist)
source("helpers.R")

codelist <- data.frame(
    codes = c(10, 11, 12),
    labels = c("a", "b", "c")
  )
x <- coded(c(10, 12, NA), codelist)

expect_equal(x == lab("a"), c(TRUE, FALSE, NA))
expect_equal(x == lab(c("a", "c", NA)), c(TRUE, TRUE, NA))
expect_equal(x == lab(character(0)), logical(0))
expect_equal(x == lab(numeric(0)), logical(0))
expect_equal(x == lab(NA), c(NA, NA, NA))
expect_error(x == lab("d"))


