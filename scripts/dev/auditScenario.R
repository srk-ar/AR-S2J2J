# scripts/dev/auditScenario.R
# Production audit: verifies rotation + scaling for all records in a scenario.
# Checks:
#   1. UP.scale    — PGA of UP ≈ SF.V (correct V scaling)
#   2. energy.rot  — H1²+H2² energy = L_scaled²+T_scaled² (rotation invariant)
#   3. PGA.positive — all PGA values > 0 (no degenerate signals)
#   4. files.ok    — required output files present

library(here); library(data.table); library(jsonlite)
source(here::here("scripts", "setup.R"))

# ── Schema ──────────────────────────────────────────────────────────────────
PATH.gmsp    <- here::here("data", "gmsp")
InputID.raw  <- "F80.Qo.Do"
Fmax         <- 80L
D            <- 250
MIC          <- 200
tol          <- 1e-3   # 0.1% relative tolerance

# ── Load ─────────────────────────────────────────────────────────────────────
ScenarioID <- sprintf("F%d.D%d.Q%d", Fmax, D, MIC)
PATH.sc    <- file.path(PATH.gmsp, ScenarioID)
stopifnot(dir.exists(PATH.sc))

J       <- read_json(file.path(PATH.sc, sprintf("%s.json", ScenarioID)))
IMW.sc  <- fread(file.path(PATH.sc, "IMW.csv"))
TSL.sc  <- fread(file.path(PATH.sc, "TSL.csv"))
TSL.raw <- fread(file.path(PATH.gmsp, InputID.raw, "TSL.csv"))
RECORDS <- IMW.sc[, unique(RecordID)]

cat(sprintf("=== Audit: %s | n=%d records ===\n", ScenarioID, length(RECORDS)))
cat(sprintf("SF: L=%.4f  T=%.4f  V=%.4f  (p=%.2f)\n\n", J$SF.L, J$SF.T, J$SF.V, J$P))

# ── Check 1: required files ───────────────────────────────────────────────────
REQ <- c("TSL.csv","TSW.csv","IMW.csv","META.csv","PSL.csv",
         sprintf("%s.json", ScenarioID))
files.ok <- all(REQ %in% list.files(PATH.sc))
cat(sprintf("files.ok: %s\n", files.ok))

# ── Per-record checks ─────────────────────────────────────────────────────────
AUX <- rbindlist(lapply(RECORDS, function(rec) {

  # Check 2: UP PGA ≈ SF.V
  pga.UP <- IMW.sc[RecordID == rec & OCID == "UP", PGA]
  chk.UP <- length(pga.UP) == 1L && abs(pga.UP - J$SF.V) / J$SF.V < tol

  # Check 3: Rotation energy invariant
  # sum(H1_AT²) + sum(H2_AT²) ≈ sum(L_AT_scaled²) + sum(T_AT_scaled²)
  H1 <- TSL.sc[RecordID == rec & OCID == "H1" & ID == "AT", s]
  H2 <- TSL.sc[RecordID == rec & OCID == "H2" & ID == "AT", s]
  L.raw <- TSL.raw[RecordID == rec & OCID == "L" & ID == "AT", s]
  T.raw <- TSL.raw[RecordID == rec & OCID == "T" & ID == "AT", s]

  # Align lengths (AT2TS may resample)
  n <- min(length(H1), length(H2), length(L.raw), length(T.raw))
  if (n < 2L) return(data.table(RecordID=rec, UP.scale=FALSE, energy.rot=FALSE, PGA.pos=FALSE))

  eff.L <- J$SF.L / IMW.sc[RecordID==rec & OCID=="H1", PGA][1] *
           IMW.sc[RecordID==rec & OCID=="H1", PGA][1] / max(abs(L.raw))
  # Simpler: compute scaled L/T directly
  eff.L2 <- J$SF.L / max(abs(L.raw))
  eff.T2 <- J$SF.T / max(abs(T.raw))
  L.sc <- L.raw[1:n] * eff.L2
  T.sc <- T.raw[1:n] * eff.T2

  E.HH <- sum(H1[1:n]^2) + sum(H2[1:n]^2)
  E.LT <- sum(L.sc^2) + sum(T.sc^2)
  chk.energy <- abs(E.HH - E.LT) / E.LT < tol

  # Check 4: PGA positive and non-zero
  pga.H1 <- IMW.sc[RecordID==rec & OCID=="H1", PGA]
  pga.H2 <- IMW.sc[RecordID==rec & OCID=="H2", PGA]
  chk.pga <- all(c(pga.H1, pga.H2, pga.UP) > 0)

  data.table(RecordID    = rec,
             PGA.H1     = round(IMW.sc[RecordID==rec & OCID=="H1", PGA], 5),
             PGA.H2     = round(IMW.sc[RecordID==rec & OCID=="H2", PGA], 5),
             PGA.UP     = round(pga.UP, 5),
             SF.V       = round(J$SF.V, 5),
             UP.ratio   = round(pga.UP / J$SF.V, 6),
             E.HH       = round(E.HH, 4),
             E.LT       = round(E.LT, 4),
             E.ratio    = round(E.HH / E.LT, 6),
             UP.scale   = chk.UP,
             energy.rot = chk.energy,
             PGA.pos    = chk.pga)
}))

# ── Summary ──────────────────────────────────────────────────────────────────
COLS <- c("UP.scale","energy.rot","PGA.pos")
cat("\nCheck          PASS  Failures\n")
cat(rep("-",35),"\n",sep="")
for (chk in COLS) {
  n.fail <- sum(!AUX[[chk]])
  cat(sprintf("%-15s  %-5s  %d\n", chk, all(AUX[[chk]]), n.fail))
}
cat(sprintf("files.ok        %-5s  %s\n", files.ok, ""))

overall <- all(unlist(AUX[, COLS, with=FALSE])) && files.ok
cat(sprintf("\n%s  (%d/%d records)\n",
    if(overall) "✓ ALL CHECKS PASS" else "✗ FAILURES DETECTED",
    sum(apply(AUX[, COLS, with=FALSE], 1, all)), nrow(AUX)))

fwrite(AUX, file.path(PATH.sc, "audit.csv"))
cat(sprintf("Audit saved -> %s/audit.csv\n", ScenarioID))
