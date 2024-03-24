
library(codelist)
source("helpers.R")

# In case user has set this
op <- options(CLLOCALE=NULL)

data(objectcodes)
codelist <- codelist(objectcodes)

# Default settings
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), levels = l))

# add missing category
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist, missing = FALSE)
l   <- codelist$label[codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", "Unknown object", "Teddy Bear", NA), levels = l))

# only levels present
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist, droplevels = TRUE)
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), 
  levels = c("Toys", "Teddy Bear")))

# add missing category & only levels present
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist, missing = FALSE, droplevels = TRUE)
l   <- codelist$label[codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", "Unknown object", "Teddy Bear", NA), 
  levels = c("Toys", "Teddy Bear", "Unknown object")))

# invalid values in x
x   <- c("FOO", "X", "A01", NA)
expect_error(res <- lab(x, codelist = codelist))

# invalid codelist
x   <- c("A", "X", "A01", NA)
expect_error(res <- lab(x, codelist = "FOO"))

# Pass codelist in attribute of x
x   <- c("A", "X", "A01", NA)
attr(x, "codelist") <- codelist
res <- lab(x)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), levels = l))

# Pass codelist in attribute of x; only levels present
x   <- c("A", "X", "A01", NA)
attr(x, "codelist") <- codelist
res <- lab(x, missing = FALSE, droplevels = TRUE)
l   <- codelist$label[codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", "Unknown object", "Teddy Bear", NA), 
  levels = c("Toys", "Teddy Bear", "Unknown object")))

# set locale to NL
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist, locale = "NL")
l   <- codelist$label[codelist$code != "X" & codelist$locale == "NL"]
expect_equal(res, factor(c("Speelgoed", NA, "Teddybeer", NA), levels = l))

# set locale to EN; explicit
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist, locale = "EN")
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), levels = l))

# invalid locale
x   <- c("A", "X", "A01", NA)
expect_warning(res <- lab(x, codelist = codelist, locale = "FOO"))
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), levels = l))

# set locale to NL using option
options(CLLOCALE="NL")
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "NL"]
expect_equal(res, factor(c("Speelgoed", NA, "Teddybeer", NA), levels = l))
options(CLLOCALE=NULL)

# set locale to EN using option
options(CLLOCALE="EN")
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = codelist)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), levels = l))
options(CLLOCALE=NULL)

# empty x
x   <- character(0)
res <- lab(x, codelist = codelist)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(character(0), levels = l))

# all missing x
x   <- c(NA, NA)
res <- lab(x, codelist = codelist)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c(NA, NA), levels = l))

# x = factor
x   <- factor(c("A", "X", "A01", NA))
res <- lab(x, codelist = codelist)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), levels = l))

# labm
x   <- c("A", "X", "A01", NA)
res <- labm(x, codelist = codelist)
res2 <- lab(x, codelist = codelist, missing = FALSE)
expect_equal(res, res2)

# Do not convert to codelist
x   <- c("A", "X", "A01", NA)
res <- lab(x, codelist = objectcodes)
l   <- codelist$label[codelist$code != "X" & codelist$locale == "EN"]
expect_equal(res, factor(c("Toys", NA, "Teddy Bear", NA), levels = l))


# reset options
options(op)

