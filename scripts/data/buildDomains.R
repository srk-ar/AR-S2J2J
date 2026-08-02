# nolint start
# buildDomains.R - project-side (AR-S2J2J).
# Builds domain CSVs {Y, Q, D, S}.csv from the external blastDB. Each domain
# contains BOTH training rows (real blast events, SampleID X<5d>, responses
# populated) AND grid rows (synthetic Q x D Cartesian product, SampleID
# G<5d>, responses NA). Train/predict split is then assigned downstream
# (buildDatasets) based on whether the response is NA.
#
# Blast-specific config (blastDB, domain ranges, grid ranges) lives in the
# manifest's `parse` subsection (M$parse, passed in as PC by the caller).

library(data.table)
library(jsonlite)

buildDomains <- function(M, PC) {
  PATH.D <- M$dirs$domains
  D_MIN  <- PC$domain$D$min; D_MAX <- PC$domain$D$max
  Q_MIN  <- PC$domain$Q$min; Q_MAX <- PC$domain$Q$max
  RESP   <- M$responses$names

  # -- 1. Training rows from blastDB -----------------------------------------
  DB_PATH <- path.expand(PC$blastDB$path)
  if (!file.exists(DB_PATH))
    stop(sprintf("buildDomains: blastDB not found: %s", DB_PATH))

  ENABLED <- names(Filter(isTRUE, PC$blastDB$sources))
  if (length(ENABLED) == 0L)
    stop("buildDomains: no sources enabled in manifest$parse$blastDB$sources")

  DT.train <- fread(DB_PATH)[
    Source %in% ENABLED &
    D >= D_MIN & D <= D_MAX & Q >= Q_MIN & Q <= Q_MAX &
    ((!is.na(ppvL) & !is.na(ppvT) & !is.na(ppvV)) |
     (!is.na(ppaL) & !is.na(ppaT) & !is.na(ppaV)))]

  if (nrow(DT.train) == 0L)
    stop(sprintf("buildDomains: 0 train rows  D=[%.0f,%.0f] Q=[%.0f,%.0f] sources=%s",
                 D_MIN, D_MAX, Q_MIN, Q_MAX, paste(ENABLED, collapse = ",")))

  # -- 1a. Exterior admission ---------------------------------------------------
  # Sources marked "exterior" in manifest$parse$blastDB$admission contribute
  # rows ONLY where the site has no coverage in the physical coordinates:
  # a row is admitted iff its D falls outside the site D-range OR its Q falls
  # outside the site Q-range (never inside both — that mixes amplitude levels
  # where the site has readings; cut in D/Q, not in scaled distance).
  ADMISSION <- PC$blastDB$admission
  if (!is.null(ADMISSION)) {
    EXT <- names(Filter(function(x) identical(x, "exterior"), ADMISSION))
    if (length(EXT)) {
      SITE <- setdiff(ENABLED, EXT)
      DR <- DT.train[Source %in% SITE, range(D)]
      QR <- DT.train[Source %in% SITE, range(Q)]
      n0 <- nrow(DT.train)
      DT.train <- DT.train[!(Source %in% EXT) |
                           D < DR[1] | D > DR[2] | Q < QR[1] | Q > QR[2]]
      .INFO(sprintf("exterior admission: %s -> %d of %d exterior rows kept (site envelope D=[%.0f,%.0f] Q=[%.0f,%.0f])",
                    paste(EXT, collapse = ","),
                    DT.train[Source %in% EXT, .N], n0 - DT.train[!Source %in% EXT, .N],
                    DR[1], DR[2], QR[1], QR[2]))
    }
  }

  # -- 1b. Assert unit homogeneity across surviving train rows ----------------
  # The peaks (ppv*, ppa*) in blastDB are declared per-row via ppv.Units and
  # ppa.Units. The trained model is unit-agnostic, so every kept row must
  # agree on the unit. Fail loud if anything is mixed or undeclared.
  for (.col in c("ppv.Units", "ppa.Units")) {
    if (!.col %chin% names(DT.train))
      stop(sprintf("buildDomains: blastDB is missing column '%s' (run the migration that adds per-row unit declarations).", .col))
  }
  PPV_U <- unique(DT.train[!is.na(ppvL) & !is.na(ppvT) & !is.na(ppvV), ppv.Units])
  PPA_U <- unique(DT.train[!is.na(ppaL) & !is.na(ppaT) & !is.na(ppaV), ppa.Units])
  if (length(PPV_U) != 1L || is.na(PPV_U))
    stop(sprintf("buildDomains: ppv.Units must be a single non-NA value across train rows; got [%s] from sources [%s]. Declare units explicitly in blastDB.csv.",
                 paste(PPV_U, collapse = ", "), paste(ENABLED, collapse = ", ")))
  if (length(PPA_U) != 1L || is.na(PPA_U))
    stop(sprintf("buildDomains: ppa.Units must be a single non-NA value across train rows; got [%s] from sources [%s]. Declare units explicitly in blastDB.csv.",
                 paste(PPA_U, collapse = ", "), paste(ENABLED, collapse = ", ")))
  .INFO(sprintf("units: ppv=%s  ppa=%s  (homogeneous across %d train rows)",
                PPV_U, PPA_U, nrow(DT.train)))

  DT.train[, SampleID := paste0("X", formatC(.I, width = 5, flag = "0", format = "d"))]
  # Source traceability sidecar: figures and site-restricted diagnostics need
  # to tell site rows from exterior-admitted rows after this point.
  fwrite(DT.train[, .(SampleID, Source)], file.path(PATH.D, "sources.csv"))
  DT.train[, `:=`(
    ppv = round(sqrt(ppvL^2 + ppvT^2 + ppvV^2), 3),
    ppa = round(sqrt(ppaL^2 + ppaT^2 + ppaV^2), 3),
    sL  = round(ppvL / ppaL, 4),
    sT  = round(ppvT / ppaT, 4),
    sV  = round(ppvV / ppaV, 4)
  )]
  n_na <- sum(!is.finite(c(DT.train$sL, DT.train$sT, DT.train$sV)))
  if (n_na > 0L) .WARN(sprintf("%d sL/sT/sV set to NA", n_na))
  for (.col in c("sL","sT","sV"))
    set(DT.train, which(!is.finite(DT.train[[.col]])), .col, NA_real_)

  Missing <- setdiff(RESP, names(DT.train))
  if (length(Missing) > 0L)
    stop(sprintf("buildDomains: response columns missing: [%s]",
                 paste(Missing, collapse = ", ")))

  # Responses are modelled in log10 space (E21 series: multiplicative residuals,
  # physical Q-shift). Downstream exports back-transform (runPost epilogue);
  # units.json keeps the native source-of-truth units.
  for (.col in RESP)
    DT.train[, (.col) := fifelse(!is.na(get(.col)) & get(.col) > 0,
                                 round(log10(get(.col)), 6), NA_real_)]

  # -- 2. Grid rows from Q x D Cartesian -------------------------------------
  GRID_Q <- seq(PC$grid$Q$min, PC$grid$Q$max, by = PC$grid$Q$step)
  GRID_D <- seq(PC$grid$D$min, PC$grid$D$max, by = PC$grid$D$step)
  if (length(GRID_Q) == 0L || length(GRID_D) == 0L)
    stop("buildDomains: GRID_Q or GRID_D empty - check PC$grid bounds/step")

  DT.grid <- CJ(MIC = GRID_Q, D = GRID_D, sorted = FALSE)
  # Grid SampleID is an opaque counter (G prefix). The physical Q,D values
  # live as columns in Q.csv and D.csv — a consumer who needs (Q,D) for a
  # given prediction joins Yo.csv with Q.csv / D.csv by SampleID. This
  # matches the BAN / AR-SABE0 pattern where SampleIDs are opaque codes.
  DT.grid[, SampleID := paste0("G", formatC(seq_len(.N), width = 5, flag = "0", format = "d"))]

  .INFO(sprintf("buildDomains: %d train rows + %d grid rows  D=[%.0f,%.0f]  Q=[%.0f,%.0f]  sources: %s",
                nrow(DT.train), nrow(DT.grid),
                D_MIN, D_MAX, Q_MIN, Q_MAX, paste(ENABLED, collapse = ", ")))

  # -- 3. Y.csv: SampleID + responses (NA for grid rows) ---------------------
  Y.train <- DT.train[, c("SampleID", RESP), with = FALSE]
  Y.grid  <- data.table(SampleID = DT.grid$SampleID)
  for (r in RESP) Y.grid[, (r) := NA_real_]
  Y <- rbindlist(list(Y.train, Y.grid), use.names = TRUE)

  # -- 4. Q.csv: SampleID + MIC, LnQ, iQ -------------------------------------
  Q.train <- DT.train[, .(SampleID, MIC = Q)]
  Q.train[, `:=`(LnQ = round(log(MIC), 6), iQ = round(1/MIC, 6))]
  Q.grid <- DT.grid[, .(SampleID, MIC)]
  Q.grid[, `:=`(LnQ = round(log(MIC), 6), iQ = round(1/MIC, 6))]
  Q <- rbindlist(list(Q.train, Q.grid), use.names = TRUE)

  # -- 5. D.csv: SampleID + D, LnD, iD ---------------------------------------
  D.train <- DT.train[, .(SampleID, D)]
  D.train[, `:=`(LnD = round(log(D), 6), iD = round(1/D, 6))]
  D.grid <- DT.grid[, .(SampleID, D)]
  D.grid[, `:=`(LnD = round(log(D), 6), iD = round(1/D, 6))]
  D <- rbindlist(list(D.train, D.grid), use.names = TRUE)

  # -- 6. S.csv: SampleID + SD -----------------------------------------------
  S.train <- DT.train[, .(SampleID, D, MIC = Q)]
  S.train[, SD := round(D/sqrt(MIC), 4)]
  S.train[, LnSD := round(log10(SD), 6)]
  S.train <- S.train[is.finite(LnSD), .(SampleID, SD, LnSD)]
  S.grid <- DT.grid[, .(SampleID, D, MIC)]
  S.grid[, SD := round(D/sqrt(MIC), 4)]
  S.grid[, LnSD := round(log10(SD), 6)]
  S.grid <- S.grid[is.finite(LnSD), .(SampleID, SD, LnSD)]
  S <- rbindlist(list(S.train, S.grid), use.names = TRUE)

  # -- 7. Write domain CSVs --------------------------------------------------
  for (nm in c("Y","Q","D","S")) {
    fwrite(get(nm), file.path(PATH.D, paste0(nm, ".csv")))
    .DEBUG(sprintf("%s.csv: %d rows", nm, nrow(get(nm))))
  }
  .INFO(sprintf("domains written: Y/Q/D/S.csv (n=%d train + %d grid = %d total)",
                nrow(DT.train), nrow(DT.grid), nrow(DT.train) + nrow(DT.grid)))

  # -- 8. Units sidecar — propagate source-of-truth units downstream ---------
  # Read by scripts/gmsp/setup.R::.scaleAT() and scripts/runAudit.R when they
  # cross from unit-agnostic ML predictions back into the physical timeseries.
  write_json(list(ppv = PPV_U, ppa = PPA_U,
                  sources = ENABLED,
                  n.train = nrow(DT.train),
                  dateUTC = format(Sys.time(), tz = "UTC", "%Y-%m-%dT%H:%M:%SZ")),
             file.path(PATH.D, "units.json"),
             auto_unbox = TRUE, pretty = TRUE)
  .INFO(sprintf("units.json written: ppv=%s ppa=%s", PPV_U, PPA_U))
}
# nolint end
