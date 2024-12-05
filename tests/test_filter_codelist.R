library(codelist)
source("helpers.R")

# In case user has set this
op <- options(CLLOCALE=NULL)

# =============================================================================
# FILTER BY LOCALE

codelist <- data.frame(
    codes = c("A", "B", "A.1", "A.2", "B.1"),
    labels = letters[1:5],
    parent = c(NA, NA, "A", "A", "B"),
    locale = "LOWER"
  )
codelist2 <- codelist
codelist2$labels <- toupper(codelist2$labels)
codelist2$locale <- "UPPER"
codelist <- codelist(rbind(codelist, codelist2))

res <- filtercodelist(codelist, locale = "UPPER")
expect_equal(res$code, c("A", "B", "A.1", "A.2", "B.1"))
expect_equal(res$label, LETTERS[1:5])
expect_equal(res$locale, rep("UPPER", 5))

res <- filtercodelist(codelist, locale = "LOWER")
expect_equal(res$code, c("A", "B", "A.1", "A.2", "B.1"))
expect_equal(res$label, letters[1:5])
expect_equal(res$locale, rep("LOWER", 5))

res <- filtercodelist(codelist, locale = NA)
expect_equal(res$code, c("A", "B", "A.1", "A.2", "B.1"))
expect_equal(res$label, letters[1:5])
expect_equal(res$locale, rep("LOWER", 5))

expect_warning(res <- filtercodelist(codelist, locale = "FOOBAR" ))
expect_equal(res$code, c("A", "B", "A.1", "A.2", "B.1"))
expect_equal(res$label, letters[1:5])
expect_equal(res$locale, rep("LOWER", 5))

expect_error(res <- filtercodelist(codelist, locale = c("UPPER", "LOWER")))
expect_error(res <- filtercodelist(codelist, locale = character(0)))

res <- filtercodelist(codelist, level = 1, locale = "UPPER")
expect_equal(res$code, c("A.1", "A.2", "B.1"))
expect_equal(res$label, c("C", "D", "E"))
expect_equal(res$locale, rep("UPPER", 3))




# =============================================================================
# FILTER BY LEVEL

codelist <- data.frame(
    codes = c("A", "B", "A.1", "A.2", "A.1.1", "B.1", "B.1.1"),
    labels = letters[1:7],
    parent = c(NA, NA, "A", "A", "A.1", "B", "B.1")
  )
codelist <- codelist(codelist)


res <- filtercodelist(codelist, levels = 0)
expect_equal(res$code, c("A", "B"))
expect_equal(res$parent, c(NA_character_, NA_character_))

res <- filtercodelist(codelist, levels = 1)
expect_equal(res$code, c("A.1", "A.2", "B.1"))
expect_equal(res$parent, NULL)

res <- filtercodelist(codelist, levels = 2)
expect_equal(res$code, c("A.1.1", "B.1.1"))
expect_equal(res$parent, NULL)


res <- filtercodelist(codelist, levels = c(1,2))
expect_equal(res$code, c("A.1", "A.2", "A.1.1", "B.1", "B.1.1"))
expect_equal(res$parent, NULL)

res <- filtercodelist(codelist, levels = c(0,2))
expect_equal(res$code, c("A", "B", "A.1.1", "B.1.1"))
expect_equal(res$parent, NULL)

res <- filtercodelist(codelist, levels = c(0,1))
expect_equal(res$code, c("A", "B", "A.1", "A.2", "B.1"))
expect_equal(res$parent, c(NA, NA, "A", "A", "B"))

res <- filtercodelist(codelist, levels = c(0,2), check_levels = FALSE)
expect_equal(res$code, c("A", "B", "A.1.1", "B.1.1"))
expect_equal(res$parent, c(NA, NA, "A.1", "B.1"))

expect_error(res <- filtercodelist(codelist, levels = integer(0)))
expect_error(res <- filtercodelist(codelist, levels = c(0:3)))
expect_error(res <- filtercodelist(codelist, levels = "0"))


# =============================================================================
# reset options

options(op)

