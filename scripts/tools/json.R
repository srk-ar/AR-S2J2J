# Exact JSON access helpers. Never use `$` for JSON-derived lists: R partial
# matching can resolve a missing key such as D to DateTime.

.readJson <- function(file, simplifyVector = TRUE)
  jsonlite::read_json(file, simplifyVector = simplifyVector)

.jsonHas <- function(.x, key) {
  OUT <- .x
  for (s in key) {
    if (!is.list(OUT) || !(s %in% names(OUT))) return(FALSE)
    OUT <- OUT[[s, exact = TRUE]]
  }
  TRUE
}

.jsonGet <- function(.x, key, default = NULL) {
  OUT <- .x
  for (s in key) {
    if (!is.list(OUT) || !(s %in% names(OUT))) return(default)
    OUT <- OUT[[s, exact = TRUE]]
  }
  OUT
}

.jsonNumber <- function(.x, key, default = NA_real_) {
  Value <- .jsonGet(.x, key)
  if (is.null(Value)) return(default)
  as.numeric(Value)
}

.jsonInteger <- function(.x, key, default = NA_integer_) {
  Value <- .jsonGet(.x, key)
  if (is.null(Value)) return(default)
  as.integer(Value)
}

.jsonRequire <- function(.x, key, file = NULL) {
  if (.jsonHas(.x, key)) return(.jsonGet(.x, key))
  Label <- paste(key, collapse = ".")
  if (!is.null(file)) Label <- sprintf("%s in %s", Label, file)
  stop(sprintf("Missing required JSON key: %s", Label), call. = FALSE)
}
