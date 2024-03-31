

The `codelist` package has an example code list and a data set that used codes
from that code list. We will start by demonstrating how the package works using
this example code list. 

Let's load the example code list:

```{.R}
library(codelist)

data(objectcodes)
objectcodes
```
We see that the code list contains codes for encoding various types of objects.
A code list contains at the minimum a 'code' and 'label' column. The 'code'
column can be any type; the 'label' column should be a character column.  With the
'parent' column it is possible to define simple hierarchies. This columns should
contain codes from the 'code' column. A missing value indicates a top-level
code. With the 'locale' column it is possible to have different versions of the
'label' and 'description' (here missing) columns. It can be used for different
translations as here, but could also be used for different versions of the
labels and descriptions. The 'missing' column indicates whether or not the code
should be treated as a missing value. This column should be interpretable as a
logical column.

We will also load and example data set using the codes we loaded above:
```{.R}
data(objectsales)
objectsales |> head()
```
This is a data set containing the prices and sales of various products. The
'product' column uses codes from the `objectcodes` code list:

```{.R}
objectsales$product |> head(10)
```

One of the things we can do is convert the codes to their corresponding labels:
```{.R}
label(objectsales$product, objectcodes) |> head(10)
```
The `label` function accepts a vector with codes and a `codelist` for this vector.
It can get a bit tiresome to keep having to pass in the `codelist` attribute. If
it is missing, the looks for a 'codelist' attribute:

```{.R}
attr(objectsales$product, "codelist") <- objectcodes
label(objectsales$product) |> head(10)
```
The `codelist` package also has a `coded` type. Converting to a `coded` object
adds the `coded` class. This will result in some formatting and later on we will
see that this also ensures that we cannot assign invalid codes to the vector:
```{.R}
objectsales$product <- coded(objectsales$product, objectcodes)
objectsales$product |> head(10)
label(objectsales$product) |> head(10)
```
The `label` function can be used to get readable output from various R-functions:
```{.R}
table(label(objectsales$product), useNA = "ifany")
tapply(objectsales$unitprice, label(objectsales$product), mean)
lm(unitprice ~ 0+label(product), data = objectsales) 
```
By default codes that are considered missing are converted to `NA` when
converting to labels. This can be prevented by setting the `missing` argument to
`TRUE` or by using the `labelm` function:
```{.R}
table(labelm(objectsales$product), useNA = "ifany")
```
The `droplevels` removes unused codes from the levels of the generated factor
vector:
```{.R}
table(labelm(objectsales$product, droplevels = TRUE), useNA = "ifany")
```

### Locale

```{.R}
label(objectsales$product, locale = "NL") |> head()
```

```{.R}
op <- options(CLLOCALE = "NL")
tapply(objectsales$unitprice, label(objectsales$product), mean)
# Set the locale back to the original value (unset)
options(op)
```

### Looking up codes based on label

```{.R}
code("Hammer", objectcodes)
```

```{.R}
code("Hammer", objectsales$product)
```

```{.R}
subset(objectsales, product == code("Electric Drill", product))
```

```{.R}
subset(objectsales, label(product) == "Electric Drill")
subset(objectsales, label(product) == "Electric drll")
```

```{.R}
subset(objectsales, product == code("Electric drill", product))
```

```{.R}
matchlab(objectsales$product, c("Hammer", "Electric Drill"))

subset(objectsales, inlabels(product, "Electric Drill"))
subset(objectsales, inlabels(product, "Electric drill"))
```

### Assignment of codes

```{.R}
objectsales$product <- coded(objectsales$product, objectcodes)
objectsales$product[10] <- "A01"
```

```{.R}
objectsales$product[10] <- code("Teddy Bear", objectcoces)
```

```{.R}
objectsales$product[10] <- "Q"
```

```{.R}
objectsales$product[10] <- NA
```

