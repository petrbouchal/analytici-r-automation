library(tibble)
library(dplyr)
library(stringr)

# Vytvořit pokusný data frame

## tibble --------------------------------------------------------------------

df <- tibble(
  name_first = c("john", "jane", "alice", "bob"),
  name_last = c("smith", "doe", "johnson", "brown"),
  measure_a = c("1.3", "4.3", "2.5", "3.7"),
  measure_b = c("3.6", "3.9", "4.1", "2.8"),
  measure_a_round = c("1", "4", "3", "4"),
  measure_b_round = c("4", "4", "4", "3"),
  age = c(33, 42, 17, 23),
  id = c("001", "002", "003", "004"),
  group = factor("Group1", "Group1", "Group2", "Group2")
)

## Tribble -------------------------------------------------------------------

df <- tribble(
  ~name_first, ~name_last, ~measure_a, ~measure_b, ~measure_a_round, ~measure_b_round, ~age, ~id, ~group,
  "john",      "smith",    1.3,        3.6,        1,               4,               33,  "001", "Group1",
  "jane",      "doe",      4.3,        3.9,        4,               4,               42,  "002", "Group1",
  "alice",     "johnson",  2.5,        4.1,        3,               4,               17,  "003", "Group2",
  "bob",       "brown",    3.7,        2.8,        4,               3,               23,  "004", "Group2"
)


# Vybrat sloupce podle textu v názvu --------------------------------------

df |>
  select(id, matches("_a_"))

df |>
  select(id, matches("_a_"), where(is.factor))


# mutate() přes víc sloupců -------------------------------------------------

df |>
  mutate(across(starts_with("measure"), as.integer))

df |>
  mutate(across(starts_with("measure"), \(x) as.integer(x) |> floor()))

df |>
  mutate(across(matches("measure_[a|b]$"), \(x) as.integer(x) |> floor())) |>
  mutate(across(starts_with("name"), str_to_sentence))


## across() vícekrát v jednom mutate -----------------------------------------

df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric),
         across(where(is.numeric), floor))

## Více fukncí utnitř across() -----------------------------------------------

df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric)) |>
  mutate(across(where(is.numeric), list(flr = floor,
                                        wtf = \(x) (x ^ 3) / 12,
                                        omg = \(x) log(x))))
df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric)) |>
  summarise(across(where(is.numeric), list(avg = mean,
                                           wtf = \(x) mean(x ^ 3) / 12)))

## Výběr podle datového typu sloupce -----------------------------------------

df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric)) |>
  summarise(across(where(is.numeric), list(avg = mean,
                                           mn = \(x) mean(x ^ 3) / 12)))

## Totéž po skupinách --------------------------------------------------------

df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric)) |>
  summarise(across(where(is.numeric), list(avg = mean,
                                        mn = \(x) mean(x ^ 3) / 12)),
            .by = group)
