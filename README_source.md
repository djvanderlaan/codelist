codelist
===============================================================================

`codelist` is a package that should make it easier to work with code lists. A
code list is a set of codes with associated values. For example one could have
codes 'E' = 'Employed', 'U' = 'Unemployed', 'N' = 'Not belonging to the working
population' and 'X' = 'Unknown'.  Codes can also have a description, be
contained in a hierarchy and indicate specific types of missing values.


Quick Overview
-------------------------------------------------------------------------------

```{.R #try results=FALSE echo=FALSE}
try <- function(...) base::try(..., outFile = stdout() )
```

```{.R #load}
library(codelist)
```

First we define the code list. In this case it is defined manually; in
practice these will often be read from file.  A code list has at minimum
codes and corresponding labels. Here we also have a column indicating which
codes can be interpreted as missing values.

```{.R #createcodelist}
cl <- codelist(
  codes = c("E", "U", "N", "X"), 
  labels = c("Employed", "Unemployed", 
    "Not belonging to working population", "Unknown"),
  missing = c(0, 0, 0, 1)
)
```

We can use this code list to define a 'coded' vector; which is a vector of
codes with an attribute 'codelist'.

```{.R #createcoded}
x <- coded(c("N", "E", "E", "U", NA, "E", "N", "X", "N"), cl)
x
```

The general idea of the `codelist` package, is that we work with the codes as
these are generally the most accurate. However, for presentation and statistical
analyses we will often want to work with the labels.  The `labels` methods
transforms the vector into a factor for analysis and presentation:

```{.R #labels1}
table(x)
```

```{.R #labels2}
table(labels(x, missing = FALSE), useNA = "ifany")
```

The code list can also be used to check if codes are valid making the code more safe:

```{.R #error1 capture_warnings=TRUE}
try( x[1] <- "A" ) 
```

```{.R #error2 capture_warnings=TRUE}
try( any(x == "B") )
```

In this case the codes are somewhat readable. However, generally when reading
code it is difficult to understand what a line of code like the lines above
means. For someone reading the code it is easier to work with the labels:

```{.R #aslabel1}
x[1] <- as.label("Employed")
x[is.missing(x)] <- as.label("Unemployed")
``` 

Of course using invalid labels will generated an error.



More information
-------------------------------------------------------------------------------

More information can be found in the vignettes of the package:

- [Introduction to working with code lists](https://htmlpreview.github.io/?https://github.com/djvanderlaan/codelist/blob/master/inst/doc/introduction.html)



