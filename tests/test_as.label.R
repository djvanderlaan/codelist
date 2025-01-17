library(codelist)
source("helpers.R")

codelist <- codelist(
    code = c(10, 11, 12),
    label = c("a", "b", "c")
  )
x <- code(c(10, 12, NA), codelist)

expect_equal(x == as.label("a"), c(TRUE, FALSE, NA))
expect_equal(x == as.label(c("a", "c", NA)), c(TRUE, TRUE, NA))
expect_equal(x == as.label(character(0)), logical(0))
expect_equal(x == as.label(numeric(0)), logical(0))
expect_equal(x == as.label(NA), c(NA, NA, NA))
expect_error(x == as.label("d"))


x[3] <- as.label("a")
expect_equal(x, c(10, 12, 10), attributes = FALSE)
x[[2]] <- as.label("b")
expect_equal(x, c(10, 11, 10), attributes = FALSE)
x[1:3] <- as.label("a")
expect_equal(x, c(10, 10, 10), attributes = FALSE)
x[1:3] <- as.label(c("a", "b", NA))
expect_equal(x, c(10, 11, NA), attributes = FALSE)

expect_error( x[3] <- as.label("d") )
expect_error( x[3] <- as.label(11) )
expect_error( x[[3]] <- as.label("d") )
expect_error( x[[3]] <- as.label(11) )

