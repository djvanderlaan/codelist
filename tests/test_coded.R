library(codelist)
source("helpers.R")

codelist <- data.frame(
  code = 1:5,
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codelist <- as.codelist(codelist)

# Basic usage
x <- code(c(4,4,1,NA), codelist)
expect_equal(is.numeric(x), TRUE)
expect_equal(x, c(4,4,1,NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), codelist)

# Empty input
x <- code(numeric(0), codelist)
expect_equal(is.numeric(x), TRUE)
expect_equal(x, numeric(0), attributes = FALSE)
x <- code(integer(0), codelist)
expect_equal(is.numeric(x), TRUE)
expect_equal(x, numeric(0), attributes = FALSE)

# Codes out of range
expect_error(x <- code(c(6,NA), codelist))

# Codes invalid type
expect_error(x <- code(c("Foo",NA), codelist))

# Simple codelist
x <- code(c(4,4,1,NA), data.frame(foo = 1:5))
expect_equal(is.numeric(x), TRUE)
expect_equal(x, c(4,4,1,NA), attributes = FALSE)

# Invalid code list
expect_error(x <- code(c(4,4,1,NA), 1:5))

# No code list
expect_error(x <- code(c(4,4,1,NA)))

# factor input
expect_error(x <- code(factor(c("d","d","a",NA)), codelist))


codeliststr <- data.frame(
  code = letters[1:5],
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codeliststr <- as.codelist(codeliststr)

# Basic usage
x <- code(c("d","d","a",NA), codeliststr)
expect_equal(is.character(x), TRUE)
expect_equal(x, c("d","d","a",NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), codeliststr)

# Basis usage; factor input
x <- code(factor(c("d","d","a",NA)), codeliststr)
expect_equal(is.character(x), TRUE)
expect_equal(x, c("d","d","a",NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), codeliststr)

# Only NA values
x <- code(c(NA_character_), codeliststr)
expect_equal(is.character(x), TRUE)
expect_equal(x, c(NA_character_), attributes = FALSE)
expect_equal(attr(x, "codelist"), codeliststr)

# Wrong type
expect_error(x <- code(c("d", "c",NA), codelist))

# No codelist factor
x <- code(factor(c("d","d","a",NA), levels = letters[1:4]))
expect_equal(is.numeric(x), TRUE)
expect_equal(x, c(4,4,1,NA), attributes = FALSE)
expect_equal(attr(x, "codelist"), as.codelist(
    data.frame(code = 1:4, label = letters[1:4])))

# FActor; no codelist; empty vector
x <- code(factor(character(0), levels = letters[1:4]))
expect_equal(is.numeric(x), TRUE)
expect_equal(x, integer(0), attributes = FALSE)
expect_equal(attr(x, "codelist"), as.codelist(
    data.frame(code = 1:4, label = letters[1:4])))



