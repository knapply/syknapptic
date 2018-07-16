library(bench)
library(reticulate)

# https://datascienceplus.com/loops-in-r-and-python-who-is-faster/
n_elements <- 1e5
# probe points
x <- c(10,100,1000,5000,10000,25000,50000,75000,100000)
# for loop
vec <- vector()
elapsed <- NULL
for (i in seq_len(n_elements))
{
    vec <- c(vec, sample(i, size = 1, replace = T))
    if(i %in% x) 
        elapsed <- c(elapsed, as.numeric(difftime(Sys.time(), t, 'secs')))
}
# lapply function
t <- Sys.time()
vec <- NULL
elapsed_sapply <- lapply(seq_len(n_elements), function(i) {
    vec <- c(vec, sample(i, size = 1, replace = T))
    if(i %in% x) 
        return(as.numeric(difftime(Sys.time(), t, 'secs')))
}) %>% Filter(Negate(is.null), .) %>% unlist()

x = rnorm(1e6)


loop <- function(x) {
  vec <- vector(mode = mode(x), length = length(x))
  for(i in x) {
    vec[[i]] <- x[[i]]^2
  }
}

loop <- function(x) {
  vapply(x, function(x) x^2, numeric(1))
}

"
x = r.x
lst = {}
" %>% 
  py_run_string(convert = FALSE)

"
for i in range(len(x)):
  lst[i] = x[i]**2
" -> loop

mark(
  vapply(x, function(x) x^2, double(1)),
  py_run_string(loop, convert = FALSE),
  check = FALSE, iterations = 100
)

.Last.value %>% 
  autoplot()

hetero <- list("1", 3L, 3.14, FALSE) %>% 
  replicate(n = 1000, simplify = FALSE)


hetero_loop <- function(hetero) {
  new <- vector("numeric", length(hetero) * length(hetero[[1]]))
  for(i in seq_len(length(hetero))) {
    new[i] <- as.numeric(hetero[[i]])^2
  }
}

"
hetero = r.hetero
new = {}
" %>% 
  py_run_string()

"
for i in hetero:
  new[i] <- float(hetero[i])**2
" -> py_hetero_loop

mark(
  hetero_loop(hetero),
  py_run_string(py_hetero_loop, convert = FALSE),
  check = FALSE, iterations = 100
)


library(microbenchmark)
microbenchmark(
  vapply(x, function(x) x^2, double(1)),
  py_run_string(loop, convert = FALSE),
  times = 100
)


