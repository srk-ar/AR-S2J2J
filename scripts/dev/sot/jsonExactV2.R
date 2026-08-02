# SoT prototype for exact JSON access.
# Intentional behavior change: missing keys are missing; they must not partial
# match longer names such as D -> DateTime.

.jsonHasV2 <- function(.x, key) {
  OUT <- .x
  for (s in key) {
    if (!is.list(OUT) || !(s %chin% names(OUT))) return(FALSE)
    OUT <- OUT[[s, exact = TRUE]]
  }
  TRUE
}

.jsonGetV2 <- function(.x, key, default = NULL) {
  OUT <- .x
  for (s in key) {
    if (!is.list(OUT) || !(s %chin% names(OUT))) return(default)
    OUT <- OUT[[s, exact = TRUE]]
  }
  OUT
}

.jsonRequireV2 <- function(.x, key, file = NULL) {
  if (.jsonHasV2(.x, key)) return(.jsonGetV2(.x, key))
  Label <- paste(key, collapse = ".")
  if (!is.null(file)) Label <- sprintf("%s in %s", Label, file)
  stop(sprintf("Missing required JSON key: %s", Label), call. = FALSE)
}

.readIseeRecordV2 <- function(file) {
  Json <- jsonlite::read_json(file, simplifyVector = TRUE)
  D <- .jsonGetV2(Json, "D")
  Q <- .jsonGetV2(Json, "Q")
  data.table::data.table(
    EventID   = .jsonRequireV2(Json, c("Event", "EventID"), file),
    StationID = .jsonRequireV2(Json, c("Station", "StationID"), file),
    Fs        = .jsonRequireV2(Json, c("Record", "Fs"), file)[1L],
    D         = if (!is.null(D)) as.numeric(D) else NA_real_,
    Q         = if (!is.null(Q)) as.integer(Q) else NA_integer_)
}
