## scripts/runData.R — AR-S2J2J data pipeline entry point.
## Usage: Rscript scripts/runData.R [path/to/manifest.json]
##
## Project-side orchestrator. Reads the manifest, calls buildDomains() to
## turn the blast database into Y/Q/D/S domain CSVs (with training rows +
## synthetic Q×D grid rows), then buildDatasets() to assemble per-dataset
## CSVs in data/datasets/. From there downstream (modelPipeline,
## chainPipeline) is handled by library(ssel).

library(jsonlite)
library(data.table)

# Logging helpers (.INFO / .WARN / .DEBUG used inside buildDomains).
source("scripts/data/setup.R")

# Project-local builders.
source("scripts/data/buildDomains.R")
source("scripts/data/buildDatasets.R")

# Manifest.
.args <- commandArgs(trailingOnly = TRUE)
PATH.manifest <- if (length(.args) >= 1L) .args[1] else "scripts/manifest.json"
stopifnot(file.exists(PATH.manifest))

M  <- fromJSON(PATH.manifest, simplifyVector = TRUE, simplifyDataFrame = FALSE)
PC <- M$parse

cat(sprintf("[data/run.R] manifest=%s\n", PATH.manifest))

# Phase 1: blastDB → data/domains/{Y,Q,D,S}.csv
buildDomains(M, PC)

# Phase 2: data/domains → data/datasets/<DatasetID>.csv
buildDatasets(M)

cat("\n=== DONE ===\n")
