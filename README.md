# codelist

`codelist` is a package that should make it easier to work with code
lists. A code list is a set of codes with associated values. For example
one could have codes ‘E’ = ‘Employed’, ‘U’ = ‘Unemployed’, ‘N’ = ‘Not
belonging to the working population’ and ‘X’ = ‘Unknown’. Codes can also
have a description, be contained in a hierarchy and indicate specific
types of missing values.

## Quick Overview

``` R
library(codelist)
```

First we define the code list. In this case it is defined manually; in
practice these will often be read from file. A code list has at minimum
codes and corresponding labels. Here we also have a column indicating
which codes can be interpreted as missing values.

``` R
cl <- codelist(
  codes = c("E", "U", "N", "X"), 
  labels = c("Employed", "Unemployed", 
    "Not belonging to working population", "Unknown"),
  missing = c(0, 0, 0, 1)
)
```

We can use this code list to define a ‘coded’ vector; which is a vector
of codes with an attribute ‘codelist’.

``` R
x <- coded(c("N", "E", "E", "U", NA, "E", "N", "X", "N"), cl)
x
## [1] N    E    E    U    <NA> E    N    X    N   
## 4 Codelist: E(=Employed) ...X(=Unknown)
```

The general idea of the `codelist` package, is that we work with the
codes as these are generally the most accurate. However, for
presentation and statistical analyses we will often want to work with
the labels. The `labels` methods transforms the vector into a factor for
analysis and presentation:

``` R
table(x)
## x
## E N U X 
## 3 3 1 1 
```

``` R
table(labels(x, missing = FALSE), useNA = "ifany")
## 
##                            Employed                          Unemployed 
##                                   3                                   1 
## Not belonging to working population                             Unknown 
##                                   3                                   1 
##                                <NA> 
##                                   1 
```

The code list can also be used to check if codes are valid making the
code more safe:

``` R
try( x[1] <- "A" ) 
## Error in `[<-.coded`(`*tmp*`, 1, value = "A") : 
##   Invalid codes used in value.
```

``` R
try( any(x == "B") )
## Error in Ops.coded(x, "B") : Invalid codes used in RHS
```

In this case the codes are somewhat readable. However, generally when
reading code it is difficult to understand what a line of code like the
lines above means. For someone reading the code it is easier to work
with the labels:

``` R
x[1] <- as.label("Employed")
x[is.missing(x)] <- as.label("Unemployed")
```

Of course using invalid labels will generated an error.

## More information

More information can be found in the vignettes of the package:

- [Introduction to working with code
  lists](https://htmlpreview.github.io/?https://github.com/djvanderlaan/codelist/blob/master/inst/doc/introduction.html)
