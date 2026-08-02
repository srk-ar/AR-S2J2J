# Material fuente de capítulos — cómo usarlo (2026-07-18)

`_chapters/` fue VACIADO por orden del usuario: el texto se rehace
un párrafo por vez, a veto en chat ANTES de tocar archivo, con
ground explícito por párrafo (código file:line, producto, o cita).

## Generaciones

- `chapters-legacy-20260718/` (hermana): generación 1 — texto
  heredado pre-sesión y EN congelado + fósiles (ensemble/srs/
  disclaimer/format) + semillas (results/summary). PROSA NO
  CONFIABLE (descripción de pipeline, alucinaciones probadas:
  EEMD-drift, config F80 obsoleta, "68 registros"). Sirve como
  evidencia y para rastrear qué afirmaba el texto viejo.
- ESTE folder: generación 2 — los textos mapa-B′ post barridos de
  grounding (blast/records/model/scenarios/risk .es.md). RECHAZADOS
  como conjunto por el usuario (≈120 observaciones de registro/
  jerga/pegote), PERO contienen piezas verificadas reutilizables:

## Piezas VERIFICADAS contra código (reutilizables con veto)

- Ecuaciones EXACTAS: resultantes (buildDomains.R:87-88), vector de
  features 8 términos bases mixtas (QDS.csv/buildDomains.R:137-155),
  pesos 1/RMSE (ssel oofEnsemble.R:87-89), chain condicional
  (ssel README/chainPipeline), cuantiles empíricos (postProcess),
  escalamiento objetivo/PGV (setup.R:362-364), rotación H1/H2
  (setup.R:367-380), AI/CAV/duraciones (gmsp getIntensity.R),
  SDOF (gmsp TSL2PS.R:212-226).
- Rulings incorporados: pf por escenario (no exclusión); PLAXIS/FLAC
  con PM4Sand; binario falla/no-falla; VMD sin retiro de modos;
  hipótesis paso-de-onda e hipótesis proyecto-análogo DECLARADAS sin
  especulación; "conjunto de realizaciones" (no "suite"); títulos
  atestados.
- Bib REAL ya en bib/references.bib: 13 entradas M2P2B (AngTang,
  BenjaminCornell, Langefors, Breiman, Freund, Dietterich, Wolpert,
  Kohavi, Kumar x2, Ghasemi x2, Breiman1996).

## Qué NO reutilizar

- Fraseo instruccional/promocional; conectores que vuelcan config
  (runSelect.json) como prosa; benchmarks sin fuente (R2<0.50);
  cualquier contraste o contexto didáctico del usuario sin cita.

## Proceso vigente

Párrafo propuesto en chat con su ground -> veto del usuario ->
recién entonces entra al archivo -> canario al cierre de capítulo.
Plan maestro: psha:dev/plan/blast-partiv/ (active.md, model.md,
audit-parrafos.md).
