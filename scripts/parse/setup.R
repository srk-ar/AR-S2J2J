# nolint start

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
if (!require("data.table",   quietly=TRUE)) install.packages("data.table")
if (!require("readxl",       quietly=TRUE)) install.packages("readxl")
if (!require("digest",       quietly=TRUE)) install.packages("digest")
library(data.table)
setDTthreads(threads = 0)
# readxl, digest loaded via require() checks above
library(readxl)
library(stringdist)
library(RColorBrewer)
library(foreach)
library(doParallel)
library(TTR)
library(dbscan)
library(ggplot2)
library(highcharter)
library(grid)
library(png)
library(knitr)
library(htmlwidgets)
library(webshot2)
library(reticulate)
library(gbm) # for var importance
library(nnet)
library(MLmetrics)
library(tools)
library(signal)
library(crayon)
library(caret) |> suppressPackageStartupMessages()
library(caretEnsemble)
library(xgboost)
library(mgcv) # Add this line for gamSpline method

# **********************************************************************************

# nolint end

METHODS <- c("bayesglm","brnn","bartMachine","glm", "glmnet",  "kknn",  "gbm", "ranger")
RESPONSES <- c("ppv", "ppvL", "ppvT", "ppvV","ppaL","ppaT","ppaT","ppa")

.path.data <- file.path("data/dataset")
.path.summary <- file.path("data/summary")
.path.response <- file.path("data/response")
.path.model    = file.path("data/models")
.path.metrics  = file.path("data/metrics")
.path.response = file.path("data/response")


