library(glue)
library(purrr)
library(readxl)
library(writexl)
library(readr)
library(tidyr)

datumy <- c("29-09-2024", "06-10-2024")
urls <- glue("https://www.mvcr.cz/soubor/statistika-ukr-{datumy}-xls.aspx")
mv_dir <- file.path("data-raw", "mvcr")
fls <- file.path(mv_dir, paste0("mv_ukr_", datumy, ".xls"))
fs::dir_create(mv_dir)

map2(urls, fls, download.file)

fls_chr <- map2_chr(urls, fls, function(x, y) {
  download.file(x, y)
  return(y)
})

fls_df <- map2_df(urls, fls, function(x, y) {
  print(y)
  download.file(url = x, destfile = y)
  tibble(url = x, file = y)
})

dta_df <- fls_df |>
  mutate(dta = map(file, read_excel))

dta_df2 <- map_df(fls_df$file, read_excel)
dta_df2
dta_df2a <- map_df(fls_df$file, read_excel, .id = "file")
dta_df2a
dta_df3 <- map2_df(fls_df$file, fls_df$url,
                   \(path, url) read_excel(path) |> mutate(url = url, path = path),
                   .id = "file")

dta_df3
dta_df3 |> count(url, path, file)

dir.create("kraje_export")

dta_df3 |>
  group_split(kraj, .keep = TRUE) |>
  map_chr(\(df) {
    kraj <- unique(df$kraj)
    file <- file.path("kraje_export", paste0(kraj, ".xlsx"))
    write_xlsx(df |> select(-kraj), file)
    return(file)
  })

kraje_csv <- dta_df3 |>
  group_split(kraj, .keep = TRUE) |>
  map_chr(\(df) {
    kraj <- unique(df$kraj)
    file <- file.path("kraje_export", paste0(kraj, ".csv"))
    write_csv(df |> select(-kraj), file)
    return(file)
  })

all_from_csv <- read_csv(kraje_csv, id = "zdroj")
all_from_csv2 <- all_from_csv |>
  mutate(soubor = basename(zdroj),
         kraj = tools::file_path_sans_ext(soubor))

all_from_csv2 |>
  count(zdroj, soubor, kraj)

csv_files <- list.files("kraje_export/", pattern = "*.csv", full.names = TRUE)
all_from_csv3 <- read_csv(csv_files, id = "zdroj")
all_from_csv3

dta_kraje_list <- group_split(dta_df3, kraj, .keep = TRUE)

write_xlsx(dta_kraje_list, "kraje.xlsx")

dta_from_excel <- map_dfr(excel_sheets("kraje.xlsx"), \(x) read_excel("kraje.xlsx", x), .id = "source_sheet")

dta_from_excel |>
  count(source_sheet)

listy <- excel_sheets("kraje.xlsx")
names(listy) <- listy

dta_from_excel2 <- imap_dfr(excel_sheets("kraje.xlsx"),
                           \(x, y) read_excel("kraje.xlsx", sheet = x) |>
                             mutate(source_sheet = x))

dta_from_excel2 |>
  count(source_sheet)

names(dta_kraje_list) <- map_chr(dta_kraje_list, \(x) x$kraj[[1]])
names(dta_kraje_list)

write_xlsx(dta_kraje_list, "kraje2.xlsx")

dta_from_excel3 <- imap_dfr(excel_sheets("kraje2.xlsx"),
                            \(x, y) read_excel("kraje2.xlsx", sheet = x) |>
                              mutate(source_sheet = x))

dta_from_excel3 |>
  count(source_sheet)

fs::path_ext_remove("file.csv.txt")
fs::path_ext("file.csv.txt")

tools::file_path_sans_ext("file.csv.txt")

dirname("slozka/soubor.xlsx")
