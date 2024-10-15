library(tibble)
library(dplyr)
library(stringr)

# Přejmenovat více sloupců -----------------------------------------------

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

df |>
  select(id, matches("_a_"))

df |>
  select(id, matches("_a_"), where(is.factor))

df |>
  mutate(across(starts_with("measure"), as.integer))

df |>
  mutate(across(starts_with("measure"), \(x) as.integer(x) |> floor()))

df |>
  mutate(across(matches("measure_[a|b]$"), \(x) as.integer(x) |> floor())) |>
  mutate(across(starts_with("name"), str_to_sentence))

df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric)) |>
  mutate(across(where(is.numeric), floor))

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

df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric)) |>
  summarise(across(where(is.numeric), list(avg = mean,
                                           mn = \(x) mean(x ^ 3) / 12)))

df |>
  select(-ends_with("round")) |>
  mutate(across(starts_with("measure"), as.numeric)) |>
  summarise(across(where(is.numeric), list(avg = mean,
                                        mn = \(x) mean(x ^ 3) / 12)),
            .by = group)
