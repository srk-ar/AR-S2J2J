# nolint start
# cleanDB.R — remove non-physical PPA readings from the local blastDB.
#
# Rules (user-approved 2026-07-09):
#   LTV: exact ppaL == ppaT == ppaV (three orthogonal components identical are
#        not measurements) -> the three ppa components are set to NA.
#   REP: per (Source, ppa component), an exact value repeated across >= REP.MIN.D
#        distinct distances (no attenuation) -> that component is set to NA.
# PPV columns are never touched. Rows are never deleted.
#
# The local data/blastDB.csv is the persistent master for external sources
# (exportDB.R only regenerates IMPALA rows), so this cleaning is durable.
#
# Usage:
#   Rscript scripts/parse/cleanDB.R           # dry-run: audit only
#   Rscript scripts/parse/cleanDB.R --apply   # backup + write cleaned DB

library(data.table)
library(jsonlite)

REP.MIN.D <- 10L
COLS <- c("ppaL", "ppaT", "ppaV")

APPLY <- "--apply" %in% commandArgs(trailingOnly = TRUE)
M  <- fromJSON(here::here("scripts", "manifest.json"), simplifyVector = TRUE, simplifyDataFrame = FALSE)
FILE <- here::here(M$parse$blastDB$path)
DB <- fread(FILE)

DB[, rule.LTV := !is.na(ppaL) & !is.na(ppaT) & !is.na(ppaV) & ppaL == ppaT & ppaL == ppaV]
for (.col in COLS) {
  AUX <- DB[!is.na(get(.col)), .(nD = uniqueN(D)), by = .(Source, value = get(.col))][nD >= REP.MIN.D]
  DB[, (paste0("rule.REP.", .col)) := AUX[DB, on = c("Source", value = .col), !is.na(x.nD)]]
}

LIST <- lapply(COLS, function(.col) {
  DB[rule.LTV | get(paste0("rule.REP.", .col)),
     .(filas = .N, LTV = sum(rule.LTV), REP = sum(get(paste0("rule.REP.", .col)))),
     by = .(Source, value = get(.col))][, component := .col]
})
AUDIT <- rbindlist(LIST, use.names = TRUE)[order(Source, component, -filas)]
setcolorder(AUDIT, c("Source", "component", "value", "filas", "LTV", "REP"))
fwrite(AUDIT, here::here("dev", "research", "blast-report", "AUDIT-blastdb-clean-20260709.csv"))

cat("== Resumen por fuente y regla ==\n")
print(DB[, .(filas = .N, LTV = sum(rule.LTV),
             REP.alguna = sum(rule.REP.ppaL | rule.REP.ppaT | rule.REP.ppaV),
             ppa.afectada = sum(rule.LTV | rule.REP.ppaL | rule.REP.ppaT | rule.REP.ppaV)),
         by = Source])
cat(sprintf("\naudit por valor: %d entradas -> dev/research/blast-report/AUDIT-blastdb-clean-20260709.csv\n", nrow(AUDIT)))

if (APPLY) {
  BACKUP <- sub("[.]csv$", ".raw.csv", FILE)
  if (!file.exists(BACKUP)) fwrite(fread(FILE), BACKUP)
  for (.col in COLS) DB[rule.LTV | get(paste0("rule.REP.", .col)), (.col) := NA_real_]
  OUT <- DB[, .SD, .SDcols = !grepl("^rule[.]", names(DB))]
  fwrite(OUT, FILE)
  cat(sprintf("APLICADO: %s reescrito (backup en %s)\n", FILE, BACKUP))
} else {
  cat("DRY-RUN: no se escribio nada. Ejecutar con --apply para aplicar.\n")
}
# nolint end
