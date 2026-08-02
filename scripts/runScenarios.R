# scripts/runScenarios.R — generate scenarios from filtered GMSP source.
# Config: scripts/runScenarios.json  |  Usage: Rscript scripts/runScenarios.R

source(here::here("scripts", "gmsp", "setup.R"))

# ── Config ────────────────────────────────────────────────────────────────────
.args <- commandArgs(trailingOnly = TRUE)
PATH.cfg <- if (length(.args) >= 1L) .args[1L] else here::here("scripts", "runScenarios.json")
CFG <- .readJson(PATH.cfg)

InputID <- as.character(.jsonRequire(CFG, "InputID", PATH.cfg))
D.grid <- as.numeric(.jsonRequire(CFG, "D.grid", PATH.cfg))
MIC.grid <- as.numeric(.jsonRequire(CFG, "MIC.grid", PATH.cfg))
P <- as.numeric(.jsonRequire(CFG, "P", PATH.cfg))
D50 <- isTRUE(.jsonRequire(CFG, "D50", PATH.cfg))
NTheta <- as.integer(.jsonRequire(CFG, "nTheta", PATH.cfg))
PARALLEL <- isTRUE(.jsonRequire(CFG, "PARALLEL", PATH.cfg))
OVERRIDE <- isTRUE(.jsonRequire(CFG, "OVERRIDE", PATH.cfg))
if (!length(InputID) || any(is.na(InputID) | !nzchar(InputID))) {
  stop("runScenarios: InputID must be a non-empty character vector.",
    call. = FALSE)
}
if (!length(D.grid) || any(is.na(D.grid))) {
  stop("runScenarios: D.grid must be numeric.", call. = FALSE)
}
if (!length(MIC.grid) || any(is.na(MIC.grid))) {
  stop("runScenarios: MIC.grid must be numeric.", call. = FALSE)
}
if (length(P) != 1L || is.na(P)) {
  stop("runScenarios: P must be one number.", call. = FALSE)
}
if (length(NTheta) != 1L ||
  is.na(NTheta) ||
  NTheta < 1L) {
  stop("runScenarios: nTheta must be one positive integer.", call. = FALSE)
}

# ── Generate ─────────────────────────────────────────────────────────────────
invisible(lapply(InputID, function(.InputID)
  .scaleAT(InputID = .InputID,
    D.grid = D.grid,
    MIC.grid = MIC.grid,
    P = P,
    D50 = D50,
    nTheta = NTheta,
    PARALLEL = PARALLEL,
    OVERRIDE = OVERRIDE)
))

# ── Merge scenario index ─────────────────────────────────────────────────────
.buildMasterIMW(PATH.out = here::here("data", "records", "scenarios"))
