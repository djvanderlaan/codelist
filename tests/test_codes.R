library(codelist)
source("helpers.R")

# In case user has set this
op <- options(CLLOCALE=NULL)

data(objectcodes)
codelist <- as.codelist(objectcodes)


# Default usage
res <- codes("Marbles", codelist)
expect_equal(res, "A03")

# Default usage; add missing values
x <- c("Hammer", "Marbles", NA)
res <- codes(x, codelist)
expect_equal(res, c("B01", "A03", NA))

# Check other locale
x <- c("Hamer", "Knikkers", NA)
expect_warning(res <- codes(x, codelist))
expect_equal(res, c("B01", "A03", NA))

# This only works if all from different locale
x <- c("Hammer", "Knikkers", NA)
expect_error(res <- codes(x, codelist))

# And only when no locale given
x <- c("Hamer", "Knikkers", NA)
expect_error(res <- codes(x, codelist, locale = "EN"))

# Non existing labels
x <- c("FOO", "Marbles", NA)
expect_error(res <- codes(x, codelist))

# Non existing labels; vector of length 1
x <- c("FOO")
expect_error(res <- codes(x, codelist))

# Empty input
x <- character(0)
res <- codes(x, codelist)
expect_equal(res, character(0))

# Only na
x <- c(NA, NA)
res <- codes(x, codelist)
expect_equal(res, c(NA_character_, NA_character_))

# Factor input
x <- factor(c("Hammer", "Marbles", NA))
res <- codes(x, codelist)
expect_equal(res, c("B01", "A03", NA))

# Pass codelist as attribute of other vector
x <- c("Hammer", "Marbles", NA)
y <- structure(c("A01"), codelist = codelist)
res <- codes(x, cl(y))
expect_equal(res, c("B01", "A03", NA))

# Different locale
x <- c("Hamer", "Knikkers", NA)
res <- codes(x, codelist, locale = "NL")
expect_equal(res, c("B01", "A03", NA))

# Invalid locale
x <- c("Hammer", "Marbles", NA)
expect_warning(res <- codes(x, codelist, locale = "FOO"))
expect_equal(res, c("B01", "A03", NA))

# Duplicate labels
cl <- rbind(codelist,
  data.frame(code = "B99", label = "Hammer", parent = "B", locale = "EN", missing = FALSE))
x <- c("Hammer", "Marbles", NA)
expect_error(res <- codes(x, cl))

# set options back to original values
options(op)
