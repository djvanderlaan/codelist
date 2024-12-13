library(codelist)
source("helpers.R")


cl <- codelist(
    codes = c("A", "B", "A1", "A2", "B1", "B2", "A1.1", "B2.2", "X"),
    parent = c(NA, NA, "A", "A", "B", "B", "A1", "B2", NA),
    missing = c(0, 0, 0, 0, 0, 0, 0, 0, 1)
  )

x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
res <- levelcast(x, 1)
expect_equal(res, c("A1", "A1", "A2", "B2", "B2", NA, "B2", "X"), 
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, cl[nchar(cl$code) < 4, ], attributes = FALSE)

x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
res <- levelcast(x, 1, filter_codelist = FALSE)
expect_equal(res, c("A1", "A1", "A2", "B2", "B2", NA, "B2", "X"), 
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, cl, attributes = FALSE)

x <- c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X")
res <- levelcast(x, 1, codelist = cl)
expect_equal(res, c("A1", "A1", "A2", "B2", "B2", NA, "B2", "X"), 
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, cl[nchar(cl$code) < 4, ], attributes = FALSE)

x <- c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X")
res <- levelcast(x, 1, codelist = cl, filter_codelist = FALSE)
expect_equal(res, c("A1", "A1", "A2", "B2", "B2", NA, "B2", "X"), 
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, NULL)


x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
expect_error(levelcast(x, 2))

x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
expect_error(levelcast(x, 2, over_level = TRUE))

x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
res <- levelcast(x, 2, over_level = "ignore")
expect_equal(res, x, 
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, cl, attributes = FALSE)

x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
res <- levelcast(x, 2, over_level = "missing")
expect_equal(res, c("A1.1", NA, NA, "B2.2", "B2.2", NA, NA, "X"),
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, cl, attributes = FALSE)


x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
res <- levelcast(x, 0)
expect_equal(res, c("A", "A", "A", "B", "B", NA, "B", "X"), 
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, cl[nchar(cl$code) < 2, ], attributes = FALSE)

x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
expect_error(levelcast(x, 3, over_level = "ignore"))
expect_error(levelcast(x, -1, over_level = "ignore"))
expect_error(levelcast(x, NA, over_level = "ignore"))
expect_error(levelcast(x, c(1,2), over_level = "ignore"))
expect_error(levelcast(x, integer(0), over_level = "ignore"))
expect_error(levelcast(x, "0", over_level = "ignore"))

cl <- codelist(
    codes = c("A", "B", "A1", "A2", "B1", "B2", "A1.1", "B2.2", "X"),
    missing = c(0, 0, 0, 0, 0, 0, 0, 0, 1)
  )
x <- coded(c("A1.1", "A1", "A2", "B2.2", "B2.2", NA, "B2", "X"), cl)
res <- levelcast(x, 0)
expect_equal(res, x,
  attributes = FALSE)
clres <- attr(res, "codelist")
expect_equal(clres, cl, attributes = FALSE)

