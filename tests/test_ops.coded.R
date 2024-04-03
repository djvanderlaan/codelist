library(codelist)
source("helpers.R")


codelist <- data.frame(
    codes = c(10, 11, 12),
    labels = c("a", "b", "c")
  )
x <- coded(c(10, 12, NA), codelist)

expect_equal(x == 10, c(TRUE, FALSE, NA))
expect_equal(x == c(10, 12, NA), c(TRUE, TRUE, NA))
expect_equal(x == numeric(0), logical(0))

expect_equal(x != 10, c(FALSE, TRUE, NA))
expect_equal(x != c(10, 12, NA), c(FALSE, FALSE, NA))
expect_equal(x != numeric(0), logical(0))
expect_equal(x != NA, c(NA, NA, NA))

expect_error(x + 10)
expect_error(x / 10)
expect_error(x * 10)

# Both sides coded
codelist <- data.frame(
    codes = c(10, 11, 12),
    labels = c("a", "b", "c")
  )
x <- coded(c(10, 12, NA), codelist)
y <- coded(c(10), codelist)
expect_equal(x == y, c(TRUE, FALSE, NA))

# Unequal code lists
codelist <- data.frame(
    codes = c(10, 11, 12),
    labels = c("a", "b", "c")
  )
codelisty<- data.frame(
    codes = c(10, 11, 12),
    labels = c("foo", "b", "c")
  )
x <- coded(c(10, 12, NA), codelist)
y <- coded(c(10), codelisty)
expect_error(x == y)

# Invalid codes
codelist <- data.frame(
    codes = c(10, 11, 12),
    labels = c("a", "b", "c")
  )
x <- coded(c(10, 12, NA), codelist)
expect_error(x == 13)
expect_error(x == "a")

# Character
codelist <- data.frame(
    codes = c("A", "B", "C"),
    labels = c("a", "b", "c")
  )
x <- coded(c("A", "C", NA), codelist)
expect_equal(x == "A", c(TRUE, FALSE, NA))
expect_equal(x == c("A", "C", NA), c(TRUE, TRUE, NA))
expect_equal(x == numeric(0), logical(0))

