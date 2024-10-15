tidyr::expand_grid(num = 1:3, let = letters[1:10])

minidf <- tibble(num = 1:3, let = c("a", "a", "d"))
minidf
minidf |> expand(num, let)
minidf |> expand(num, let, rok = 2010:2012)
minidf |> expand(nesting(num, let), rok = 2010:2012)
