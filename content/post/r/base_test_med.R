path_medium_csv <- "test-data/medium_csv.csv"

base_col_specs <- c("double", "double", "character",
                    "character", "double", "double",
                    "character", "character", "double",
                    "double", "double", "double")

df <- read.csv(file = path_medium_csv, colClasses = base_col_specs)