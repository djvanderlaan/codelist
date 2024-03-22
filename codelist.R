
# code
# label
# [description]
# [parent]
# [locale]

# Basis codes omzetten naar factor 
# regio == cod("Amsterdam")
# is.na(codes) => maak gebruik van missing; is.missing(codes)
# lab(codes)
# labm(codes)
# factor; as.factor

pkgload::load_all()

data(objectcodes)
cl <- codelist(objectcodes)

dta <- data.frame(
  productid = 1:20,
  producttype = sample(cl$code, 20, replace = TRUE),
  price = round(runif(20, 0, 100))
  nsold = sample(1:1000, nrow(dta), replace = TRUE)
)

lab(dta$object, cl) |> table(useNA = "ifany")
lab(dta$object, cl, missing = FALSE) |> table(useNA = "ifany")


labm(dta$object, cl) |> table(useNA = "ifany")

attr(dta$object, "codelist") <- cl

lab(dta$object)

cod <- function(x, codelist, locale = cllocale(codelist)) {
  if (!is.null(attr(codelist, "codelist"))) {
    # Assume we got a variable with a codelist and not the codelist
    codelist <- attr(codelist, "codelist")
    if (missing(locale)) locale <- cllocale(codelist)
  }
  codelist <- clfilterlocale(codelist, preferred = locale)
  m <- match(x, codelist$label)
  if (anyNA(m)) stop("Labels not present in codelist in current locale.")
  # Check for duplicate labels; then no unique code
  tmp <- codelist$label[codelist$label %in% x]
  tmp <- tmp[duplicated(tmp)]
  if (length(tmp)) {
    stop("Labels are not unique. Therefore it is not possible to determine ",
      "a unique code. Duplicated labels: ", 
      paste0("'", tmp, "'", collapse = ","))
  }

  codelist$code[m]
}

dta[dta$object == cod("Marbles", cl), ]
dta[dta$object == cod("Marbles", dta$object), ]

table(labm(dta$object))

foo <- data.frame(code=1:3,
  label = c("a", "b", "b"))
foo <- codelist(foo)

cod("b", foo)

cod("Marbles", dta$object)
cod("Knikkers", dta$object)


tmp <- foo$label[foo$label %in% "b"]
tmp[duplicated(tmp)]

duplica



isvalidcodelist(cl)

clfilterlevel(cl, 1)

cllevels(cl)

codelist <- cl
level <- 0
locale <- cllocale(cl)

levels <- cllevels(cl)
tmp <- cl$parent
tmpl <- levels[match(tmp, codelist$code)]



cl

options(CLLOCALE="EN")
cllabel(c("A", "A01"), cl) 
options(CLLOCALE="NL")
cllabel(c("A", "A01"), cl) 
options(CLLOCALE=NULL)


cllevels(cl)




cllocale(cl)

clfilterlocale(cl)
clfilterlocale(cl, preferred = "NL")



cllevel(dta$object, codelist = cl, unique = FALSE)

cllabel(dta$object, codelist = cl)



level <- 1
codelist <- clfilterlocale(cl)
locale <- cllocale(cl)
x <- c(dta$object, NA)

clcast <- function(x, codelist, level, locale = cllocale(codelist)) {
  codelist <- clfilterlocale(codelist, preferred = locale)
  nlevels <- length(unique(cllevels(codelist)))
  l <- cllevel(x, codelist)
  na <- is.na(x)
  for (i in seq_len(nlevels)) {
    x <- ifelse(l != level, codelist$parent[match(x, codelist$code)], x)
    l <- cllevel(x, codelist)
  }
  if ( any((l != level | is.na(l)) & !na) ) {
    warning("Foo")
  }
  x
}

clcast(dta$object, cl, 0)

