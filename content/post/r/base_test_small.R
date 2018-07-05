path_small_csv <- "test-data/small_csv.csv"

base_col_specs <- c("double", "double", "character",
                    "character", "double", "double",
                    "character", "character", "double",
                    "double", "double", "double")

df <- read.csv(file = path_small_csv, colClasses = base_col_specs)