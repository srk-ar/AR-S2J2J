# nolint start
if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveDerivedIDTarget(
    kmaxTable,
    "slope summary",
    suffix = ".max",
    siteID = .currentTarget("siteID.target")
  )
}
if (!exists("IDn.target", inherits = FALSE)) IDn.target <- "ensemble"
if (!exists("IDg.target", inherits = FALSE)) IDg.target <- unique(ShearTable$IDg)
if (!exists("level.target", inherits = FALSE)) level.target <- "mean"
if (!exists("TR.target", inherits = FALSE)) TR.target <- TR.gmdp
if (!exists("Da.target", inherits = FALSE)) Da.target <- Da.gmdp
if (!exists("p.target", inherits = FALSE)) p.target <- c("mean", "0.84")
if (!exists("PSA_Units", inherits = FALSE)) PSA_Units <- "cm/s2"

UHS <- UHSTable
KMAX <- kmaxTable
if ("siteID" %in% union(names(UHS), names(KMAX))) {
  if (!exists("siteID.target", inherits = FALSE)) {
    siteID.target <- .resolveSiteIDTarget(
      rbindlist(list(
        if ("siteID" %in% names(UHS)) UHS[, .(siteID)] else data.table(siteID = character()),
        if ("siteID" %in% names(KMAX)) KMAX[, .(siteID)] else data.table(siteID = character())
      )),
      "slope summary"
    )
  }
  if (length(siteID.target) != 1L) stop("slope summary: set siteID.target to one siteID.")
  if ("siteID" %in% names(UHS)) UHS <- UHS[siteID %in% siteID.target]
  if ("siteID" %in% names(KMAX)) KMAX <- KMAX[siteID %in% siteID.target]
}

Ts <- .slopePeriods(
  ShearTable,
  idg = IDg.target,
  level = level.target,
  context = "slope summary"
)

BASE.ID <- sub("\\.max$", "", ID.target)
Sa <- rbindlist(lapply(seq_len(nrow(Ts)), function(i) {
  if (uniqueN(Vref.gmdp) != 1L) stop("slope summary: Vref.gmdp must be unique for reference-rock Sa.")
  AUX <- unique(UHS[
    ID == BASE.ID & p == "mean" &
      Vref == unique(Vref.gmdp) & Vs30 == unique(Vref.gmdp),
    .(TR, Tn, Sa)
  ])
  data.table(
    IDg = Ts$IDg[i],
    level = Ts$level[i],
    TR = TR.target,
    Tn = Ts$Ts.med[i],
    Sa = sapply(TR.target, function(x) {
      approx(x = AUX[TR == x]$Tn, y = AUX[TR == x]$Sa, xout = Ts$Ts.med[i], rule = 2)$y
    })
  )
}))

if ("IDn" %in% names(KMAX)) {
  if (length(IDn.target) != 1L) stop("slope summary: IDn.target must select one IDn scenario.")
  KMAX <- KMAX[IDn %in% IDn.target]
  if (!nrow(KMAX)) stop(sprintf("slope summary: no kmax rows for IDn.target = %s.", IDn.target))
}

kmax <- KMAX[
  ID == ID.target &
    IDg %in% IDg.target &
    Da %in% Da.target &
    TR %in% TR.target &
    .matchP(p, p.target),
  .(IDg, Da, TR, p, kmax = .convertKmax(kmax, PSA_Units))
][order(IDg, Da, TR, p)]

Kh <- KMAX[
  ID == ID.target &
    IDg %in% IDg.target &
    Da %in% Da.target &
    TR %in% TR.target &
    .matchP(p, p.target),
  .(IDg, Da, TR, p, Kh = round(Kh, 0))
][order(IDg, Da, TR, p)]

# Incidence of log-log extrapolation in the exact component curves used by
# the reported ensemble inversion. DnDraws is the producer artifact consumed
# by runKmax.R; counting outside-support targets here avoids inferring the
# incidence from already aggregated kmax rows.
if (isTRUE(.currentTarget("Kmax.extrap.required"))) {
DRAW.DIR <- file.path(root, "oq", "uhs", BASE.ID)
PARAMS <- .currentTarget("params")
CONFIG <- NULL
if (is.list(PARAMS) && is.list(PARAMS$report)) {
  CONFIG <- PARAMS$report$sites
}
DRAW.SITE <- .resolveSiteIDStorage(
  .currentTarget("siteID.target"),
  config = CONFIG,
  context = "slope summary"
)
DRAW.FILES <- if (dir.exists(DRAW.DIR)) {
  list.files(
    DRAW.DIR,
    pattern = "^DnDraws\\.csv$",
    recursive = TRUE,
    full.names = TRUE
  )
} else {
  character()
}
DRAW.FILES <- DRAW.FILES[basename(dirname(DRAW.FILES)) %in% DRAW.SITE]
if (length(DRAW.FILES) != 1L) {
  stop(sprintf(
    "slope summary: expected one DnDraws.csv for %s and the selected site; found %s.",
    BASE.ID,
    length(DRAW.FILES)
  ))
}
DRAW <- data.table::fread(DRAW.FILES, showProgress = FALSE)
DRAW.REQUIRED <- c("TR", "IDg", "ky", "s", "Dn", "IDn")
if (!all(DRAW.REQUIRED %in% names(DRAW))) {
  stop(sprintf(
    "slope summary: DnDraws.csv is missing %s.",
    paste(setdiff(DRAW.REQUIRED, names(DRAW)), collapse = ", ")
  ))
}
if ("siteID" %in% names(DRAW)) {
  DRAW.ID <- .cleanTarget(DRAW$siteID)
  if (length(DRAW.ID) != 1L || !identical(DRAW.ID, DRAW.SITE)) {
    stop("slope summary: DnDraws.csv siteID does not match siteID.storage.")
  }
}
if (!exists("subduction", inherits = TRUE) ||
    !is.logical(subduction) || length(subduction) != 1L || is.na(subduction)) {
  stop("slope summary: subduction must be one non-missing logical value.")
}
BM.ACTIVE <- if (isTRUE(subduction)) "BM17" else "BM19"
ENSEMBLE.MODELS <- c("AM88", "SR08", "BT07", BM.ACTIVE)
SUPPORT <- DRAW[
  TR %in% TR.target & IDg %in% IDg.target & IDn %in% ENSEMBLE.MODELS
][
  order(ky),
  {
    OK <- is.finite(ky) & is.finite(Dn) & ky > 0 & Dn > 0
    if (sum(OK) < 2L) {
      stop("slope summary: incomplete component curve in DnDraws.csv.")
    }
    Y <- rev(cummax(rev(Dn[OK])))
    .(Dn.min = min(Y), Dn.max = max(Y))
  },
  by = .(TR, IDg, s, IDn)
]
if (!nrow(SUPPORT)) stop("slope summary: no component curves for the selected result slice.")
Kmax.extrap <- rbindlist(lapply(Da.target, function(Da.i) {
  SUPPORT[, .(
    Da = Da.i,
    extrapolated = sum(Da.i < Dn.min | Da.i > Dn.max),
    curves = .N
  )]
}))
Kmax.extrap[, percent := 100 * extrapolated / curves]
Kmax.extrapText <- paste(
  Kmax.extrap[, sprintf(
    "$D_a=%s$ cm: %s de %s curvas de componente (%s%%)",
    format(Da, trim = TRUE, scientific = FALSE),
    .fmti(extrapolated),
    .fmti(curves),
    ifelse(percent > 0 & percent < 0.1, "<0.1", .fmt(percent, 1))
  )],
  collapse = "; "
)
}

DUP <- Ts[, .N, by = .(IDg, level)][N != 1L]
if (nrow(DUP)) stop("slope summary: Ts is not unique by IDg, level.")
DUP <- Sa[, .N, by = .(IDg, level, TR)][N != 1L]
if (nrow(DUP)) stop("slope summary: Sa is not unique by IDg, level, TR.")
DUP <- kmax[, .N, by = .(IDg, Da, TR, p)][N != 1L]
if (nrow(DUP)) stop("slope summary: kmax is not unique by IDg, Da, TR, p.")
DUP <- Kh[, .N, by = .(IDg, Da, TR, p)][N != 1L]
if (nrow(DUP)) stop("slope summary: Kh is not unique by IDg, Da, TR, p.")
rm(list = intersect(c(
  "DUP", "UHS", "KMAX", "BASE.ID", "DRAW.DIR", "DRAW.FILES", "DRAW",
  "DRAW.SITE", "DRAW.ID", "DRAW.REQUIRED", "BM.ACTIVE", "ENSEMBLE.MODELS",
  "SUPPORT", "PARAMS", "CONFIG"
), ls()))
# nolint end
