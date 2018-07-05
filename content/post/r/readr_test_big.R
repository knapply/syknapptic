library(readr)

path_big_csv <- "test-data/big_csv.csv"

readr_col_specs <- list(col_double(), col_double(), col_character(),
                        col_character(), col_double(), col_double(),
                        col_character(), col_character(), col_double(),
                        col_double(), col_double(), col_double())

df <- read_csv(file = path_big_csv, col_types = readr_col_specs)