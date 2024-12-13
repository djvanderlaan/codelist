library(codelist)
source("helpers.R")

cl <- codelist(
    code = c("A", "B")
  )
expect_equal(clnlevels(cl), 1L)

cl <- codelist(
    code = c("A", "A.1", "B"),
    parent = c(NA, "A", NA)
  )
expect_equal(clnlevels(cl), 2L)

cl <- codelist(
    code = c("A", "A.1", "A.1.1", "B"),
    parent = c(NA, "A", "A.1", NA)
  )
expect_equal(clnlevels(cl), 3L)

cl <- data.frame(
    code = c("A", "A.1", "A.1.1", "B"),
    parent = c(NA, "A", "A.1", NA)
  )
expect_equal(clnlevels(cl), 3L)


cl <- data.frame(
    code = c("A", "A.1", "A.1.1", "B"),
    parent = c("A", "A", "A.1", "A")
  )
expect_error(clnlevels(cl))

cl <- data.frame(
    code = c("A", "A.1.1", "B"),
    parent = c(NA, "A.1", NA)
  )
expect_error(clnlevels(cl[FALSE,]))

