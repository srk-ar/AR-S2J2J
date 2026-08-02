# report-blast-translation-es-20260707

## Section

Spanish translation of the six approved blast-report chapters (`_chapters/*.md (chapter files: intro, signal, amplitude, scenarios, results, summary)` -> `*.es.md`).

## Report Purpose

Bilingual delivery per the repo scaffold (`report.es.qmd`), preserving technical meaning, equations, citations, and product identity.

## Sources Read

Approved English chapter files (project source of truth, migrated 2026-07-07 from the reviewed reading draft). SRK AR domain usage for Spanish geotechnical vocabulary.

## Exact Claims Allowed

Only the claims already present in the approved English chapters. The translation introduces no new claims.

## Claims Not Allowed

Any content not present in the English source.

## Equations Allowed

All equations copied byte-identical from the English chapters; only surrounding prose is translated.

## Equations Excluded

None new.

## Vocabulary Allowed

- tailings storage facility (TSF) -> deposito de relaves (TSF); acronym retained.
- blast-induced dynamic demand -> demanda dinamica inducida por voladuras.
- production blasting -> voladuras de produccion.
- time history -> historia temporal; record -> registro.
- maximum instantaneous charge (MIC) -> carga instantanea maxima (MIC).
- source-to-receiver distance -> distancia fuente-receptor; scaled distance -> distancia escalada.
- PPV/PPA/PGA/PGV/PGD/CAV/CAV5/AI/PSA/PSV/SD/EEMD/EMD/IMF/RMSE/R2/H1/H2/L/T/V: retained as acronyms/symbols.
- ensemble empirical mode decomposition -> descomposicion empirica en modos por ensamble (EEMD).
- intrinsic mode functions -> funciones de modo intrinseco (IMF).
- out-of-fold: retained as English technical label (established ML usage).
- cross-validation -> validacion cruzada; quantile -> cuantil; conditional mean -> media condicional.
- baseline (model) -> linea de base; baseline (signal correction) -> linea de base.
- Arias intensity -> intensidad de Arias; significant duration -> duracion significativa.
- cumulative absolute velocity -> velocidad absoluta acumulada (CAV).
- single-degree-of-freedom oscillator -> oscilador de un grado de libertad; damping ratio -> razon de amortiguamiento.
- median rotated horizontal spectrum -> espectro horizontal rotado mediano.
- principal directions -> direcciones principales; eigenvector -> autovector; covariance matrix -> matriz de covarianza.
- excess pore pressure -> exceso de presion de poros; excess pore-pressure ratio -> razon de exceso de presion de poros.
- cyclic mobility -> movilidad ciclica; liquefaction-type behaviour -> comportamiento tipo licuacion.
- effective-stress plane-strain dynamic deformation analysis -> analisis dinamico de deformaciones en deformacion plana y tensiones efectivas.
- demand descriptors -> descriptores de demanda; waveform -> forma de onda.
- filtering family -> familia de filtrado; bandwidth -> ancho de banda.
- audit (scenario checks) -> auditoria/verificaciones.

## Vocabulary Rejected

- "licuefaccion" (project usage is "licuacion").
- Literal calques: "historia de tiempo", "distancia escalada por raiz" variants, "fuera de pliegue" for out-of-fold.
- Implementation vocabulary (same forbidden list as English public prose).

## Candidate Public Paragraph Or Section

The six `_chapters/*.es.md` files written 2026-07-07.

## Candidate Translation Terminology

Recorded above; accents and enye are used in prose, ASCII in this ledger.

## Open Gaps

- User review of the Spanish chapters, analogous to the English paragraph review.

## Validation

- Equations diffed against English sources (delimiter/LaTeX identity).
- Citations `[-@Key]` preserved.
- `qrt render report.es.qmd --profile book` must pass.
