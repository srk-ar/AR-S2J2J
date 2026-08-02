# nolint start
if (!exists("Standard.target", inherits = FALSE)) Standard.target <- c("GISTM", "CDA", "ANCOLD")
if (!exists("Stage.target", inherits = FALSE)) Stage.target <- c("Operation", "Closure", "Post-Closure")
if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveDerivedIDTarget(
    DEQTable,
    "criteria summary",
    suffix = ".site",
    siteID = .currentTarget("siteID.target")
  )
}
if (!exists("p.target", inherits = FALSE)) p.target <- "mean"
if (!exists("Tn.target", inherits = FALSE)) Tn.target <- Tn.PGA
if (!exists("PSA_Units", inherits = FALSE)) PSA_Units <- "cm/s2"

DEQ0 <- DEQTable
if ("siteID" %in% names(DEQ0)) {
  if (!exists("siteID.target", inherits = FALSE)) {
    siteID.target <- .resolveSiteIDTarget(DEQ0, "criteria summary")
  }
  if (length(siteID.target) != 1L) stop("criteria summary: set siteID.target to one siteID.")
  DEQ0 <- DEQ0[siteID %in% siteID.target]
}

DEQ <- DEQ0[
  ID == ID.target &
    Standard %in% Standard.target &
    Stage %in% Stage.target &
    Tn == Tn.target &
    .matchP(p, p.target),
  .(Standard, Stage, Class, Vs30, TR, p, SaF)
][order(Standard, Stage, Class, Vs30, TR, p)]

DEQ[, PGA := .convertKmax(SaF, PSA_Units)]

DUP <- DEQ[, .N, by = .(Standard, Stage, Class, Vs30, TR, p)][N != 1L]
if (nrow(DUP)) stop("criteria summary: DEQ is not unique by Standard, Stage, Class, Vs30, TR, p.")
rm(DUP, DEQ0)
# nolint end
