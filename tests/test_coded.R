library(codelist)
source("helpers.R")

codelist <- data.frame(
  code = 1:5,
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codelist <- codelist(codelist)

# Basic usage
x <- coded(c(4,4,1,NA), codelist)
expect_equal(is.numeric(x), TRUE)
expect_equal(x, c(4,4,1,NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), codelist)

# Empty input
x <- coded(numeric(0), codelist)
expect_equal(is.numeric(x), TRUE)
expect_equal(x, numeric(0), attributes = FALSE)
x <- coded(integer(0), codelist)
expect_equal(is.numeric(x), TRUE)
expect_equal(x, numeric(0), attributes = FALSE)

# Codes out of range
expect_error(x <- coded(c(6,NA), codelist))

# Codes invalid type
expect_error(x <- coded(c("Foo",NA), codelist))

# Simple codelist
x <- coded(c(4,4,1,NA), data.frame(foo = 1:5))
expect_equal(is.numeric(x), TRUE)
expect_equal(x, c(4,4,1,NA), attributes = FALSE)

# Invalid code list
expect_error(x <- coded(c(4,4,1,NA), 1:5))

# No code list
expect_error(x <- coded(c(4,4,1,NA)))

# factor input
expect_error(x <- coded(factor(c("d","d","a",NA)), codelist))


codeliststr <- data.frame(
  code = letters[1:5],
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codeliststr <- codelist(codeliststr)

# Basic usage
x <- coded(c("d","d","a",NA), codeliststr)
expect_equal(is.character(x), TRUE)
expect_equal(x, c("d","d","a",NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), codeliststr)

# Basis usage; factor input
x <- coded(factor(c("d","d","a",NA)), codeliststr)
expect_equal(is.character(x), TRUE)
expect_equal(x, c("d","d","a",NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), codeliststr)

# Only NA values
x <- coded(c(NA_character_), codeliststr)
expect_equal(is.character(x), TRUE)
expect_equal(x, c(NA_character_), attributes = FALSE)
expect_equal(attr(x, "codelist"), codeliststr)

# Wrong type
expect_error(x <- coded(c("d", "c",NA), codelist))

# No codelist factor
x <- coded(factor(c("d","d","a",NA), levels = letters[1:4]))
expect_equal(is.numeric(x), TRUE)
expect_equal(x, c(4,4,1,NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), codelist(
    data.frame(code = 1:4, label = letters[1:4])))

# FActor; no codelist; empty vector
x <- coded(factor(character(0), levels = letters[1:4]))
expect_equal(is.numeric(x), TRUE)
expect_equal(x, integer(0), attributes = FALSE)
expect_equal(attr(x, "codelist"), codelist(
    data.frame(code = 1:4, label = letters[1:4])))



