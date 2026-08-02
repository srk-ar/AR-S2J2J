# scripts/gmsp/setup.R — GMSP pipeline functions requiring gmsp.
# Sources scripts/tools/setup.R (lightweight helpers: plot builders, tsw2tsl, etc.)
# then adds gmsp-heavy functions: .buildTS(), .filterTS(), and .scaleAT().

source(here::here("scripts", "tools", "setup.R"))

.loadPackages(c("gmsp", "foreach", "doParallel"))

# kashimaDB paths (project constants)
.FILE.INDEX   <- "~/kashimaDB/gmdb.v2/index/RawRecordTable.ISEE.csv"
.PATH.RECORDS <- "~/kashimaDB/gmdb.v2/records"

.unlinkGeneratedDir <- function(path, root) {
  Path <- sub("/+$", "", normalizePath(path, winslash = "/", mustWork = FALSE))
  Root <- sub("/+$", "", normalizePath(root, winslash = "/", mustWork = FALSE))
  if (Path == Root || !startsWith(Path, paste0(Root, "/"))) {
    stop(sprintf("Refusing to unlink outside generated root: %s", path),
         call. = FALSE)
  }
  unlink(Path, recursive = TRUE)
}

.buildTS <- function(InputID, Fmax, kNyq,
                     XI          = c(0.05),
                     TargetUnits = "mm",
                     Tn.min      = NULL,
                     Tn.max      = 1,
                     n.Tn        = 101L,
                     NORMALIZE   = FALSE,
                     OVERRIDE    = FALSE) {

  PATH.out <- here::here("data", "gmsp", InputID)
  TSL.file  <- file.path(PATH.out, "TSL.csv")
  TSW.file  <- file.path(PATH.out, "TSW.csv")
  IMW.file  <- file.path(PATH.out, "IMW.csv")
  META.file <- file.path(PATH.out, "META.csv")
  PSL.file  <- file.path(PATH.out, "PSL.csv")
  JSON.file <- file.path(PATH.out, sprintf("%s.json", InputID))

  if (OVERRIDE) {
    .unlinkGeneratedDir(PATH.out, here::here("data", "gmsp"))
    dir.create(PATH.out, recursive = TRUE, showWarnings = FALSE)
  }
  if (!OVERRIDE &&
      file.exists(TSL.file) && file.exists(PSL.file)) {
    message(sprintf(".buildTS: already exists — skipping %s", InputID)); return(invisible(NULL))
  }
  dir.create(PATH.out, recursive = TRUE, showWarnings = FALSE)

  INDEX <- fread(file = path.expand(.FILE.INDEX))
  SEL   <- INDEX[, .(RecordID, OwnerID, EventID, StationID)]
  VTo   <- readTS(.x = SEL, path = .PATH.RECORDS, kind = "VT")
  COLS  <- setdiff(names(VTo), c("RecordID","OwnerID","EventID","StationID","t"))

  # Sidecar `<KIND>.<RID>.json` declares Units as length-base (e.g. "mm").
  # KIND is implicit in the readTS(kind=...) call. Pass the canonical length
  # base to VT2TS — gmsp >= 0.4.3 rejects verbose forms like "mm/s".
  TSL <- VTo[, VT2TS(.SD, units.source = "mm", Fmax = Fmax, kNyq = kNyq,
                     units.target = TargetUnits, output = "TSL"),
             by = .(RecordID, OwnerID, EventID, StationID),
             .SDcols = c("t", COLS)][, .(RecordID, OCID, ID, t, s)]

  if (NORMALIZE) normalizeTS(.x = TSL, norm = "PGA")

  TSW <- gmsp::TSL2TSW(TSL)
  IMW <- gmsp::TSL2IM(.x = TSL, units.source = TargetUnits,
                      units.target = TargetUnits, output = "IMW")

  FILES <- list.files(file.path(path.expand(.PATH.RECORDS), "ISEE"),
                      pattern = "^record[.]json$", recursive = TRUE, full.names = TRUE)
  REC <- rbindlist(lapply(FILES, function(fp) {
    JSON <- .readJson(fp)
    data.table(EventID   = .jsonRequire(JSON, c("Event", "EventID"), fp),
               StationID = .jsonRequire(JSON, c("Station", "StationID"), fp),
               Fs        = .jsonRequire(JSON, c("Record", "Fs"), fp)[1L],
               D         = .jsonNumber(JSON, "D"),
               Q         = .jsonInteger(JSON, "Q"))
  }))
  META <- INDEX[REC, on = c("EventID","StationID"),
                .(RecordID, D = i.D, Q = i.Q, Fs = i.Fs)][!is.na(D) & !is.na(Q)]

  if (is.null(Tn.min)) Tn.min <- 1 / Fmax
  Tn.grid <- 10^seq(log10(Tn.min), log10(Tn.max), length.out = n.Tn)

  PSL <- gmsp::TSL2PS(.x = TSL, xi = XI, Tn = Tn.grid,
                      output = "PSL")
  if (!("xi" %chin% names(PSL))) PSL[, xi := XI[1L]]
  setcolorder(PSL, c("RecordID", "OCID", "xi", "Tn", "ID", "S"))

  fwrite(TSL, TSL.file); fwrite(TSW, TSW.file)
  fwrite(IMW, IMW.file); fwrite(META, META.file); fwrite(PSL, PSL.file)
  write_json(list(InputID = InputID, Fmax = Fmax, kNyq = kNyq, XI = XI,
                  Tn.min = Tn.min, Tn.max = Tn.max, TargetUnits = TargetUnits,
                  NR = uniqueN(TSL$RecordID),
                  dateUTC = format(Sys.time(), tz = "UTC", "%Y-%m-%dT%H:%M:%SZ")),
             JSON.file, auto_unbox = TRUE, pretty = TRUE)
  message(sprintf(".buildTS done -> %s/", InputID))
}

.filterTS <- function(InputID, OutputID,
                      Method        = "eemd",
                      K.imf         = 10L,
                      IMF.remove    = c(-1L, -2L),
                      Fo.low        = 0,
                      keepResidual  = FALSE,
                      PARALLEL      = TRUE,
                      OVERRIDE      = FALSE) {

  message(sprintf(".filterTS start: %s -> %s", InputID, OutputID))
  PATH.in  <- here::here("data", "gmsp", InputID)
  PATH.out <- here::here("data", "gmsp", OutputID)

  FILE        <- file.path(PATH.in, sprintf("%s.json", InputID))
  JSON        <- .readJson(FILE)
  Fmax        <- .jsonRequire(JSON, "Fmax", FILE)
  kNyq        <- .jsonRequire(JSON, "kNyq", FILE)
  XI          <- unlist(.jsonRequire(JSON, "XI", FILE))
  TargetUnits <- .jsonRequire(JSON, "TargetUnits", FILE)
  Tn.max      <- .jsonRequire(JSON, "Tn.max", FILE)
  Tn.grid     <- 10^seq(log10(1/Fmax), log10(Tn.max), length.out = 50L)

  TSL.file  <- file.path(PATH.out, "TSL.csv")
  TSW.file  <- file.path(PATH.out, "TSW.csv")
  IMW.file  <- file.path(PATH.out, "IMW.csv")
  IMF.file  <- file.path(PATH.out, "IMF.csv")
  META.file <- file.path(PATH.out, "META.csv")
  PSL.file  <- file.path(PATH.out, "PSL.csv")
  JSON.file <- file.path(PATH.out, sprintf("%s.json", OutputID))

  if (OVERRIDE) .unlinkGeneratedDir(PATH.out, here::here("data", "gmsp"))
  if (!OVERRIDE && file.exists(PSL.file)) {
    message(sprintf(".filterTS: already exists — skipping %s", OutputID))
    return(invisible(NULL))
  }
  dir.create(PATH.out, recursive = TRUE, showWarnings = FALSE)

  message(sprintf(".filterTS read input: %s", InputID))
  TSL  <- fread(file.path(PATH.in, "TSL.csv"))
  META <- fread(file.path(PATH.in, "META.csv"))
  message(sprintf(".filterTS input rows: TSL=%d META=%d records=%d",
                  nrow(TSL), nrow(META), uniqueN(TSL$RecordID)))

  IMF.met <- file.path(PATH.out, "IMF_metrics.csv")
  if (file.exists(IMF.file) && file.exists(IMF.met)) {
    message(".filterTS reuse cached IMF files")
    TSW <- copy(fread(IMF.file))
    Metrics <- fread(IMF.met)
  } else {
    Chunks <- split(TSL[ID == "AT", .(RecordID, OCID, t, s)],
                    by = c("RecordID", "OCID"), keep.by = TRUE)
    message(sprintf(".filterTS IMF decomposition: %d record/components; parallel=%s",
                    length(Chunks), PARALLEL))
    if (PARALLEL) {
      CORES <- parallel::detectCores(logical = TRUE)
      if (is.na(CORES)) CORES <- 1L
      CORES <- max(1L, CORES - 1L)
      message(sprintf(".filterTS workers: %d", CORES))
      cl <- parallel::makePSOCKcluster(CORES)
      doParallel::registerDoParallel(cl)
    } else foreach::registerDoSEQ()
    LIST <- foreach::foreach(
      DT = Chunks,
      .packages = c("data.table","gmsp")) %dopar% {
      OUT <- TS2IMF(.x = DT[, .(t, s)], method = Method, K = K.imf,
                    imf.remove = IMF.remove,
                    remove.Fo = if (Fo.low > 0) c(0, Fo.low) else NULL,
                    keep.Residue = keepResidual)
      OUT$TSW[, `:=`(RecordID = DT$RecordID[1L], OCID = DT$OCID[1L])]
      OUT$IMF[, `:=`(RecordID = DT$RecordID[1L], OCID = DT$OCID[1L])]
      OUT
    }
    if (PARALLEL) parallel::stopCluster(cl)
    TSW <- rbindlist(lapply(LIST, `[[`, "TSW"), use.names=TRUE)
    Metrics <- rbindlist(lapply(LIST, `[[`, "IMF"), use.names=TRUE)
    fwrite(TSW, IMF.file)
    fwrite(Metrics, file.path(PATH.out, "IMF_metrics.csv"))
    TSW <- copy(TSW)
    message(sprintf(".filterTS IMF complete: TSW=%d Metrics=%d",
                    nrow(TSW), nrow(Metrics)))
  }

  message(".filterTS remove selected IMF components")
  COLS <- grep("^IMF[0-9]+$", names(TSW), value=TRUE)
  TSW[, signal.R := {
    x <- COLS[!is.na(unlist(.SD[1L, COLS, with=FALSE]))]
    signal - rowSums(.SD[, .resolveIMF(x, IMF.remove), with=FALSE])
  }, by=.(RecordID, OCID), .SDcols=c("signal", COLS)]

  message(".filterTS rebuild filtered time series")
  COLS <- TSW[, unique(OCID)]
  TSL <- dcast(TSW[, .(RecordID, OCID, t, s=signal.R)],
               RecordID + t ~ OCID, value.var="s")[
    , AT2TS(.SD, units.source = TargetUnits, Fmax = Fmax, kNyq = kNyq,
            units.target = TargetUnits, isRaw = FALSE, output = "TSL"),
    by=.(RecordID), .SDcols=c("t", COLS)]

  TSW2 <- gmsp::TSL2TSW(TSL)
  message(".filterTS compute intensity measures")
  IMW <- gmsp::TSL2IM(.x = TSL, units.source = TargetUnits,
                      units.target = TargetUnits, output = "IMW")

  message(".filterTS compute response spectra")
  PSL <- gmsp::TSL2PS(.x = TSL, xi = XI, Tn = Tn.grid,
                      output = "PSL")
  if (!("xi" %chin% names(PSL))) PSL[, xi := XI[1L]]
  setcolorder(PSL, c("RecordID","OCID","xi","Tn","ID","S"))

  cat("\n── IMF metrics summary ──\n")
  print(Metrics[grepl("^IMF[0-9]+$|^signal\\.R$", IMF),
                .(Fo.med=round(median(`Fo[Hz]`),2), E.mean=round(mean(`E[k]/Eo [%]`),1)),
                by=.(OCID,IMF)][order(OCID,IMF)])

  message(sprintf(".filterTS write output: %s", OutputID))
  fwrite(TSL,  TSL.file); fwrite(TSW2, TSW.file)
  fwrite(IMW,  IMW.file); fwrite(META, META.file); fwrite(PSL, PSL.file)
  write_json(list(InputID=InputID, OutputID=OutputID,
                  Method=Method, Fmax=Fmax, kNyq=kNyq,
                  K.imf=K.imf, IMF.remove=IMF.remove,
                  XI=XI, TargetUnits=TargetUnits,
                  Tn.min=min(Tn.grid), Tn.max=max(Tn.grid),
                  NR=uniqueN(TSL$RecordID),
                  dateUTC=format(Sys.time(), tz="UTC", "%Y-%m-%dT%H:%M:%SZ")),
             JSON.file, auto_unbox=TRUE, pretty=TRUE)
  message(sprintf(".filterTS done -> %s/", OutputID))
}

.suggestFmax <- function(OutputID, energyMin = 1, probs = c(0.50, 0.90, 0.95, 0.99)) {
  PATH.out <- here::here("data", "gmsp", OutputID)
  JSON.file <- file.path(PATH.out, sprintf("%s.json", OutputID))
  Metrics.file <- file.path(PATH.out, "IMF_metrics.csv")
  if (!file.exists(JSON.file) || !file.exists(Metrics.file)) {
    stop(sprintf(".suggestFmax: missing %s json or IMF_metrics.csv.", OutputID),
         call. = FALSE)
  }

  JSON <- .readJson(JSON.file)
  Fmax <- .jsonRequire(JSON, "Fmax", JSON.file)
  K.imf <- as.integer(.jsonRequire(JSON, "K.imf", JSON.file))
  IMF.remove <- as.integer(unlist(.jsonRequire(JSON, "IMF.remove", JSON.file)))
  IDX.remove <- unique(fifelse(IMF.remove < 0L, K.imf + IMF.remove + 1L, IMF.remove))
  IMF.keep <- sprintf("IMF%d", setdiff(seq_len(K.imf), IDX.remove))

  Metrics <- fread(Metrics.file)
  COLS <- c("RecordID", "OCID", "IMF", "Fo[Hz]", "BW[Hz]", "E[k]/Eo [%]")
  if (length(setdiff(COLS, names(Metrics)))) {
    stop(".suggestFmax: IMF_metrics.csv schema is not the expected gmsp schema.",
         call. = FALSE)
  }

  OUT <- Metrics[IMF %chin% IMF.keep & `E[k]/Eo [%]` >= energyMin][
    , F.upper := `Fo[Hz]` + 0.5 * `BW[Hz]`][
    is.finite(F.upper),
    .(Fmax = max(F.upper)), by = .(RecordID, OCID)]
  if (!nrow(OUT)) {
    stop(sprintf(".suggestFmax: no retained IMF has energy >= %.3g%%.", energyMin),
         call. = FALSE)
  }

  SUMMARY <- OUT[, as.list(stats::quantile(Fmax, probs = probs,
                                           names = FALSE, na.rm = TRUE))]
  setnames(SUMMARY, sprintf("p%d", as.integer(probs * 100)))
  SUMMARY[, `:=`(OutputID = OutputID, Fmax.current = Fmax,
                 energyMin = energyMin, N = nrow(OUT))]
  setcolorder(SUMMARY, c("OutputID", "Fmax.current", "energyMin", "N",
                         setdiff(names(SUMMARY),
                                 c("OutputID", "Fmax.current", "energyMin", "N"))))

  message(sprintf(".suggestFmax: %s current Fmax=%g Hz; retained IMF upper-frequency p95=%.2f Hz, p99=%.2f Hz (energy >= %.2f%%)",
                  OutputID, Fmax, SUMMARY$p95, SUMMARY$p99, energyMin))
  invisible(SUMMARY)
}

.scaleAT <- function(InputID,
                     D.grid   = c(150, 200, 250, 300, 350, 400),
                     MIC.grid = c(150, 200, 250, 300, 350, 400),
                     P        = 0.90,
                     D50      = FALSE,
                     D100     = FALSE,
                     nTheta   = 180L,
                     PARALLEL = TRUE,
                     OVERRIDE = FALSE) {

  PATH.in <- here::here("data", "gmsp", InputID)
  FILE        <- file.path(PATH.in, sprintf("%s.json", InputID))
  JSON        <- .readJson(FILE)
  Fmax        <- .jsonRequire(JSON, "Fmax", FILE)
  XI          <- unlist(.jsonRequire(JSON, "XI", FILE))[1L]
  TargetUnits <- .jsonRequire(JSON, "TargetUnits", FILE)
  Tn.max      <- .jsonRequire(JSON, "Tn.max", FILE)
  Tn.grid     <- 10^seq(log10(1/Fmax), log10(Tn.max), length.out = 50L)

  TSL  <- fread(file.path(PATH.in, "TSL.csv"))
  GRID  <- fread(here::here("data", "export", "predictions.csv"))
  # postProcess writes transformed twins when manifest$post$transform is set;
  # scenario scaling must consume the physical-unit rows only. It also carries
  # the train rows (OOF bands) — only the prediction-grid rows are targets.
  if ("Transformed" %in% names(GRID)) GRID <- GRID[Transformed == TRUE]
  M.cfg   <- .readJson(here::here("scripts", "manifest.json"))
  DS.file <- here::here("data", "datasets", sprintf("%s.csv", names(M.cfg$datasets)[1]))
  GRID    <- GRID[SampleID %chin% fread(DS.file)[set == "predict", SampleID]]
  GRID  <- GRID[!is.na(D) & !is.na(MIC) & p == P,
                .(D, MIC, p, ppvL, ppvT, ppvV)]
  # Source-of-truth units propagated by buildDomains from blastDB declarations.
  # The scaling anchor is the VELOCITY family (the well-constrained responses);
  # one scalar factor moves velocity and acceleration together. gmsp .getSF has
  # no velocity mapping, so the bridge is explicit and fail-loud.
  UNITS.file <- here::here("data", "domains", "units.json")
  if (!file.exists(UNITS.file))
    stop(sprintf(".scaleAT: %s missing — run runData.R first so buildDomains writes the units sidecar.", UNITS.file))
  UNITS <- .readJson(UNITS.file)
  PPV.U <- .jsonRequire(UNITS, "ppv", UNITS.file)
  if (!identical(PPV.U, "mm/s") || !identical(TargetUnits, "mm"))
    stop(sprintf(".scaleAT: unsupported ppv unit bridge (%s -> base %s).", PPV.U, TargetUnits))
  G <- 1
  Norm <- TSL[ID == "VT", .(PGV = max(abs(s))), by = .(RecordID, OCID)]

  SCENARIOS <- as.data.table(expand.grid(D = D.grid, MIC = MIC.grid))
  message(sprintf(".scaleAT: %d scenarios (D×MIC=%dx%d) P=%.2f D50=%s InputID=%s",
                  nrow(SCENARIOS), length(D.grid), length(MIC.grid),
                  P, D50, InputID))

  if (PARALLEL) {
    CORES <- parallel::detectCores(logical = TRUE)
    if (is.na(CORES)) CORES <- 1L
    CORES <- max(1L, CORES - 1L)
    cl    <- parallel::makePSOCKcluster(CORES)
    doParallel::registerDoParallel(cl)
  } else {
    foreach::registerDoSEQ()
  }

  foreach::foreach(row = split(SCENARIOS, seq_len(nrow(SCENARIOS))),
                   .packages = c("data.table", "gmsp", "jsonlite", "here"),
                   .export   = c(".interp2D", "G", "D50", "D100", "nTheta",
                                 "OVERRIDE")) %dopar% {

    D   <- row$D
    MIC <- row$MIC
    OutputID <- sprintf("F%d.D%d.Q%d.p%d", Fmax, D, MIC, as.integer(P * 100))
    PATH.out <- here::here("data", "records", "scenarios", OutputID)
    FILES.out <- file.path(PATH.out, c("TSW.csv", "PSW.csv", "IMW.csv", sprintf("%s.json", OutputID)))

    if (!OVERRIDE && all(file.exists(FILES.out))) return(NULL)
    dir.create(PATH.out, recursive = TRUE, showWarnings = FALSE)

    SF.L <- .interp2D(Grid = GRID, D = D, MIC = MIC, COL = "ppvL")
    SF.T <- .interp2D(Grid = GRID, D = D, MIC = MIC, COL = "ppvT")
    SF.V <- .interp2D(Grid = GRID, D = D, MIC = MIC, COL = "ppvV")
    if (any(is.na(c(SF.L, SF.T, SF.V)))) return(NULL)

    AUX <- data.table(OCID = c("L","T","V"), SF = c(SF.L, SF.T, SF.V) * G)
    ESF <- Norm[AUX, on = "OCID"][, .(RecordID, OCID, eff = SF / PGV)]
    DT  <- TSL[ESF, on = .(RecordID, OCID), .(RecordID, OCID, ID, t, s = s * i.eff)]

    Theta <- DT[ID == "AT", {
      AUX <- eigen(cov(as.matrix(
        dcast(.SD[OCID %in% c("L","T")], t ~ OCID, value.var = "s")[, c("L","T")]
      )), symmetric = TRUE)
      .(theta = atan2(AUX$vectors[2L, 1L], AUX$vectors[1L, 1L]))
    }, by = .(RecordID), .SDcols = c("t","OCID","s")]

    UP <- DT[OCID == "V", .(RecordID, ID, OCID = "UP", t, s)]
    DT <- dcast(DT[OCID %in% c("L","T")],
                RecordID + ID + t ~ OCID, value.var = "s")[
      Theta, on = "RecordID",
      c("H1","H2") := list(L * cos(i.theta) + T * sin(i.theta),
                           -L * sin(i.theta) + T * cos(i.theta))]
    OUT <- rbindlist(list(
      melt(DT, id.vars = c("RecordID","ID","t"),
               measure.vars = c("H1","H2"),
               variable.name = "OCID", value.name = "s"),
      UP), use.names = TRUE)

    TSW <- gmsp::TSL2TSW(OUT)
    PSW <- gmsp::TSL2PS(.x = OUT, xi = XI, Tn = Tn.grid, output = "PSW",
                        D50 = D50, D100 = D100, nTheta = nTheta)
    if (!("xi" %chin% names(PSW))) PSW[, xi := XI]
    COLS <- grep("^(PSA|PSV|SD)[.]", names(PSW), value = TRUE)
    COLS <- c(intersect(c("RecordID", "xi", "Tn"), names(PSW)), COLS)
    setcolorder(PSW, c(COLS, setdiff(names(PSW), COLS)))

    IMW <- gmsp::TSL2IM(.x = OUT, units.source = TargetUnits,
                        units.target = TargetUnits, output = "IMW")
    fwrite(TSW,  file.path(PATH.out, "TSW.csv"))
    fwrite(IMW,  file.path(PATH.out, "IMW.csv"))
    fwrite(PSW,  file.path(PATH.out, "PSW.csv"))
    write_json(list(InputID = InputID, OutputID = OutputID,
                    D = D, MIC = MIC, P = P, Fmax = Fmax,
                    SF.L = SF.L, SF.T = SF.T, SF.V = SF.V, xi = XI,
                    D50 = D50, D100 = D100, nTheta = nTheta,
                    TargetUnits = TargetUnits,
                    Tn.min = min(Tn.grid), Tn.max = max(Tn.grid),
                    dateUTC = format(Sys.time(), tz="UTC", "%Y-%m-%dT%H:%M:%SZ")),
               file.path(PATH.out, sprintf("%s.json", OutputID)),
               auto_unbox = TRUE, pretty = TRUE)
    message(sprintf("done -> %s", OutputID))
    NULL
  }

  if (PARALLEL) parallel::stopCluster(cl)

  message(sprintf(".scaleAT done -> %d scenarios", nrow(SCENARIOS)))
}
