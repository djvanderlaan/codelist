library(codelist)
source("helpers.R")

x <- data.frame(
    code = 11:13,
    labels = letters[1:3]
  )
res <- codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 11:13)
expect_equal(res$label, letters[1:3])

# Non default names
x <- data.frame(
    foo = 11:13,
    bar = letters[1:3]
  )
res <- codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 11:13)
expect_equal(res$label, letters[1:3])

# Labels should be character
x <- data.frame(
    code = 11:13,
    labels = 1:3
  )
expect_error(res <- codelist(x))

# Labels should be character
# TODO: it might make sense to convert factor to character
x <- data.frame(
    code = 11:13,
    labels = factor(letters[1:3])
  )
expect_error(res <- codelist(x))

# Just code
x <- data.frame(
    code = 1:3
  )
res <- codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 1:3)
expect_equal(res$label, as.character(1:3))

# Just code: even more compact
x <- data.frame(1:3)
res <- codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 1:3)
expect_equal(res$label, as.character(1:3))

# Empty set
x <- data.frame(
  code = integer(0),
  labels = character(0)
)
res <- codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(nrow(res), 0)
expect_equal(res$code, integer(0))
expect_equal(res$label, character(0))

# No columns
x <- data.frame()
expect_error(res <- codelist(x))

# Missing values in code
x <- data.frame(
    code = c(11:13, NA),
    labels = c(letters[1:3], "d")
  )
expect_error(res <- codelist(x))

# Missing values in labels
x <- data.frame(
    code = c(11:13, 14),
    labels = c(letters[1:3], NA)
  )
expect_error(res <- codelist(x))

# =================== LOCALE
# Locale
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    locale = "NL"
  )
res <- codelist(x)
expect_equal(res$locale, rep("NL", nrow(x)))

# Missing values in locale
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    locale = c("NL", "EN", NA)
  )
expect_error(res <- codelist(x))

# locale wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    locale = 1L
  )
expect_error(res <- codelist(x))

# Locale non default name
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = "NL"
  )
res <- codelist(x, locale = "foo")
expect_equal(res$locale, rep("NL", nrow(x)))

# =================== MISSING
# Missing
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    missing = TRUE
  )
res <- codelist(x)
expect_equal(res$missing, rep(TRUE, nrow(x)))

# Missing values in Missing
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    missing = c(TRUE, TRUE, NA)
  )
expect_error(res <- codelist(x))

# Missing wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    missing = "FOO"
  )
expect_error(res <- codelist(x))

# Missing non default name: an non logical
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = 1
  )
res <- codelist(x, missing = "foo")
expect_equal(res$missing, rep(TRUE, nrow(x)))

# =================== DESCRIPTION
# Description
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    description = letters[1:3]
  )
res <- codelist(x)
expect_equal(res$description, letters[1:3])

# Missing values in Description
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    description = c("foo", "bar", NA)
  )
res <- codelist(x)
expect_equal(res$description, c("foo", "bar", NA))

# Description wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    description = 1:3
  )
expect_error(res <- codelist(x))

# Description non default name: an non logical
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = c("foo", "bar", NA)
  )
res <- codelist(x, description = "foo")
expect_equal(res$description, c("foo", "bar", NA))

# =================== PARENT
# Parent
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = c(NA, 11, 11)
  )
res <- codelist(x)
expect_equal(res$parent, c(NA, 11, 11))

# Parent wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = as.character(c(NA, 11, 11))
  )
expect_error(res <- codelist(x))

# Parent non default name: an non logical
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = c(NA, 11, 11)
  )
res <- codelist(x, parent = "foo")
expect_equal(res$parent, c(NA, 11, 11))

# Non existing parent
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = c(NA, 11, 15)
  )
expect_error(res <- codelist(x))

# Non hierarchical codelist 
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = c(NA, 13, 12)
  )
expect_error(res <- codelist(x))

# All missing values in codelist
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = as.integer(c(NA, NA, NA))
  )
res <- codelist(x)
expect_equal(res$parent, as.integer(c(NA, NA, NA)))

