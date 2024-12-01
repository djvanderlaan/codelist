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


x[3] <- lab("a")
expect_equal(x, c(10, 12, 10), attributes = FALSE)
x[[2]] <- lab("b")
expect_equal(x, c(10, 11, 10), attributes = FALSE)
x[1:3] <- lab("a")
expect_equal(x, c(10, 10, 10), attributes = FALSE)
x[1:3] <- lab(c("a", "b", NA))
expect_equal(x, c(10, 11, NA), attributes = FALSE)

expect_error( x[3] <- lab("d") )
expect_error( x[3] <- lab(11) )
expect_error( x[[3]] <- lab("d") )
expect_error( x[[3]] <- lab(11) )

