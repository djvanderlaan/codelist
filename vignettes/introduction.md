<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to working with code lists}
-->

---
title: Introduction to working with code lists
author: Jan van der Laan
css: "style.css"
---

```{.R #try results=FALSE echo=FALSE}
try <- function(...) base::try(..., outFile = stdout() )
```

The `codelist` package has an example code list and a data set that used codes
from that code list. We will start by demonstrating how the package works using
this example code list. 

Let's load the example code list:

```{.R #load}
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
```{.R #ex10}
data(objectsales)
objectsales |> head()
```
This is a data set containing the prices and sales of various products. The
'product' column uses codes from the `objectcodes` code list:

```{.R #ex20}
objectsales$product |> head(10)
```

One of the things we can do is convert the codes to their corresponding labels:
```{.R #ex30}
to_labels(objectsales$product, objectcodes) |> head(10)
```
The `to_labels` function accepts a vector with codes and a `codelist` for this vector.
It can get a bit tiresome to keep having to pass in the `codelist` attribute. If
it is missing, the looks for a 'codelist' attribute:

```{.R #ex40}
attr(objectsales$product, "codelist") <- objectcodes
to_labels(objectsales$product) |> head(10)
```
The `codelist` package also has a `coded` type. Converting to a `coded` object
adds the `coded` class. This will result in some formatting and later on we will
see that this also ensures that we cannot assign invalid codes to the vector:
```{.R #ex50}
objectsales$product <- coded(objectsales$product, objectcodes)
objectsales$product |> head(10)
to_labels(objectsales$product) |> head(10)
```
For `coded` objects there is also the `labels` method:
```
labels(objectsales$product) |> head(10)
```
The `labels` method and the `to_labels` function can be used to get readable
output from various R-functions:
```{.R #ex60}
table(labels(objectsales$product), useNA = "ifany")
tapply(objectsales$unitprice, labels(objectsales$product), mean)
lm(unitprice ~ 0+labels(product), data = objectsales) 
```
By default codes that are considered missing are converted to `NA` when
converting to labels. This can be prevented by setting the `missing` argument to
`FALSE`:
```{.R #ex70}
table(labels(objectsales$product, FALSE), useNA = "ifany")
```
The `droplevels` removes unused codes from the levels of the generated factor
vector:
```{.R #ex80}
table(labels(objectsales$product, droplevels = TRUE), useNA = "ifany")
```

### Locale

Using the 'locale' column of the code list it is possible to specify different
versions of for the labels and descriptions. This can be used the specify
different translations as in this example, but can also be used to specify
different versions, for example, long and short labels. By default all methods
will use the first locale in the code list as the defalult locale; the locale
returned by the `cl_locale` function:

```{.R #ex90}
cl_locale(objectcodes)
```
Most methods also have a `locale` argument with which it is possible to specify
the preferred locale (the default is used when the preferred locale is not
present). For example:

```{.R #ex100}
labels(objectsales$product, locale = "NL") |> head()
```
It can become tedious having to specify the locale for each function call. The
`cl_locale` will look at the `CLLOCALE` option, when present, to get the
preferred locale. Therefore, to set a default preferred locale:

```{.R #ex110}
op <- options(CLLOCALE = "NL")
cl_locale(objectcodes)
tapply(objectsales$unitprice, labels(objectsales$product), mean)
# Set the locale back to the original value (unset)
options(op)
```

### Looking up codes based on label

Using the `codes` function it is possible to look up the codes based on a set of
labels. For example, below we look up the code for 'Hammer':
```{.R #ex120}
codes("Hammer", objectcodes)
```
or getting the code list form the relevant variable itself using the `cl`
method that returns the code list of the variable:
```{.R #ex130}
codes("Hammer", cl(objectsales$product))
```
This could be used to make selections. For example, instead of 
```{.R #ex140}
subset(objectsales, product == "B02")
```
one can do
```{.R #ex150}
subset(objectsales, product == codes("Electric Drill", cl(product)))
```
In general the latter is more readable and makes the intent of the code much
more clear (unless one can assume that the people reading the code will now most
of the product codes).

When comparing a `coded` object to labels, it is also possible to use the
`as.label` function. This will add the class "label" to the character vector.
The comparison operator will then first call the `codes` function on the label:
```{.R #ex160}
subset(objectsales, product == as.label("Electric Drill"))
```
This only works for the equal-to and not-equal-to operators.

Selecting this way has an advantage over selecting records based on character
vectors or factor vectors. For example we could also have done the following:
```{.R #ex170}
subset(objectsales, labels(product) == "Electric Drill")
```
However, a small, difficult to spot, spelling mistake would have resulted in:
```{.R #ex180}
subset(objectsales, labels(product) == "Electric drll")
```
And we could have believed that no electric drills were sold. The `codes`
function will also check if the provided labels are valid and if not will
generate an error (the `try` is to make sure don't actually throw an
error). 
```{.R #ex190 capture_warnings=TRUE}
try({
  subset(objectsales, product == codes("Electric drill", cl(product)))
})
```
Since selecting on labels is a common operation, there is also the `in_labels`
function that will return a logical vector indicating whether or not a code has
a label in the given set:
```{.R #ex200 capture_warnings=TRUE}
subset(objectsales, in_labels(product, "Electric Drill"))
```
This function will of course also generate an error in case of invalid codes.
```{.R #ex210 capture_warnings=TRUE}
try({
  subset(objectsales, in_labels(product, "Electric drill"))
})
```
In the examples above we used the base function `subset`, but this will of
course also work within `data.tables` and the `filter` methods from `dplyr`. 

### Assignment of codes

When the vector with codes is transformed to a `coded` object, it can of course
also be assigned to:
```{.R #ex220}
objectsales$product[10] <- "A01"
objectsales$product[1:10] 
```
Here the `codes` function can also be of use (again, an invalid label will
result in an error so this is a safe operation):
```{.R #ex230}
objectsales$product[10] <- codes("Teddy Bear", objectcodes)
objectsales$product[1:10] 
```
Another option is to use the `as.label` function which labels a character vector as a
label:
```{.R #ex240}
objectsales$product[10] <- as.label("Electric Drill")
objectsales$product[1:10] 
```

### Safety

Using a `coded` vector also has the advantage that the codes assigned to will be
validated against the code list, generating an error when one tries assign an
invalid code:
```{.R #ex250 capture_warnings=TRUE}
try({
  objectsales$product[10] <- "Q"
})
```
This makes a `coded` object safer to work with than, for example, a character of
numeric vector with codes (a `factor` vector will also generate a warning for
invalid factor levels).

The `codes` function and the `as.label` function (which call the `codes` function) will
also generate an error:
```{.R #ex260 capture_warnings=TRUE}
try({
  objectsales$product[10] <- as.label("Teddy bear")
})
```
Assigning `NA` will of course still work:
```{.R #ex270}
objectsales$product[10] <- NA
```

A `coded` object is safer to work with than a factor vector. For example:
```{.R #ex280}
x <- factor(letters[1:3])
y <- coded(1:3, data.frame(code = 1:3, label = letters[1:3]))
```
Comparing on invalid codes works with a factor while it will generate an error
for `coded` objects:
```{.R #ex290}
try({ x == 4 })
try({ y == 4 })
```
The same holds when comparing on labels:
```{.R #ex300}
try({ x == "foobar" })
```
A `coded` cannot directly be compared on a label and will generate an error even
when the label is valid:
```{.R #ex310}
try({ y == "a" })
```
One should use either the `codes` or `as.label` function for that:
```{.R #ex320}
try({ y == as.label("a") })
try({ y == as.label("foobar") })
```

