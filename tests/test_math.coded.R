library(codelist)
source("helpers.R")


codelist <- data.frame(
    codes = c(10, 11, 12),
    labels = c("a", "b", "c")
  )
x <- code(c(10, 12, NA), codelist)

# log etc should not work
expect_error(log(x))
expect_error(tan(x))
expect_error(abs(x))
