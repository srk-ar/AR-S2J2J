# HANDOFF Blast E108 — arquitectura narrativa y notación

## Purpose

Recuperar sin chat la auditoría read-only del reporte Blast si el contexto se
compacta. El único frente activo es AR-S2J2J.X. PSHA y SSEL no se editan.

## Mandatory Startup Order

1. `/Users/averrik/Cloud/github/projects/AR-S2J2J.X/dev/SoT/ACTIVE.md`
2. `/Users/averrik/Cloud/github/projects/AR-S2J2J.X/dev/plan/blast-report/active.md`
   - leer el cierre E104–E107;
   - leer E108 completo y el último `Live Runs`/`Exact Next Command`.
3. Este handoff.
4. `/Users/averrik/github/garage/harness/HARNESS.md`
5. `/Users/averrik/github/garage/harness/RESEARCH-LEDGER-HARNESS.md`
6. `/Users/averrik/github/garage/style/technical-writing.md`
7. Antes de cualquier R: `/Users/averrik/github/garage/style/AGENTS.md`,
   `/Users/averrik/github/garage/style/R.md`,
   `/Users/averrik/github/garage/style/R-data.table.md` y
   `/Users/averrik/github/garage/style/PRACTICE.md`.

No reconstruir estado desde el chat ni desde handoffs sueltos. Si `active.md`
no coincide con el filesystem, reparar primero `active.md`.

## Last Reliable State

- E106 cerrado: el prototipo PSA F125 fue retirado del capítulo Escenarios.
- E107 cerrado: “Superficies PPV/PPA” se corrigió a “Predicciones de PPV/PPA”;
  p90/p95 conservan valores y pasaron de ancho 0.75 a 1.5.
- Último book fresco: `html/report.es/index.html`, 2026-07-19 01:53:12 -0300.
- Model fresco: `html/report.es/_index/model.ES.html`, 01:53:13.
- Scenarios fresco: `html/report.es/_index/scenarios.ES.html`, 01:53:13, sin
  widgets PSA E92.
- No hay renders, pipelines, servidores locales ni agentes en ejecución.
- El scaffold PSHA no fue modificado por E106/E107.

## Current Task E108

Auditoría solamente. No editar capítulos públicos ni renderizar hasta presentar
al usuario:

1. propuesta de títulos sin cambiar contenidos ni organización;
2. auditoría del resumen de Records contra el cuerpo y el código;
3. matriz de notación actual → propuesta, con clasificación semántica y prueba
   de invariancia matemática;
4. procedencia de las ecuaciones actuales.

## User Rulings To Preserve

- Todo el estudio es un modelo integrado: procesamiento instrumental,
  predicción ML de PPV/PPA, generación de escenarios y futura probabilidad de
  excedencia/falla a partir del modelo dinámico. El capítulo ML no debe apropiarse
  del nombre “el modelo”.
- Los títulos deben ser comprensibles para blasting y ML.
- “Antecedentes” y sus objetivos son pobres; “Organización” sólo puede justificar
  brevemente la secuencia de lectura.
- “Base de registros de vibración” es un título inadecuado.
- CAV, CAV5, intensidad de Arias y duraciones son métricas calculadas. No afirmar
  que alimentan ML, selección o spectral matching sin evidencia.
- Existen 86 historias tridimensionales de velocidad. D y Q son metadatos
  reportados por el contratista y su disponibilidad es un contrato distinto;
  no confundir instrumentación con observaciones etiquetadas.
- L/T/V son direcciones instrumentales. H1/H2/UP son direcciones de análisis
  posteriores y deben definirse al primer uso.
- “Normalizar” y “escalar” no son sinónimos automáticos. Identificar el factor y
  la operación exacta antes de reescribir.
- Mayúsculas: variables aleatorias, definidas mediante su distribución.
  Minúsculas indexadas: observaciones/realizaciones. Distinguir error aleatorio,
  residuo observado, estimador y predicción OOF.
- Ejemplo del usuario: la transformación observada se expresa como
  `z_j = log10(y_j)`; una ley condicionada se formula con variables aleatorias,
  no mezclando `Z_j` con una observación ni llamando residuo a `epsilon`.

## Blast Sources To Read

- Arquitectura: `_index/blast.ES.qmd`, `_index/records.ES.qmd`,
  `_index/model.ES.qmd`, `_index/scenarios.ES.qmd`, `_index/risk.ES.qmd`.
- Introducción y resúmenes: `_chapters/blast.es.md`,
  `_chapters/records.summary.es.md`, `_chapters/model.summary.es.md`,
  `_chapters/scenarios.summary.es.md`, `_chapters/risk.summary.es.md`.
- Cuerpos: `_chapters/records.es.md`, `_chapters/model.es.md`,
  `_chapters/scenarios.es.md`, `_chapters/risk.es.md`.
- Resultados parametrizados: `_summary/records.results.es.qmd`,
  `_summary/model.results.es.qmd`, `_summary/scenarios.results.es.qmd`.
- Algoritmo consumido por el reporte: `scripts/manifest.json`,
  `scripts/runModel.R`, `scripts/runChain.R`, `scripts/runPost.R`.
- Fuentes históricas sólo para comparación dirigida:
  `dev/SoT/chapters-mapb-20260718/` y
  `dev/SoT/chapters-legacy-20260718/`. No promoverlas por antigüedad.

## SSEL Authority To Read

- `README.md`.
- `vignettes/ensemble-theory.Rmd`.
- `vignettes/chain-regression.Rmd`.
- `vignettes/ssel-quickstart.Rmd`.
- `R/trainModel.R`, `R/trainRegressionModel.R`, `R/oofEnsemble.R`,
  `R/chain.R`, `R/aggregateResponses.R`, `R/postProcess.R`, `R/model.R`.
- `man/trainModel.Rd`, `man/oofEnsemble.Rd`, `man/chainPipeline.Rd`,
  `man/aggregateResponses.Rd`, `man/postProcess.Rd`.

SSEL es autoridad read-only. No modificar, instalar, probar ni rediseñar.

## Brazil Precedent To Read

Repositorio verificado:
`/Users/averrik/Cloud/github/projects/AR-M2P2B.R`.

- `report.qmd`.
- `qmd/report/_background.qmd` y `_introduction.qmd` para encuadre profesional.
- `qmd/report/_model.qmd` y `_results_model.qmd` para notación ML.
- `qmd/report/_demand.qmd` y `_results_demand.qmd` para demanda probabilística.
- `qmd/report/_capacity.qmd` y `_results_capacity.qmd` para variables aleatorias,
  distribuciones y confiabilidad.
- `qmd/report/_design.qmd`, `_summary.qmd`, `_limitations.qmd` para vínculo entre
  modelo, resultados y decisiones.
- Código sólo si una expresión pública requiere trazabilidad: `R/train.R`,
  `R/trainRegressionModel.R`, `R/predict.R`, `R/run.R`.

## Required Notation Matrix Columns

`Equation/line | current symbol | current role | proposed symbol | proposed role |
distribution/definition | invariant mathematical operation | affected prose/files |
open question`.

Clasificar cada objeto como: variable aleatoria, realización, covariable
observada, estimador, predicción ajustada, predicción OOF, residuo observado,
error aleatorio o parámetro distributivo.

## Prohibitions

- No parchar ecuaciones una por una.
- No cambiar notación sin revisar todas sus apariciones y ecuaciones dependientes.
- No introducir normalidad, media cero o un parámetro sigma si SSEL y el modelo
  ejecutado no sustentan exactamente ese contrato; registrar la discrepancia.
- No llamar “modelo dinámico” al modelo ML ni confundirlo con PLAXIS/FLAC.
- No afirmar consumidores de métricas por plausibilidad.
- No editar PSHA, SSEL, datos, manifests o pipelines.
- No renderizar durante la fase de auditoría.

## Exact Resume Action

Leer primero las fuentes Blast completas y construir inventarios de títulos,
afirmaciones problemáticas y símbolos. En paralelo, extraer sólo la notación
autoritaria de SSEL y Brasil. Registrar los veredictos en
`dev/plan/blast-report/active.md`; presentar títulos y matriz al usuario antes de
cualquier cambio público.

## Post-Handoff Corrections And Evidence (2026-07-19)

- Ruling posterior del usuario: Brasil es obsoleto y matemáticamente ambiguo.
  No es autoridad notacional. Leerlo sólo como contraste histórico/editorial;
  la autoridad matemática exclusiva es SSEL más el pipeline y los artefactos
  Blast ejecutados. No copiar normalidad, sigma, media/mediana ni ecuaciones de
  Brasil.
- Records no materializa una base normalizada: `runGMSP.R` conserva amplitudes
  físicas y `.scaleAT()` aplica directamente `lambda=PPV*/PGV`. La forma
  unitaria es una descomposición algebraica, no un producto persistido.
- Gate SSEL abierto y demostrado sobre CSV: en `summary_0` a `summary_3`, las
  predicciones de malla `ensemble.RMSE` de todas las respuestas se reconstruyen
  exactamente con los pesos de `ppvV`, no con sus pesos por respuesta. La
  lectura preliminar apunta a reutilización del último vector `RMSE` en la fase
  de predicción de `trainRegressionModel.R`. No parchar ni rerun aquí; cerrar
  alcance y reportar.
- Las covariables de cadena de entrenamiento implementadas son
  `y_hat_oof+q_50`, es decir p50 OOF empírico; no el point OOF sin ajuste. La
  malla también usa p50 anterior.
- Nueva auditoría read-only `canonical_peak_table_scaling_audit`: traza la tabla
  2.1 «Amplitudes pico», sus artefactos canónicos y por qué no muestra valores
  unitarios. Cero edición, render o R.
- Auditoría posterior `spectral_processing_control_audit`: el plot actual
  compara `F125.Qo.Do` (producto base que ya deriva AT/DT desde VT) con
  `F125.Qo.Do.vmd` (efecto incremental VMD/IMF1). No representa raw de geófono
  versus producto final. Determinar si debe renombrarse o retirarse; prohibido
  crear un pipeline o artefacto nuevo para salvarlo.
- El estado live y los comandos verdaderos siguen en
  `dev/plan/blast-report/active.md`, sección E108 posterior a este handoff.

## E109–E110 Live Update (2026-07-19)

Cambios públicos aplicados, todavía sin render:

- se retiró del ensamblado público de Records la comparación
  `F125.Qo.Do` versus `F125.Qo.Do.vmd`; los builders se conservaron intactos;
- se corrigió la notación del modelo: h identifica el tipo de respuesta y j la
  observación; las variables aleatorias son `Y^(h)` y `Z^(h)` y las
  realizaciones `y_j^(h)` y `z_j^(h)`;
- la Tabla 2.1 ahora distingue PPA/PPV físicas de la biblioteca fuente y añade
  `PGA/PGV [s^-1]`, calculado registro por registro antes de obtener
  p16/p50/p84;
- se corrigió el primer párrafo parametrizado de Records para separar 86
  ternas instrumentales, 258 historias por componente y 68 registros con
  metadatos D/Q.

Pendiente dentro de E109: explicación detallada de la descomposición
algebraica frente al escalamiento directo; títulos auditados pero aún no
aplicados; no render.

E110 reemplaza cualquier intención de parchear Scenarios. El usuario rechazó
el capítulo por arquitectura, resumen no ejecutivo, definiciones ausentes,
ecuaciones duplicadas/mal numeradas y registro contaminado por auditoría de
pipeline. Tres auditorías read-only están activas y deben entregar antes de
tocar Scenarios: arquitectura por objetivos con al menos 40 hallazgos, ledger
matemático y sweep de registro profesional. No hay R, render, pipeline ni
tmux activo.
