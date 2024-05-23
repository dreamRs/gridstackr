
genId <- function(bytes = 12) {
  paste(format(as.hexmode(sample(256, bytes, replace = TRUE) - 1), width = 2), collapse = "")
}

