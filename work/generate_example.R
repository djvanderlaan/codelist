
library(codelist)
data(objectcodes)

set.seed(10)

tmp <- subset(objectcodes, locale == "EN" & !is.na(parent))
tmp$lb <- c(10, 2,  1, 12, 65)
tmp$ub <- c(30, 22, 4, 78, 320)
tmp

n <- 100
dta <- data.frame(
    product = sample(tmp$code, n, replace = TRUE, prob = runif(nrow(tmp), 0.1, 0.9))
  )

m <- match(dta$product, tmp$code)
dta$unitprice <- round(runif(n, tmp$lb[m], tmp$ub[m]), 2)
dta$quantity  <- round(runif(n, 0, 100))
dta$totalprice <- dta$unitprice * dta$quantity

dta$product[rbinom(n, 1, 0.05) == 1] <- "X"
dta$product[rbinom(n, 1, 0.02) == 1] <- NA

stopifnot(sum(is.na(dta$product)) > 0)

dta

table(labm(dta$product, objectcodes), useNA = "ifany")

subset(dta, product == cod("Electric Drill", objectcodes))

objectsales <- dta

save(objectsales, file = "data/objectsales.RData")

