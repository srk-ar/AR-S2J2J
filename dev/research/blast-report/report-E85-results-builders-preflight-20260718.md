# report-E85-results-builders-preflight-20260718

## Section

Blast report / E85 -- preparación de builders de resultados para `model` y
`scenarios`.

## Report Purpose

Corregir los prototipos existentes para que el reporte pueda hidratarse desde
la próxima corrida aceptada sin trasladar cifras, poblaciones o captions
heredados. Los builders conservan la arquitectura PSHA
`scripts/fig|tbl -> _fig|tbl -> _summary -> _index`; la conexión al book y el
render quedan bloqueados por la vigencia de los productos.

## Evidence

- `data/summary`, `data/export` y `data/iter`: 2026-07-10.
- `data/audit/summary.csv`: 2026-06-26, 36 escenarios y 6 FAIL.
- `data/records/scenarios`: cuatro carpetas completas y una vacía, población
  distinta de la auditoría.
- Cero productos VMD aceptados y cero corrida fresca del modelo observada.

## Builder Corrections

- `scripts/tbl/performance.R`: reportar por respuesta la iteración seleccionada
  por máximo $R^2$ OOF, $N_{j,t}$, RMSE en `log10`, RMSE en unidades físicas y
  unidades; verificar que el `summary` esté cosido con la misma selección.
- `scripts/tbl/comparison.R`: comparar $t=0$ y $t_j^*$ junto con ambos soportes;
  retirar reducciones porcentuales cuando las cohortes difieren.
- `scripts/tbl/bands.R`: conservar $n$, cuantiles residuales y factores
  multiplicativos.
- `scripts/tbl/overfit.R`: reportar métricas cuantitativas y retirar el `flag`
  editorial automatizado.
- `scripts/fig/oof.R`, `residscatter.R` y `residuals.R`: usar la población OOF
  cosida y distinguir procedencia cuando esté disponible; retirar captions con
  cardinalidades fijas.
- `scripts/fig/demand.PPV.R`: representar $p50$, $p90$ y $p95$ reales, con las
  observaciones que efectivamente participaron en el ajuste; retirar la frase
  falsa «S11D es sólo contexto».
- Wrappers `.ES`: español profesional, respuestas derivadas del manifest y
  cero afirmaciones de mejora antes de leer los resultados.
- `scripts/tbl/scenarios.R` y `audit.R`: PPV objetivo L/T/V y verificaciones del
  mismo inventario; cero PPA presentada como objetivo de escalamiento.

## Public Integration Gate

Los partials de resultados pueden escribirse y permanecer desconectados. Sólo
se incorporan a `_index/model.ES.qmd` y `_index/scenarios.ES.qmd` cuando una
corrida fresca entregue un `summary/export/iter` coherente y una única familia
de escenarios cuya auditoría coincida uno a uno con sus carpetas.

## Validation

- `git diff --check`.
- Búsqueda de captions retirados: `accepted model`, `dataset I`, `S11D is
  context only`, `reduction[%]`, `flag` y PPA como objetivo de escenario.
- Smoke de builders y render sólo bajo experimento registrado; cualquier uso de
  los productos del 10-Jul/26-Jun será diagnóstico y no publicable.

