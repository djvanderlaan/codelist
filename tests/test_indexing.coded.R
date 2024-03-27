library(codelist)
source("helpers.R")

codelist <- data.frame(
  code = 1:5,
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codelist <- codelist(codelist)

# Various integer indexes
x <- c(4,3,2,NA)
x <- coded(x, codelist)
res <- x[2:4]
expect_equal(res, coded(c(3,2,NA), codelist))
res <- x[4]
expect_equal(res, coded(c(NA_integer_), codelist))
res <- x[5]
expect_equal(res, coded(c(NA_integer_), codelist))
res <- x[-2]
expect_equal(res, coded(c(4,2,NA), codelist))
res <- x[integer(0)]
expect_equal(res, coded(integer(0), codelist))

# Various logical indexes
x <- c(4,3,2,NA)
x <- coded(x, codelist)
res <- x[c(FALSE, TRUE, TRUE, TRUE)]
expect_equal(res, coded(c(3,2,NA), codelist))
res <- x[c(FALSE, FALSE, FALSE, TRUE)]
expect_equal(res, coded(c(NA_integer_), codelist))
res <- x[c(NA, TRUE, FALSE, FALSE)]
expect_equal(res, coded(c(NA_integer_, 3), codelist))
res <- x[c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE)]
expect_equal(res, coded(c(NA_integer_, NA_integer_), codelist))
res <- x[TRUE]
expect_equal(res, x)
res <- x[FALSE]
expect_equal(res, coded(integer(0), codelist))
res <- x[logical(0)]
expect_equal(res, coded(integer(0), codelist))

# Assignment integer indices; regular
x <- coded(c(4,3,NA), codelist)
x[3] <- 5
expect_equal(x, coded(c(4,3,5), codelist))
x <- coded(c(4,3,NA), codelist)
x[4] <- 5
expect_equal(x, coded(c(4,3,NA,5), codelist))
x <- coded(c(4,3,NA), codelist)
x[1:2] <- 5
expect_equal(x, coded(c(5,5,NA), codelist))
x <- coded(c(4,3,NA), codelist)
expect_warning(x[1] <- 4:5)
expect_equal(x, coded(c(4,3,NA), codelist))
x <- coded(c(4,3,NA), codelist)
x[integer(0)] <- integer(0)
expect_equal(x, coded(c(4,3,NA), codelist))

# Assignment logical indices; regular
x <- coded(c(4,3,NA), codelist)
x[c(FALSE, FALSE, TRUE)] <- 5
expect_equal(x, coded(c(4,3,5), codelist))
x <- coded(c(4,3,NA), codelist)
x[c(FALSE, FALSE, FALSE, TRUE)] <- 5
expect_equal(x, coded(c(4,3,NA,5), codelist))
x <- coded(c(4,3,NA), codelist)
x[c(TRUE, TRUE, FALSE)] <- 5
expect_equal(x, coded(c(5,5,NA), codelist))
x <- coded(c(4,3,NA), codelist)
expect_warning(x[c(TRUE, FALSE, FALSE)] <- 4:5)
expect_equal(x, coded(c(4,3,NA), codelist))
x <- coded(c(4,3,NA), codelist)
x[FALSE] <- integer(0)
expect_equal(x, coded(c(4,3,NA), codelist))

# Invalid code
x <- coded(c(4,3,NA), codelist)
expect_error(x[3] <- 6)

# Invalid code; wrong type
x <- coded(c(4,3,NA), codelist)
expect_error(x[3] <- "4")
expect_error(x[3] <- factor("A"))

# value has correct codelist
x <- coded(c(4,3,NA), codelist)
y <- coded(c(4), codelist)
x[3] <- y
expect_equal(x, coded(c(4,3,4), codelist))
# value has wrong codelist
x <- coded(c(4,3,NA), codelist)
y <- coded(c(4), codelist(data.frame(codes=4:5)))
expect_error(x[3] <- y)
# value has wrong codelist; codes match but labels don't
x <- coded(c(4,3,NA), codelist)
cl <- codelist
cl$label[4] <- "foo"
y <- coded(c(4), cl)
expect_error(x[3] <- y)

# character codes
codeliststr <- data.frame(
  code = letters[1:5],
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codeliststr <- codelist(codeliststr)
x <- coded(c("d", "c",NA), codeliststr)
x[3] <- "e"
expect_equal(x, coded(c("d", "c","e"), codeliststr))
x[3] <- factor("e")
expect_equal(x, coded(c("d", "c","e"), codeliststr))
expect_error(x[3] <- "f")
expect_error(x[3] <- factor("f"))

# factor codes
codeliststr <- data.frame(
  code = factor(letters[1:5]),
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codeliststr <- codelist(codeliststr)
x <- coded(c("d", "c",NA), codeliststr)
x[3] <- "e"
expect_equal(x, coded(c("d", "c","e"), codeliststr))
x[3] <- factor("e")
expect_equal(x, coded(c("d", "c","e"), codeliststr))
expect_error(x[3] <- "f")
expect_error(x[3] <- factor("f"))
expect_error(x[3] <- factor("f"))

# factor codes; and values
codeliststr <- data.frame(
  code = factor(letters[1:5]),
  label = letters[1:5],
  missing = c(0,0,0,0,1)
)
codeliststr <- codelist(codeliststr)
x <- coded(factor(c("d", "c",NA), levels = letters[1:5]), codeliststr)
x[3] <- "e"
expect_equal(x, coded(factor(c("d", "c","e"), letters[1:5]), codeliststr))
x[3] <- factor("e")
expect_equal(x, coded(factor(c("d", "c","e"), letters[1:5]), codeliststr))
expect_error(x[3] <- "f")
expect_error(x[3] <- factor("f"))
expect_error(x[3] <- factor("f"))

