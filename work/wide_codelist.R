

txt <- "code,label_en-UK,label_nl-NL,description_en-UK,description_en-UK
A,Apple,Appel,Red and round,Rood en rond
B,Banana,Banaan,Yellow and oblong,Geel en langwerpig
C,Cucumber,Komkommer,Green and oblong,Groen en langwerpig
"

cl <- textConnection(txt) |> read.csv(check.names = FALSE)

library(codelist)

as.codelist(cl)



