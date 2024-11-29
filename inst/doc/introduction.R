# <unlabeled code block>
library(codelist)

data(objectcodes)
objectcodes

# <unlabeled code block>
data(objectsales)
objectsales |> head()

# <unlabeled code block>
objectsales$product |> head(10)

# <unlabeled code block>
label(objectsales$product, objectcodes) |> head(10)

# <unlabeled code block>
attr(objectsales$product, "codelist") <- objectcodes
label(objectsales$product) |> head(10)

# <unlabeled code block>
objectsales$product <- coded(objectsales$product, objectcodes)
objectsales$product |> head(10)
label(objectsales$product) |> head(10)

# <unlabeled code block>
table(label(objectsales$product), useNA = "ifany")
tapply(objectsales$unitprice, label(objectsales$product), mean)
lm(unitprice ~ 0+label(product), data = objectsales) 

# <unlabeled code block>
table(labelm(objectsales$product), useNA = "ifany")

# <unlabeled code block>
table(labelm(objectsales$product, droplevels = TRUE), useNA = "ifany")

# <unlabeled code block>
cllocale(objectcodes)

# <unlabeled code block>
label(objectsales$product, locale = "NL") |> head()

# <unlabeled code block>
op <- options(CLLOCALE = "NL")
cllocale(objectcodes)
tapply(objectsales$unitprice, label(objectsales$product), mean)
# Set the locale back to the original value (unset)
options(op)

# <unlabeled code block>
code("Hammer", objectcodes)

# <unlabeled code block>
code("Hammer", objectsales$product)

# <unlabeled code block>
subset(objectsales, product == "B02")

# <unlabeled code block>
subset(objectsales, product == code("Electric Drill", product))

# <unlabeled code block>
subset(objectsales, product == lab("Electric Drill"))

# <unlabeled code block>
subset(objectsales, label(product) == "Electric Drill")

# <unlabeled code block>
subset(objectsales, label(product) == "Electric drll")

# <unlabeled code block>
tryCatch({
  subset(objectsales, product == code("Electric drill", product))
}, error = \(e) cat("Error:", conditionMessage(e), "\n"))

# <unlabeled code block>
subset(objectsales, inlabels(product, "Electric Drill"))

# <unlabeled code block>
tryCatch({
  subset(objectsales, inlabels(product, "Electric drill"))
}, error = \(e) cat("Error:", conditionMessage(e), "\n"))

# <unlabeled code block>
objectsales$product[10] <- "A01"
objectsales$product[1:10] 

# <unlabeled code block>
objectsales$product[10] <- code("Teddy Bear", objectcodes)
objectsales$product[1:10] 

# <unlabeled code block>
# Wrap in a tryCatch to not throw actual errors
tryCatch({
  objectsales$product[10] <- "Q"
}, error = \(e) cat("Error:", conditionMessage(e), "\n"))

# <unlabeled code block>
objectsales$product[10] <- NA

# <unlabeled code block>
x <- factor(letters[1:3])
y <- coded(1:3, data.frame(code = 1:3, label = letters[1:3]))

# <unlabeled code block>
try({ x == 4 })
try({ y == 4 })

# <unlabeled code block>
try({ x == "foobar" })

# <unlabeled code block>
try({ y == "a" })

# <unlabeled code block>
try({ y == lab("a") })
try({ y == lab("foobar") })

