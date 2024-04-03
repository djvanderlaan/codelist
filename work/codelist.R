
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
objectcodes <- codelist(objectcodes)

data(objectsales)
objectsales$product <- coded(objectsales$product, objectcodes)


objectsales[is.missing(objectsales$product), ]


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

