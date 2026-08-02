# scripts/runGMSP.R — signal processing pipeline (buildTS + filterTS only).
# Generates the filtered source for scenario generation (runScenarios.R).

source(here::here("scripts", "gmsp", "setup.R"))

# ── Schema ──────────────────────────────────────────────────────────────────
Method <- "vmd"
K.imf <- 10L
IMF.remove <- 1L                 # IMF1: modo de baja frecuencia en VMD
PARALLEL <- TRUE
OVERRIDE <- FALSE

# ── Sources ─────────────────────────────────────────────────────────────────
Runs <- data.table(Fmax = 125L, kNyq = 3.2)

for (i in seq_len(nrow(Runs))) {
  Fmax <- Runs[["Fmax"]][i]
  kNyq <- Runs[["kNyq"]][i]
  InputID <- sprintf("F%d.Qo.Do", Fmax)
  OutputID <- paste0(InputID, ".", Method)

  .buildTS(InputID = InputID, Fmax = Fmax, kNyq = kNyq,
           OVERRIDE = OVERRIDE)
  .filterTS(InputID = InputID, OutputID = OutputID, Method = Method,
            K.imf = K.imf, IMF.remove = IMF.remove,
            keepResidual = FALSE, PARALLEL = PARALLEL,
            OVERRIDE = OVERRIDE)
  .suggestFmax(OutputID = OutputID)
}
