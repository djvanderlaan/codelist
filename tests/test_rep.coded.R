library(codelist)
source("helpers.R")

x <- coded(factor(c("A", "B", NA)))
res <- rep(x, 2)
expect_equal(res, coded(factor(c("A", "B", NA, "A", "B", NA))))

x <- coded(factor(character(0), levels = c("A", "B")))
res <- rep(x, 2)
expect_equal(res, x)

