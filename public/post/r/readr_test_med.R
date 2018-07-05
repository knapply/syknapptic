library(readr)

path_medium_csv <- "test-data/medium_csv.csv"

readr_col_specs <- list(col_double(), col_double(), col_character(),
                        col_character(), col_double(), col_double(),
                        col_character(), col_character(), col_double(),
                        col_double(), col_double(), col_double())

df <- read_csv(file = path_medium_csv, col_types = readr_col_specs)