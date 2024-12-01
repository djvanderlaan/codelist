<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to working with code lists}
-->

---
title: Introduction to working with code lists
author: Jan van der Laan
css: "style.css"
---


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

Note that, although code lists can contain a 'parent' column, the current
version of the `codelist` package does not contain any functionality yet to work
with these hierarchies. This could for example be used to select all records
whose codes fall in the 'Toys' domain, or to aggregate the data to the top level
domains. Expect functionality like this in future versions of the package.


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

Using the 'locale' column of the code list it is possible to specify different
versions of for the labels and descriptions. This can be used the specify
different translations as in this example, but can also be used to specify
different versions, for example, long and short labels. By default all methods
will use the first locale in the code list as the defalult locale; the locale
returned by the `cllocale` function:

```{.R}
cllocale(objectcodes)
```
Most methods also have a `locale` argument with which it is possible to specify
the preferred locale (the default is used when the preferred locale is not
present). For example:

```{.R}
label(objectsales$product, locale = "NL") |> head()
```
It can become tedious having to specify the locale for each function call. The
`cllocale` will look at the `CLLOCALE` option, when present, to get the
preferred locale. Therefore, to set a default preferred locale:

```{.R}
op <- options(CLLOCALE = "NL")
cllocale(objectcodes)
tapply(objectsales$unitprice, label(objectsales$product), mean)
# Set the locale back to the original value (unset)
options(op)
```

### Looking up codes based on label

Using the `code` function it is possible to look up the codes based on a set of
labels. For example, below we look up the code for 'Hammer':
```{.R}
code("Hammer", objectcodes)
```
It is also possible to pass in the variable (an object with a `codelist`
attribute) instead of the code list itself:
```{.R}
code("Hammer", objectsales$product)
```
This could be used to make selections. For example, instead of 
```{.R}
subset(objectsales, product == "B02")
```
one can do
```{.R}
subset(objectsales, product == code("Electric Drill", product))
```
In general the latter is more readable and makes the intent of the code much
more clear (unless one can assume that the people reading the code will now most
of the product codes).

When comparing a `coded` object to labels, it is also possible to use the `lab`
function. This will add the class "label" to the character vector. The
comparison operator will then first call the `code` function on the label:
```{.R}
subset(objectsales, product == lab("Electric Drill"))
```
This only works for the equal-to and not-equal-to operators.

Selecting this way has an advantage over selecting records based on character
vectors or factor vectors. For example we could also have done the following:
```{.R}
subset(objectsales, label(product) == "Electric Drill")
```
However, a small, difficult to spot, spelling mistake would have resulted in:
```{.R}
subset(objectsales, label(product) == "Electric drll")
```
And we could have believed that no electric drills were sold. The `code`
function will also check if the provided labels are valid and if not will
generate an error (the `tryCatch` is to make sure don't actually throw an
error). 
```{.R capture_warnings=TRUE}
tryCatch({
  subset(objectsales, product == code("Electric drill", product))
}, error = \(e) cat("Error:", conditionMessage(e), "\n"))
```
Since selecting on labels is a common operation, there is also the `inlabels`
function that will return a logical vector indicating whether or not a code has
a label in the given set:
```{.R capture_warnings=TRUE}
subset(objectsales, inlabels(product, "Electric Drill"))
```
This function will of course also generate an error in case of invalid codes.
```{.R capture_warnings=TRUE}
tryCatch({
  subset(objectsales, inlabels(product, "Electric drill"))
}, error = \(e) cat("Error:", conditionMessage(e), "\n"))
```
In the examples above we used the base function `subset`, but this will of
course also work within `data.tables` and the `filter` methods from `dplyr`. 

### Assignment of codes

When the vector with codes is transformed to a `coded` object, it can of course
also be assigned to:
```{.R}
objectsales$product[10] <- "A01"
objectsales$product[1:10] 
```
Here the `code` function can also be of use (again, an invalid label will
result in an error so this is a safe operation):
```{.R}
objectsales$product[10] <- code("Teddy Bear", objectcodes)
objectsales$product[1:10] 
```
Another option is to use the `lab` function which labels a character vector as a
label:
```{.R}
objectsales$product[10] <- lab("Electric Drill")
objectsales$product[1:10] 
```

### Safety

Using a `coded` vector also has the advantage that the codes assigned to will be
validated against the code list, generating an error when one tries assign an
invalid code:
```{.R capture_warnings=TRUE}
try({
  objectsales$product[10] <- "Q"
})
```
This makes a `coded` object safer to work with than, for example, a character of
numeric vector with codes (a `factor` vector will also generate a warning for
invalid factor levels).

The `code` function and the `lab` function (which call the `code` function) will
also generate an error:
```{.R capture_warnings=TRUE}
try({
  objectsales$product[10] <- lab("Teddy bear")
})
```
Assigning `NA` will of course still work:
```{.R}
objectsales$product[10] <- NA
```

A `coded` object is safer to work with than a factor vector. For example:

```{.R}
x <- factor(letters[1:3])
y <- coded(1:3, data.frame(code = 1:3, label = letters[1:3]))
```
Comparing on invalid codes works with a factor while it will generate an error
for `coded` objects:
```{.R}
try({ x == 4 })
try({ y == 4 })
```
The same holds when comparing on labels:
```{.R}
try({ x == "foobar" })
```
A `coded` cannot directly be compared on a label and will generate an error even
when the label is valid:
```{.R}
try({ y == "a" })
```
One should use either the `code` or `lab` function for that:
```{.R}
try({ y == lab("a") })
try({ y == lab("foobar") })
```

