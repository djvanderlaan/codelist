library(codelist)
source("helpers.R")

x <- code(factor(letters[1:3]))
length(x) <- 5
expect_equal(x, code(factor(c(letters[1:3], NA, NA))))
length(x) <- 2
x <- code(factor(letters[1:2], levels = letters[1:3]))
length(x) <- 0
x <- code(factor(character(0), levels = letters[1:3]))
expect_error(length(x) <- -1)
