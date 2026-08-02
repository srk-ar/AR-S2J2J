# scripts/runAudit.R — Audit rotation + scaling for all scenarios.
# Compares scenarios against the filtered GMSP source (not raw).
# Output: data/audit/{ScenarioID}.csv + data/audit/summary.csv

source(here::here("scripts", "tools", "setup.R"))

# ── Config ────────────────────────────────────────────────────────────────────
.args    <- commandArgs(trailingOnly = TRUE)
PATH.cfg <- if (length(.args) >= 1L) .args[1L] else here::here("scripts", "runAudit.json")
CFG      <- .readJson(PATH.cfg)

InputID <- .jsonRequire(CFG, "InputID", PATH.cfg)
tol     <- .jsonRequire(CFG, "tol", PATH.cfg)

# ── Setup ────────────────────────────────────────────────────────────────────
PATH.gmsp      <- here::here("data", "gmsp")
PATH.scenarios <- here::here("data", "records", "scenarios")
PATH.audit     <- here::here("data", "audit")
dir.create(PATH.audit, recursive = TRUE, showWarnings = FALSE)

# Source-of-truth units propagated by buildDomains. SF.L/T/V in each scenario
# JSON are PPV targets (velocity anchor); the velocity bridge to the gmsp
# mm-base convention is explicit and fail-loud (.getSF has no velocity map).
UNITS.file <- here::here("data", "domains", "units.json")
if (!file.exists(UNITS.file))
  stop(sprintf("runAudit: %s missing — run runData.R first so buildDomains writes the units sidecar.", UNITS.file))
UNITS       <- .readJson(UNITS.file)
FILE.gmsp   <- file.path(PATH.gmsp, InputID, sprintf("%s.json", InputID))
JSON.gmsp   <- .readJson(FILE.gmsp)
TargetUnits <- .jsonRequire(JSON.gmsp, "TargetUnits", FILE.gmsp)
PPV.U       <- .jsonRequire(UNITS, "ppv", UNITS.file)
if (!identical(PPV.U, "mm/s") || !identical(TargetUnits, "mm"))
  stop(sprintf("runAudit: unsupported ppv unit bridge (%s -> base %s).", PPV.U, TargetUnits))
G <- 1

DT  <- gmsp::TSW2TSL(fread(file.path(PATH.gmsp, InputID, "TSW.csv")))
IMW <- fread(file.path(PATH.gmsp, InputID, "IMW.csv"))

InputID.cfg <- InputID
SCENARIOS <- .readScenarioIndex(PATH.scenarios)[InputID == InputID.cfg]
setorder(SCENARIOS, Fmax, D, MIC, ScenarioID)
if (!nrow(SCENARIOS)) {
  stop(sprintf("runAudit: no scenarios found for InputID=%s.", InputID),
       call. = FALSE)
}

# ── Audit ─────────────────────────────────────────────────────────────────────
SUMMARY <- rbindlist(lapply(seq_len(nrow(SCENARIOS)), function(i) {
  ScenarioID <- SCENARIOS$ScenarioID[i]
  PATH.sc <- SCENARIOS$PATH.sc[i]
  FILE    <- SCENARIOS$JSON.file[i]
  JSON    <- .readJson(FILE)
  SF.L    <- .jsonRequire(JSON, "SF.L", FILE)
  SF.T    <- .jsonRequire(JSON, "SF.T", FILE)
  SF.V    <- .jsonRequire(JSON, "SF.V", FILE)
  AUX     <- gmsp::TSW2TSL(fread(file.path(PATH.sc, "TSW.csv")))
  IMW.sc  <- fread(file.path(PATH.sc, "IMW.csv"))
  RECORDS <- IMW.sc[, unique(RecordID)]

  OUT <- rbindlist(lapply(RECORDS, function(rec) {
    pgv.UP <- IMW.sc[RecordID == rec & OCID == "UP", PGV]
    H1     <- AUX[RecordID == rec & OCID == "H1" & ID == "AT", s]
    H2     <- AUX[RecordID == rec & OCID == "H2" & ID == "AT", s]
    L      <- DT[ RecordID == rec & OCID == "L"  & ID == "AT", s]
    T      <- DT[ RecordID == rec & OCID == "T"  & ID == "AT", s]
    L.v    <- DT[ RecordID == rec & OCID == "L"  & ID == "VT", s]
    T.v    <- DT[ RecordID == rec & OCID == "T"  & ID == "VT", s]

    n     <- min(length(H1), length(H2), length(L), length(T))
    eff.L <- SF.L * G / max(abs(L.v))
    eff.T <- SF.T * G / max(abs(T.v))
    E.HH  <- sum(H1[1:n]^2) + sum(H2[1:n]^2)
    E.LT  <- sum((L[1:n]*eff.L)^2) + sum((T[1:n]*eff.T)^2)

    data.table(
      RecordID  = rec,
      PGV.H1    = round(IMW.sc[RecordID==rec & OCID=="H1", PGV], 5),
      PGV.H2    = round(IMW.sc[RecordID==rec & OCID=="H2", PGV], 5),
      PGV.UP    = round(pgv.UP, 5),
      SF.V      = round(SF.V * G, 5),
      UP.ratio  = round(pgv.UP / (SF.V * G), 6),
      E.HH      = round(E.HH, 4),
      E.LT      = round(E.LT, 4),
      E.ratio   = round(E.HH / E.LT, 6),
      UP.ok     = abs(pgv.UP - SF.V * G) / (SF.V * G) < tol,
      energy.ok = abs(E.HH - E.LT) / E.LT < tol,
      PGA.pos   = all(IMW.sc[RecordID==rec & OCID %in% c("H1","H2","UP"), PGA] > 0))
  }))

  fwrite(OUT, file.path(PATH.audit, sprintf("%s.csv", ScenarioID)))
  PASS <- all(OUT$UP.ok) & all(OUT$energy.ok) & all(OUT$PGA.pos)
  message(sprintf("%s  %s  (n=%d)", ScenarioID, if(PASS) "✓" else "✗", nrow(OUT)))

  data.table(ScenarioID = ScenarioID,
             D = .jsonRequire(JSON, "D", FILE),
             MIC = .jsonRequire(JSON, "MIC", FILE),
             SF.L = SF.L, SF.T = SF.T, SF.V = SF.V,
             n.records = nrow(OUT),
             UP.ok     = all(OUT$UP.ok),
             energy.ok = all(OUT$energy.ok),
             PGA.pos   = all(OUT$PGA.pos),
             PASS      = PASS)
}), use.names = TRUE)

fwrite(SUMMARY, file.path(PATH.audit, "summary.csv"))
cat(sprintf("\n%d/%d scenarios PASS\nAudit saved -> data/audit/\n",
            sum(SUMMARY$PASS), nrow(SUMMARY)))
