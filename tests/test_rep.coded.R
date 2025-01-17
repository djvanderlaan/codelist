library(codelist)
source("helpers.R")

x <- code(factor(c("A", "B", NA)))
res <- rep(x, 2)
expect_equal(res, code(factor(c("A", "B", NA, "A", "B", NA))))

x <- code(factor(character(0), levels = c("A", "B")))
res <- rep(x, 2)
expect_equal(res, x)

