library(data.table)

path_big_csv <- "test-data/big_csv.csv"

datatable_col_specs <- c("double", "double", "character",
                         "character", "double", "double",
                         "character", "character", "double",
                         "double", "double", "double")

df <- fread(file = path_big_csv, colClasses = datatable_col_specs)