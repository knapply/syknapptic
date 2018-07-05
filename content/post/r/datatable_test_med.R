library(data.table)

path_medium_csv <- "test-data/medium_csv.csv"

datatable_col_specs <- c("double", "double", "character",
                         "character", "double", "double",
                         "character", "character", "double",
                         "double", "double", "double")

df <- fread(file = path_medium_csv, colClasses = datatable_col_specs)