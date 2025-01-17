library(codelist)
source("helpers.R")

x <- data.frame(
    code = 11:13,
    labels = letters[1:3]
  )
res <- as.codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 11:13)
expect_equal(res$label, letters[1:3])

# Non default names
x <- data.frame(
    foo = 11:13,
    bar = letters[1:3]
  )
res <- as.codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 11:13)
expect_equal(res$label, letters[1:3])

# Labels should be character
x <- data.frame(
    code = 11:13,
    labels = 1:3
  )
expect_error(res <- as.codelist(x))

# Labels should be character
# TODO: it might make sense to convert factor to character
x <- data.frame(
    code = 11:13,
    labels = factor(letters[1:3])
  )
expect_error(res <- as.codelist(x))

# Just code
x <- data.frame(
    code = 1:3
  )
res <- as.codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 1:3)
expect_equal(res$label, as.character(1:3))

# Just code: even more compact
x <- data.frame(1:3)
res <- as.codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(res$code, 1:3)
expect_equal(res$label, as.character(1:3))

# Empty set
x <- data.frame(
  code = integer(0),
  labels = character(0)
)
res <- as.codelist(x)
expect_equal(class(res), c("codelist", "data.frame"))
expect_equal(names(res), c("code", "label"))
expect_equal(nrow(res), 0)
expect_equal(res$code, integer(0))
expect_equal(res$label, character(0))

# No columns
x <- data.frame()
expect_error(res <- as.codelist(x))

# Missing values in code
x <- data.frame(
    code = c(11:13, NA),
    labels = c(letters[1:3], "d")
  )
expect_error(res <- as.codelist(x))

# Missing values in labels
x <- data.frame(
    code = c(11:13, 14),
    labels = c(letters[1:3], NA)
  )
expect_error(res <- as.codelist(x))

# =================== LOCALE
# Locale
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    locale = "NL"
  )
res <- as.codelist(x)
expect_equal(res$locale, rep("NL", nrow(x)))

# Missing values in locale
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    locale = c("NL", "EN", NA)
  )
expect_error(res <- as.codelist(x))

# locale wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    locale = 1L
  )
expect_error(res <- as.codelist(x))

# Locale non default name
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = "NL"
  )
res <- as.codelist(x, locale = "foo")
expect_equal(res$locale, rep("NL", nrow(x)))

# =================== MISSING
# Missing
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    missing = TRUE
  )
res <- as.codelist(x)
expect_equal(res$missing, rep(TRUE, nrow(x)))

# Missing values in Missing
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    missing = c(TRUE, TRUE, NA)
  )
expect_error(res <- as.codelist(x))

# Missing wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    missing = "FOO"
  )
expect_error(res <- as.codelist(x))

# Missing non default name: an non logical
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = 1
  )
res <- as.codelist(x, missing = "foo")
expect_equal(res$missing, rep(TRUE, nrow(x)))

# =================== DESCRIPTION
# Description
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    description = letters[1:3]
  )
res <- as.codelist(x)
expect_equal(res$description, letters[1:3])

# Missing values in Description
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    description = c("foo", "bar", NA)
  )
res <- as.codelist(x)
expect_equal(res$description, c("foo", "bar", NA))

# Description wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    description = 1:3
  )
expect_error(res <- as.codelist(x))

# Description non default name: an non logical
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = c("foo", "bar", NA)
  )
res <- as.codelist(x, description = "foo")
expect_equal(res$description, c("foo", "bar", NA))

# =================== PARENT
# Parent
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = c(NA, 11, 11)
  )
res <- as.codelist(x)
expect_equal(res$parent, c(NA, 11, 11))

# Parent wrong type
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = as.character(c(NA, 11, 11))
  )
expect_error(res <- as.codelist(x))

# Parent non default name: an non logical
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    foo = c(NA, 11, 11)
  )
res <- as.codelist(x, parent = "foo")
expect_equal(res$parent, c(NA, 11, 11))

# Non existing parent
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = c(NA, 11, 15)
  )
expect_error(res <- as.codelist(x))

# Non hierarchical codelist 
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = c(NA, 13, 12)
  )
expect_error(res <- as.codelist(x))

# All missing values in codelist
x <- data.frame(
    code = 11:13,
    labels = letters[1:3],
    parent = as.integer(c(NA, NA, NA))
  )
res <- as.codelist(x)
expect_equal(res$parent, as.integer(c(NA, NA, NA)))

# Missing codes in locales
cl <- data.frame(
  code = c("a", "b", "a"),
  label = c("A", "B", "a"),
  locale = c("UPPER", "UPPER", "lower")
  )
expect_error(res <- as.codelist(cl))

# No missing codes in locale
cl <- data.frame(
  code = c("a", "b", "a", "b"),
  label = c("A", "B", "a", "b"),
  locale = c("UPPER", "UPPER", "lower", "lower")
  )
res <- as.codelist(cl) # we expect no error
expect_equal(as.data.frame(res), cl, attributes = FALSE)

# Duplicated codes in locale
cl <- data.frame(
  code = c("a", "b", "a", "b", "a"),
  label = c("A", "B", "a", "b", "a"),
  locale = c("UPPER", "UPPER", "lower", "lower", "lower")
  )
expect_error(res <- as.codelist(cl))

# Duplicated codes 
cl <- data.frame(
  code = c("a", "b", "a"),
  label = c("A", "B", "a")
  )
expect_error(res <- as.codelist(cl))

# Regression test: in earlier version code following failed. De column "label" was first
# renamed to "description"; after that both! columns "label" we renamed to "description" 
# not just the column that originally was names "label".
res <- as.codelist(data.frame(code = 1:3, label = letters[1:3], description = LETTERS[1:3]), 
  label = "description", description = "label")
expect_equal(sort(names(res)), sort(c("code", "label", "description")))
expect_equal(res$code, c(1,2,3))
expect_equal(res$label, c("A", "B", "C"))
expect_equal(res$description, c("a", "b", "c"))

# Regression test: as.codelist has problems when de code list already has a
# column code, label etc, while the column with the code and/or label are names
# differently
tmp <- data.frame(code = 1:3, label = letters[1:3], description = letters[1:3], 
  parent = c(NA, 1, 1), locale = "en", missing = c(FALSE, FALSE, TRUE),
  code2 = 11:13, label2 = LETTERS[1:3], description2 = LETTERS[1:3], 
  parent2 = c(13, 13, NA), locale2 = "nl", missing2 = c(TRUE, FALSE, FALSE))
res <- as.codelist(tmp, code = "code2", label = "label2", description = "description2",
  parent = "parent2", locale = "locale2", missing = "missing2")
expect_equal(sum(names(res) == "code"), 1)
expect_equal(sum(names(res) == "label"), 1)
expect_equal(sum(names(res) == "description"), 1)
expect_equal(sum(names(res) == "parent"), 1)
expect_equal(sum(names(res) == "locale"), 1)
expect_equal(sum(names(res) == "missing"), 1)
expect_equal(sum(names(res) == "code.orig"), 1)
expect_equal(sum(names(res) == "label.orig"), 1)
expect_equal(sum(names(res) == "description.orig"), 1)
expect_equal(sum(names(res) == "parent.orig"), 1)
expect_equal(sum(names(res) == "locale.orig"), 1)
expect_equal(sum(names(res) == "missing.orig"), 1)
expect_equal(res$code, c(11, 12, 13))
expect_equal(res$label, LETTERS[1:3])
expect_equal(res$description, LETTERS[1:3])
expect_equal(res$parent, c(13, 13, NA))
expect_equal(res$locale, c("nl", "nl", "nl"))
expect_equal(res$missing, c(TRUE, FALSE, FALSE))






# =============================================================================
# WIDE CODE LISTS


cl <- "code,label_en-UK,label_nl-NL,description_en-UK,description_nl-NL,other
A,AA,aa,DAA,Daa,1
B,BB,bb,DBB,Dbb,2
C,CC,cc,DCC,Dcc,3
" |> textConnection() |> read.csv(check.names = FALSE)

res <- as.codelist(cl, format = "wide")
expect_equal(is.data.frame(res), TRUE)
expect_equal(names(res), c("code", "label", "description", "other", "locale"))
expect_equal(res$code, c("A", "B", "C", "A", "B", "C"))
expect_equal(res$label, c("AA", "BB", "CC", "aa", "bb", "cc"))
expect_equal(res$description, c("DAA", "DBB", "DCC", "Daa", "Dbb", "Dcc"))
expect_equal(res$other, c(1 ,2, 3, 1, 2, 3))
expect_equal(res$locale, rep(c("en-UK", "nl-NL"), each = 3))

res <- as.codelist(cl, format = "wide", locales = "en-UK")
expect_equal(is.data.frame(res), TRUE)
expect_equal(names(res), c("code", "label", "label_nl-NL", "description", "description_nl-NL", "other", "locale"))
expect_equal(res$code, c("A", "B", "C"))
expect_equal(res$label, c("AA", "BB", "CC"))
expect_equal(res$description, c("DAA", "DBB", "DCC"))
expect_equal(res$other, c(1 ,2, 3))
expect_equal(res$locale, rep(c("en-UK"), each = 3))

# Non existing locale
expect_error(res <- as.codelist(cl, format = "wide", locales = "en-ERR"))
expect_error(res <- as.codelist(cl, format = "wide", locales = c("en-UK", "en-ERR")))

# Change names of columns
res <- as.codelist(cl, format = "wide", label = "description", description = "label")
expect_equal(is.data.frame(res), TRUE)
expect_equal(sort(names(res)), sort(c("code", "label", "description", "other", "locale")))
expect_equal(res$code, c("A", "B", "C", "A", "B", "C"))
expect_equal(res$description, c("AA", "BB", "CC", "aa", "bb", "cc"))
expect_equal(res$label, c("DAA", "DBB", "DCC", "Daa", "Dbb", "Dcc"))
expect_equal(res$other, c(1 ,2, 3, 1, 2, 3))
expect_equal(res$locale, rep(c("en-UK", "nl-NL"), each = 3))


# One locale
cl <- "code,label_en-UK,description_en-UK,other
A,AA,DAA,1
B,BB,DBB,2
C,CC,DCC,3
" |> textConnection() |> read.csv(check.names = FALSE)
res <- as.codelist(cl, format = "wide")
expect_equal(is.data.frame(res), TRUE)
expect_equal(names(res), c("code", "label", "description", "other", "locale"))
expect_equal(res$code, c("A", "B", "C"))
expect_equal(res$label, c("AA", "BB", "CC"))
expect_equal(res$description, c("DAA", "DBB", "DCC"))
expect_equal(res$other, c(1 ,2, 3))
expect_equal(res$locale, rep(c("en-UK"), each = 3))

# Different sep
cl <- "code,label%en-UK,description%en-UK,other
A,AA,DAA,1
B,BB,DBB,2
C,CC,DCC,3
" |> textConnection() |> read.csv(check.names = FALSE)
res <- as.codelist(cl, format = "wide", locale_sep = "%")
expect_equal(is.data.frame(res), TRUE)
expect_equal(names(res), c("code", "label", "description", "other", "locale"))
expect_equal(res$code, c("A", "B", "C"))
expect_equal(res$label, c("AA", "BB", "CC"))
expect_equal(res$description, c("DAA", "DBB", "DCC"))
expect_equal(res$other, c(1 ,2, 3))
expect_equal(res$locale, rep(c("en-UK"), each = 3))

# Additional columns varying per locale
cl <- "code,label_en-UK,label_nl-NL,description_en-UK,description_nl-NL,other_nl-NL, other_en-UK
A,AA,aa,DAA,Daa,1,11
B,BB,bb,DBB,Dbb,2,22
C,CC,cc,DCC,Dcc,3,33
" |> textConnection() |> read.csv(check.names = FALSE)
res <- as.codelist(cl, format = "wide")
expect_equal(is.data.frame(res), TRUE)
expect_equal(names(res), c("code", "label", "description", "other", "locale"))
expect_equal(res$code, c("A", "B", "C", "A", "B", "C"))
expect_equal(res$label, c("AA", "BB", "CC", "aa", "bb", "cc"))
expect_equal(res$description, c("DAA", "DBB", "DCC", "Daa", "Dbb", "Dcc"))
expect_equal(res$other, c(11 ,22, 33, 1, 2, 3))
expect_equal(res$locale, rep(c("en-UK", "nl-NL"), each = 3))







