# report-E84-model-scenarios-results-readiness-20260718

## Objective

Establecer la preparación real de los resultados de `model` y `scenarios` para la entrega ES, sin ejecutar modelos, SSEL, procesamiento de datos, escenarios ni render, y sin editar prosa pública.

## Sources Read

- `dev/plan/blast-report/active.md`: E72, E79, E80 y E82.
- `garage/harness/HARNESS.md`, `garage/style/summary.md`, `garage/style/technical-writing.md` y `garage/style/AGENTS.md`.
- Scaffold PSHA: `scaffold/scripts/fig/GMPE.PSA.R`, `scaffold/scripts/tbl/DSHA.R` y sus wrappers QMD/ES.
- Blast: builders bajo `scripts/fig`, `scripts/tbl`; wrappers bajo `_fig`, `_tbl`; índices `model.ES.qmd` y `scenarios.ES.qmd`.
- Metadatos y schemas acotados de `data/summary`, `data/export`, `data/iter`, `data/gmsp`, `data/records/scenarios` y `data/audit`.

## Freshness Verdict

No apareció una corrida fresca ni existe un proceso activo de VMD, modelo o escenarios.

| Rama | Producto más reciente inspeccionado | Estado |
|---|---|---|
| VMD | No existe un hijo `data/gmsp/*.vmd`; `F125.Qo.Do.json` y `F125.Qo.Do.eemd.json` tienen mtime 2026-05-29 y `dateUTC` 2026-05-24/22 | No existe producto VMD materializado. El único derivado declara `Method: eemd` e `IMF.remove: [1,-1,-2]`. |
| Modelo | `data/summary/*` 2026-07-10 15:42:31; `data/export/*` 2026-07-10 15:42:30--32; `data/iter/*` 2026-07-10 15:41:47--15:42:31 | Producto heredado, no corrida fresca aceptada. |
| Escenarios | `data/records/scenarios` 2026-07-10 12:17:50 | Corrida parcial heredada: cuatro carpetas completas y una quinta vacía. Todas las completas consumen `F125.Qo.Do.eemd`. |
| Auditoría | `data/audit/summary.csv` 2026-06-26 10:47:44 | Instantánea distinta: 36 escenarios, 30 PASS y 6 FAIL. No corresponde a las cuatro carpetas actuales. |

`Live Runs` está vacío y una inspección de procesos no encontró `runGMSP`, `runModel`, `runChain`, `runScenarios` ni VMD activos.

## Current Product Contracts

### Model

- `metrics.csv`: 56 filas; `method,set,dataset,response,rmse,mae,r2,n,p`; ocho respuestas y siete métodos, incluido `gamSpline`.
- `residuals_oof.csv`: 848 filas; `response,dataset,rowIndex,SampleID,y_obs,y_hat_oof,residual`; 106 filas por respuesta.
- `prediction_quantiles.csv`: ocho filas; `response,dataset,n,q_50,q_90,q_95`; `n=106` por respuesta.
- `Yo.csv`: 12,408 filas; `SampleID,response,p,value,r2,dataset`; niveles 0.50, 0.90 y 0.95.
- `predictions.csv`: 3,738 filas; grilla D--Q, los tres niveles y versiones `Transformed=FALSE/TRUE`.
- La cohorte seleccionada contiene 68 IMPALA y 38 S11D por respuesta. Los builders OOF vigentes filtran IMPALA y omiten 38 observaciones S11D por respuesta.
- El producto final selecciona distintas iteraciones por respuesta, pero ningún archivo público materializa `t_j^*`; sólo puede inferirse comparando `metrics_0`--`metrics_3`.
- La iteración 0 no comparte soporte con la cohorte final: PPV parte de 1,448 filas y varias PPA de 147--156, mientras la cohorte condicional final usa 106. La comparación directa de métricas no es válida.
- `overfit.csv` contiene sólo `earth`, `gbm`, `ranger` y `glm`; falta `gamSpline`, aunque sí aparece en `metrics.csv`.

### Scenarios

- El sidecar actual expone `InputID,OutputID,D,MIC,P,Fmax,SF.L,SF.T,SF.V,xi,D50,D100,nTheta,TargetUnits,Tn.min,Tn.max,dateUTC`.
- Cada carpeta completa contiene `IMW.csv`, `PSW.csv` y `TSW.csv`; `PSW.csv` sí aporta PSA/PSV/SD en H1/H2/UP/D50 y `xi=0.05`.
- La configuración `runScenarios.json` pide 9 distancias por 6 cargas (54 condiciones), pero sólo existen cuatro condiciones completas, todas con `Q=150`, y una quinta vacía.
- `data/audit/summary.csv` enumera una grilla 6x6 distinta. Sus seis fallas corresponden a `energy.ok=FALSE`. Sus factores de escala tampoco coinciden con los sidecars del 10 de julio.
- `data/records/plaxis` no existe; por ello los builders de selección y cobertura no tienen producto fuente.

## Official Builder Contract

El patrón PSHA reutilizable es: builder R con targets explícitos, validación fail-loud, limpieza y objeto terminal `PLOT`/`TBL`; wrapper neutral que fija targets y caption; adaptador `.ES.qmd` que sólo inyecta lenguaje. Un wrapper no decide qué corrida es aceptada ni reconstruye una selección desde mínimos locales.

## Builder Map

### Model

| Builder / wrapper | Clasificación | Corrección mínima antes de conectar |
|---|---|---|
| `oof.R` + `predictions*.qmd` | Reutilizable después del gate de vigencia | Parametrizar población y dataset; exigir cohorte e iteración seleccionadas; caption con fuente, `n`, unidades y dominio OOF. No fijar `Source == IMPALA`. |
| `residscatter.R`, `residuals.R` + `residuals*.qmd` | Reutilizable después del gate | Mismos targets de población/cohorte/iteración; usar el residuo materializado; fail-loud ante celdas vacías; no atribuir ausencia de tendencia sin lectura del resultado. |
| `performance.R` + pestaña `metrics` | Reutilizable con corrección | Recibir una fila seleccionada única por respuesta, no elegirla con `which.min`; incorporar `t_j^*`, soporte por población, RMSE log10 y RMSE física sobre las mismas filas, además de $R^2$ OOF. |
| `comparison.R` | Bloqueado por cohorte | Intersectar `SampleID` por respuesta entre iteración 0 y retenida, recalcular ambas métricas sobre esa intersección y publicar `n_common`. No comparar los agregados actuales. |
| `overfit.R` | No conectar esta noche | Retirar `flag`, exigir concordancia de familias con `metrics.csv` e incluir `gamSpline`; leer `k_folds` del producto. |
| `bands.R` | Reutilizable con corrección | Declarar cohorte e iteración. Si el factor se reporta respecto de p50 debe ser $10^{q_p-q_{50}}$; $10^{q_p}$ sólo puede rotularse respecto de la predicción central antes del desplazamiento mediano. |
| `demand.PPV.R` + `demand.PPV*.qmd` | Reutilizable con corrección | Parametrizar `Q.target`, rango D, niveles `p.target` y poblaciones; mostrar los mismos p50/p90/p95 que promete el caption; obtener puntos S11D de las filas realmente admitidas al ajuste, no del corte fijo `SD<=105`. |
| `demand.R` + `demand.PPA.qmd` | Reutilizable con corrección, prioridad secundaria | Parametrizar Q/D/p y agregar adaptador ES; conservar PPA como resultado complementario, no como escala de escenarios. |
| `conditional.R` + `conditional.PPV*.qmd` | Rechazado | E72 excluyó la figura bootstrap de la arquitectura oficial. |
| `quantiles.R` + `conditional.PPV*.qmd` | Reutilizable sólo si se limita | Parametrizar exactamente la familia D--Q--p aprobada; el barrido rígido 9x4 produciría un apéndice masivo y no una síntesis de resultados. |

### Scenarios

| Builder / wrapper | Clasificación | Corrección mínima antes de conectar |
|---|---|---|
| `audit.R` + `_tbl/audit.qmd` | Reutilizable sólo con auditoría fresca coherente | Agregar adaptador ES; filtrar por `InputID`, Fmax, p y familia aceptada; caption con número de realizaciones y tolerancia leída del contrato. No llamar aceptada a una familia con FAIL. |
| `scenarios.R` | Corregible; hoy huérfano | Construir el inventario desde sidecars/índice de la misma familia y reportar `SF.L/T/V` como objetivos PPV. No unir PPA desde `predictions.csv`, ni dejar ambiguo `Transformed`. Crear wrapper neutral + ES. |
| `scaling.R` | Redundante con `audit.R` | Consolidar sus columnas en una única tabla de auditoría; no publicar dos tablas con contratos solapados. |
| `PS.R` + `_fig/PS_PSA.qmd` | Reutilizable después de escenarios frescos | Wrapper por `ScenarioID` que cargue su `PSW.csv` y sidecar; sólo PSA al 5 % en H1/H2/UP, con D/Q/p/n explícitos. Sustituir “matched records” y eliminar target espectral inexistente. No conectar PSV ni SD. |
| `coverage.R` | Bloqueado | Leer grilla generada del índice fresco y selección del producto oficial. Hoy referencia `data/records/plaxis/IMW.csv`, que no existe. |
| `selection.R` | Bloqueado | Requiere configuración de selección aprobada y `data/records/plaxis/IMW.csv` fresco. No existe soporte actual. |
| `TS.R`, wrappers PSV/SD y figuras heredadas | Fuera de la entrega inmediata | El producto público requerido son espectros PSA; no promover PSV/SD ni elegir historias representativas sin una selección aprobada. |

## What Can Be Wired Without Inventing

Ningún resultado puede conectarse hoy como resultado vigente. Después de una corrida fresca aceptada, el camino corto ya existente es:

1. `model`: observado--OOF, residuos, tabla de desempeño, tabla de cuantiles y superficies PPV; luego PPA como complemento.
2. `scenarios`: inventario PPV por escenario, tabla única de auditoría y espectros PSA H1/H2/UP de la familia aprobada.

La figura bootstrap condicional, las tablas de selección y cobertura, y PSV/SD permanecen fuera.

## True Blockers

1. Producto VMD materializado y aceptado con exclusión de IMF1.
2. Corrida fresca del modelo con selección `t_j^*` materializada y coherencia entre métricas, residuos, cuantiles y superficies.
3. Familia completa de escenarios generada desde ese producto VMD/modelo; las cuatro carpetas actuales no satisfacen la configuración declarada.
4. Auditoría regenerada sobre exactamente esa familia; el CSV de junio no es asociable a los sidecars de julio y contiene seis fallas.
5. Si se reportará selección: configuración aprobada y producto `data/records/plaxis` fresco.
6. Partial de Resultados e includes en `_index/model.ES.qmd` y `_index/scenarios.ES.qmd`, sólo después de los gates anteriores.

## Validation

- No se ejecutaron R, modelos, SSEL, procesamiento, escenarios, selección ni render.
- No se editaron `_chapters`, `_summary`, `_fig`, `_tbl`, `scripts` ni `data`.
- `git diff --check` debe permanecer limpio después de registrar este ledger y E84.

