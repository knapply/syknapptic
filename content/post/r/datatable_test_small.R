library(data.table)

path_small_csv <- "test-data/small_csv.csv"

datatable_col_specs <- c("double", "double", "character",
                         "character", "double", "double",
                         "character", "character", "double",
                         "double", "double", "double")

df <- fread(file = path_small_csv, colClasses = datatable_col_specs)