library(purrr)

# For loop ----------------------------------------------------------------

lst <- 1:4
for(i in lst) {
  print(i)
  Sys.sleep(i)
}

for (pismeno in c("a", "b", "c")) {
  print(paste("tisknu", pismeno))
}

for (pismeno in list("a", "b", "c")) {
  print(paste("tisknu", pismeno))
}

## Definice funkce -----------------------------------------------------------

sleep_and_print <- function(vteriny) {
  print(paste("pospávám", vteriny, "vteřin"))
  Sys.sleep(vteriny)
  return(vteriny)
}

## Funkce uvnitř for loopu ---------------------------------------------------

for (vteriny in lst) {sleep_and_print(vteriny)}

## Sběr výsledků do proměnné -------------------------------------------------

for_vysledek <- c()
for(i in lst) {
  sleep_and_print(i)
  for_vysledek <- append(for_vysledek, i)
}
for_vysledek

## Totéž pomocí purrr --------------------------------------------------------

spani_vysledek <- map(lst, sleep_and_print)
spani_vysledek

walk(lst, Sys.sleep)
chozeni_vysledek <- walk(lst, sleep_and_print)
chozeni_vysledek

add_and_divide <- function(x) {
 x / (x + 3)
}

map(1:10, add_and_divide)
map_dbl(1:10, add_and_divide)

add_and_divide(1:10)

## Funkce se dvěma vstupy ----------------------------------------------------

add_and_divide_2 <- function(x, y) {
  x / (x - y)
}

map2_dbl(1:10, 20:11, add_and_divide_2)
