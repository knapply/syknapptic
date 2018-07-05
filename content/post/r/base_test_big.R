path_big_csv <- "test-data/big_csv.csv"

base_col_specs <- c("double", "double", "character",
                    "character", "double", "double",
                    "character", "character", "double",
                    "double", "double", "double")

df <- read.csv(file = path_big_csv, colClasses = base_col_specs)