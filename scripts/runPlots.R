# scripts/runPlots.R — Generate PSA + TS HTML plots for all scenarios.
# Config: scripts/runPlots.json  |  Run interactively from RStudio.

source(here::here("scripts", "tools", "setup.R"))

if (!requireNamespace("gmsp", quietly = TRUE) ||
    !("PSW2PSL" %chin% getNamespaceExports("gmsp"))) {
  stop("gmsp::PSW2PSL() is required. Reinstall gmsp >= 0.4.6.",
       call. = FALSE)
}

# ── Config ────────────────────────────────────────────────────────────────────
.args    <- commandArgs(trailingOnly = TRUE)
PATH.cfg <- if (length(.args) >= 1L) .args[1L] else here::here("scripts", "runPlots.json")
CFG      <- .readJson(PATH.cfg)

Fmax     <- as.integer(.jsonRequire(CFG, "Fmax", PATH.cfg))
P        <- .jsonRequire(CFG, "P", PATH.cfg)
DIR      <- .jsonRequire(CFG, "DIR", PATH.cfg)
OVERRIDE <- isTRUE(.jsonRequire(CFG, "OVERRIDE", PATH.cfg))

# ── Pipeline ─────────────────────────────────────────────────────────────────
PATH.scenarios <- here::here("data", "records", "scenarios")
Fmax.cfg <- Fmax
P.cfg <- P
SCENARIOS <- .readScenarioIndex(PATH.scenarios)[Fmax %in% Fmax.cfg & P == P.cfg]
setorder(SCENARIOS, Fmax, D, MIC, ScenarioID)
if (!nrow(SCENARIOS)) {
  stop("runPlots: no scenarios match Fmax/P.", call. = FALSE)
}

for (i in seq_len(nrow(SCENARIOS))) {
  ScenarioID <- SCENARIOS$ScenarioID[i]
  PATH.sc <- SCENARIOS$PATH.sc[i]
  FILE <- file.path(PATH.sc, "PSW.csv")
  if (!file.exists(FILE)) {
    message(sprintf("- %s: PSW.csv missing", ScenarioID))
    next
  }
  OCID <- unique(gmsp::PSW2PSL(fread(FILE, nrows = 1L))$OCID)
  for (.dir in DIR) {
    FILE <- file.path(PATH.sc, sprintf("PSA-%s.html", .dir))
    if (!.dir %chin% OCID) {
      message(sprintf("- PSA %s / %s: OCID not present", ScenarioID, .dir))
    } else if (OVERRIDE || !file.exists(FILE)) {
      tryCatch(
        { .plotPSA(DIR = .dir, PATH.in = PATH.sc)
          message(sprintf("✓ PSA %s / %s", ScenarioID, .dir)) },
        error = function(e) message(sprintf("✗ PSA %s / %s: %s", ScenarioID, .dir, e$message))
      )
    }
    TS.dir <- if (.dir %chin% c("D50", "D100")) "H1" else .dir
    FILE <- file.path(PATH.sc, sprintf("TS-%s.html", TS.dir))
    if (OVERRIDE || !file.exists(FILE))
      tryCatch(
        { .plotTS(DIR = TS.dir, PATH.in = PATH.sc)
          message(sprintf("✓ TS  %s / %s", ScenarioID, TS.dir)) },
        error = function(e) message(sprintf("✗ TS  %s / %s: %s", ScenarioID, TS.dir, e$message))
      )
  }
  unlink(list.files(PATH.sc, pattern = "_files$", full.names = TRUE),
         recursive = TRUE)
}
message(sprintf("runPlots done — %d scenarios x %d dirs", nrow(SCENARIOS), length(DIR)))
