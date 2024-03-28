library(codelist)
source("helpers.R")

codelist <- data.frame(
  code = 1:5,
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codelist <- codelist(codelist)

codeliststr <- data.frame(
  code = letters[1:5],
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codeliststr <- codelist(codeliststr)

# Following does nog give error
expect_error(x <- coded(c("d", "c",NA), codelist))


