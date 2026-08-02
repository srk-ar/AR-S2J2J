# nolint start
if (!exists("Tn.target", inherits = FALSE)) Tn.target <- Tn.PGA

RM0 <- RMwTable
if ("siteID" %in% names(RM0)) {
  if (!exists("siteID.target", inherits = FALSE)) {
    siteID.target <- unique(RM0$siteID)
    siteID.target <- siteID.target[!is.na(siteID.target) & nzchar(siteID.target)]
  }
  if (length(siteID.target) != 1L) stop("disagg summary: set siteID.target to one siteID.")
  RM0 <- RM0[siteID %in% siteID.target]
}

# Modal block on the SAME display grid as the heatmaps and the RMw
# table (.rmwStats/.rmwBlocks), so paragraph, table and captions
# cross-check.
RMw <- unique(RM0[, .(Tn, TR)])[
  ,
  {
    AUX <- .rmwStats(tn = Tn, tr = TR)
    .(Mw = round(AUX$MwMode, 1), R = round(AUX$RMode, 0))
  },
  by = .(Tn, TR)
][order(Tn, TR)]

RMw.PGA <- RMw[Tn == Tn.target]

DUP <- RMw[, .N, by = .(Tn, TR)][N != 1L]
if (nrow(DUP)) stop("disagg summary: RMw is not unique by Tn, TR.")
DUP <- RMw.PGA[, .N, by = TR][N != 1L]
if (nrow(DUP)) stop("disagg summary: RMw.PGA is not unique by TR.")
rm(DUP, RM0)
# nolint end
