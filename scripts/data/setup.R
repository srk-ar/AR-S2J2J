suppressPackageStartupMessages(library(crayon))

# ── Logging helpers ───────────────────────────────────────────────────────────
.verbose <- function() isTRUE(getOption(".verbose", default = FALSE))
.quiet   <- function() isTRUE(getOption(".quiet",   default = FALSE))
.log <- function(prefix, ..., end = "\n") { cat(prefix, " ", paste(...), end, sep = "") }
.INFO  <- function(...) if (!.quiet())  .log(crayon::blue   ("[INFO]"),  ...)
.WARN  <- function(...)                 .log(crayon::yellow ("[WARN]"),  ...)
.ERROR <- function(...)                 .log(crayon::red    ("[ERROR]"), ...)
.OK    <- function(...) if (!.quiet())  .log(crayon::green  ("[OK]"),    ...)
.DEBUG <- function(...) if (.verbose()) .log(crayon::silver ("[DBG]"),   ...)
.HEAD  <- function(...) cat(crayon::bold(sprintf("\n=== %s ===\n", paste(...))))
