
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


format.coded <- function(x, maxlen = getOption("CLMAXLEN", 0L), ...) {
  uncoded <- function(x) {
    class(x) <- setdiff(class(x), "coded")
    attr(x, "codelist") <- NULL
    x
  }
  if (maxlen <= 0 || is.na(maxlen) || is.null(maxlen)) {
    format(uncoded(x))
  } else {
    l <- as.character(labelm(x))
    l <- ifelse(nchar(l) > maxlen, paste0(substr(l, 1L, maxlen-1L), "‥"), l)
    l <- ifelse(is.na(x), "", paste0("[", l, "]"))
    paste0(format(uncoded(x)), format(l))
  }
}
format(objectsales$product, maxlen=5)

objectsales


x <- objectsales$product
attributes(x) <- NULL
x

x <- objectsales$product
label(x)



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

