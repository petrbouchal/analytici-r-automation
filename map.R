library(purrr)

lst <- 1:4
for(i in lst) {
  print(i)
  Sys.sleep(i)
}

sleep_and_print <- function(x) {
  print(x)
  Sys.sleep(x)
}

walk(lst, Sys.sleep)
walk(lst, sleep_and_print)

for(i in lst) {
  sleep_and_print(i)
}

add_and_divide <- function(x) {
 x / (x + 3)
}

map(1:10, add_and_divide)
map_dbl(1:10, add_and_divide)

add_and_divide(1:10)

add_and_divide_2 <- function(x, y) {
  x / (x - y)
}

map2_dbl(1:10, 20:11, add_and_divide_2)
