
library(codelist)

data(objectcodes)
objectcodes

data(objectsales)
objectsales |> head()

objectsales$product |> head(10)

lab(objectsales$product, codelist = objectcodes) |> head(10)

attr(objectsales$product, "codelist") <- objectcodes
lab(objectsales$product) |> head(10)

objectsales$product <- coded(objectsales$product, objectcodes)
objectsales$product |> head(10)
lab(objectsales$product) |> head(10)


table(lab(objectsales$product), useNA = "ifany")
table(labm(objectsales$product), useNA = "ifany")
table(labm(objectsales$product, droplevels = TRUE), useNA = "ifany")

tapply(objectsales$unitprice, lab(objectsales$product), mean)

lm(unitprice ~ 0+lab(product), data = objectsales) |> summary()
lm(unitprice ~ 0+labm(product), data = objectsales) |> summary()

options(CLLOCALE = "NL")
tapply(objectsales$unitprice, lab(objectsales$product), mean)
options(CLLOCALE = NULL)

cod("Hammer", objectcodes)
cod("Hammer", objectsales$product)

subset(objectsales, product == cod("Electric Drill", product))

subset(objectsales, lab(product) == "Electric Drill")
subset(objectsales, lab(product) == "Electric drll")

subset(objectsales, product == cod("Electric drill", product))


factor(c("A", "B")) == "C"

objectsales$product <- coded(objectsales$product, objectcodes)

objectsales$product[10] <- "Q"
objectsales$product[10] <- "A01"

objectsales$product[10] <- NA

matchlab(objectsales$product, c("Hammer", "Electric Drill"))

subset(objectsales, matchlab(product, "Electric Drill"))
subset(objectsales, matchlab(product, "Electric drill"))

matchlab <- function(x, label, codelist = attr(x, "codelist"), 
    locale = cllocale(codelist)) {
  x %in% cod(label, codelist)
}

