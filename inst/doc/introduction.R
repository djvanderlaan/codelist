# try
try <- function(...) base::try(..., outFile = stdout() )

# load
library(codelist)

data(objectcodes)
objectcodes

# ex10
data(objectsales)
objectsales |> head()

# ex20
objectsales$product |> head(10)

# ex30
to_labels(objectsales$product, objectcodes) |> head(10)

# ex40
attr(objectsales$product, "codelist") <- objectcodes
to_labels(objectsales$product) |> head(10)

# ex50
objectsales$product <- coded(objectsales$product, objectcodes)
objectsales$product |> head(10)
to_labels(objectsales$product) |> head(10)

# ex60
table(labels(objectsales$product), useNA = "ifany")
tapply(objectsales$unitprice, labels(objectsales$product), mean)
lm(unitprice ~ 0+labels(product), data = objectsales) 

# ex70
table(labels(objectsales$product, FALSE), useNA = "ifany")

# ex80
table(labels(objectsales$product, droplevels = TRUE), useNA = "ifany")

# ex90
cl_locale(objectcodes)

# ex100
labels(objectsales$product, locale = "NL") |> head()

# ex110
op <- options(CLLOCALE = "NL")
cl_locale(objectcodes)
tapply(objectsales$unitprice, labels(objectsales$product), mean)
# Set the locale back to the original value (unset)
options(op)

# ex120
codes("Hammer", objectcodes)

# ex130
codes("Hammer", cl(objectsales$product))

# ex140
subset(objectsales, product == "B02")

# ex150
subset(objectsales, product == codes("Electric Drill", cl(product)))

# ex160
subset(objectsales, product == as.label("Electric Drill"))

# ex170
subset(objectsales, labels(product) == "Electric Drill")

# ex180
subset(objectsales, labels(product) == "Electric drll")

# ex190
try({
  subset(objectsales, product == codes("Electric drill", cl(product)))
})

# ex200
subset(objectsales, in_labels(product, "Electric Drill"))

# ex210
try({
  subset(objectsales, in_labels(product, "Electric drill"))
})

# ex220
objectsales$product[10] <- "A01"
objectsales$product[1:10] 

# ex230
objectsales$product[10] <- codes("Teddy Bear", objectcodes)
objectsales$product[1:10] 

# ex240
objectsales$product[10] <- as.label("Electric Drill")
objectsales$product[1:10] 

# hierarchies1
cl_nlevels(objectcodes)

# hierarchies2
cl_levels(objectcodes)

# hierarchies3
objectsales$group <- levelcast(objectsales$product, 0)
head(objectsales)

# hierarchies3
aggregate(objectsales[c("quantity", "totalprice")], 
  objectsales[c("group")], sum)

# hierarchies4
cl(objectsales$group)

# ex250
try({
  objectsales$product[10] <- "Q"
})

# ex260
try({
  objectsales$product[10] <- as.label("Teddy bear")
})

# ex270
objectsales$product[10] <- NA

# ex280
x <- factor(letters[1:3])
y <- coded(1:3, data.frame(code = 1:3, label = letters[1:3]))

# ex290
try({ x == 4 })
try({ y == 4 })

# ex300
try({ x == "foobar" })

# ex310
try({ y == "a" })

# ex320
try({ y == as.label("a") })
try({ y == as.label("foobar") })

