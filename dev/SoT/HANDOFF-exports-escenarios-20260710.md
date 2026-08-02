# HANDOFF — Exports de escenarios y series de tiempo (2026-07-10)

Encargo del usuario: correr la cascada de escenarios + audit + exports de
series de tiempo, y preparar su presentacion. EL AGENTE ACTUAL NO LOS CORRE
por orden expresa ("no hagas los exports, solo prepara un handoff").

## Alcance ordenado por el usuario

- SOLO los **36 escenarios originales**: D 150-400 step 50 x MIC 150-400
  step 50, p = 0.90, familia F125.Qo.Do.eemd. NO los 54 de la grilla nueva.
  -> `scripts/runScenarios.json` hoy tiene `D.grid` = [100..500]; DEBE volver a
  `[150, 200, 250, 300, 350, 400]` antes de lanzar (una edicion de JSON).
- Los exports de series de tiempo son PESADOS: como llevarlos al ppt queda
  PENDIENTE DE DISCUSION con el usuario antes de implementarlo (opciones a
  proponerle: miniaturas por escenario, solo los registros seleccionados,
  una lamina por celda D-MIC con AT/VT representativos, o enlaces).

## Estado del modelo que consumira la cascada (config E44, congelada)

- Manifest: sources IMPALA + S11D con `admission: {S11D: "exterior"}` (filas
  S11D solo donde D o Q cae fuera de la envolvente del sitio; regla en
  `scripts/data/buildDomains.R`, seccion 1a). PMC11787524 y CAV EXCLUIDOS.
  Dataset QDS (dominios Y,Q,D,S). Grilla de prediccion D 100-1250 step 25.
- runChain: maxIter=3, patience=5, 5 metodos (ranger, earth, gbm, gamSpline,
  glm). SIN epilogo de stitch fisico (eliminado por orden del usuario): el
  stitch nativo de ssel publica las 8 respuestas — la familia PPV publicada
  es ENCADENADA (r2 pool 0.81-0.89; restringida al sitio 0.61-0.70).
- `predictions.csv` verificado == `Yo.csv` (contrato postProcess reparado:
  ahora ambos salen coherentes del stitch nativo; ver active.md E36/E44).

## Precauciones criticas para la cascada

1. **Preflight en `.scaleAT`** (scripts/gmsp/setup.R): filtra filas de grilla
   (excluye las 68 de entrenamiento que postProcess incluye) y verifica
   monotonia D/Q con tolerancia 0.025 dex, fail-loud. Las superficies PPV
   encadenadas tienen textura mayor (pasos locales +0.05-0.09 dex medidos en
   iteraciones 1-3): ES PROBABLE QUE EL PREFLIGHT ABORTE. La decision es del
   usuario: subir la tolerancia con justificacion, o publicar otra iteracion.
   NO decidir por el: presentarle los numeros (patron en active.md E43b/E44).
2. **Carpetas rancias**: `rm -rf data/records/scenarios/F125.*` antes de
   lanzar (OVERRIDE=false retomaria carpetas con targets viejos).
3. Secuencia exacta (desde la raiz del repo, una linea):
   `Rscript scripts/runScenarios.R > /private/tmp/exports-scenarios.log 2>&1 && Rscript scripts/runAudit.R > /private/tmp/exports-audit.log 2>&1`
4. Verificacion post-audit: `data/audit/summary.csv` — UP.ok/energy.ok/
   PGA.pos TRUE en los 36; UP.ratio ~1 (ancla de velocidad: PGV vertical del
   registro escalado == SF.V).
5. La tabla de auditoria ya tiene builder y slide (`scripts/tbl/audit.R`,
   `_slides/audit.qmd`) — con el audit fresco solo hay que re-renderizar el
   ppt (`qrt render ppt.qmd --profile revealjs`).

## Slides de timeseries y espectros (diseno psha, orden del usuario)

- El patron es el bundle SRS de psha (ver `psha --help`; referencia viva en
  AR-SABJ0.R y AR-SABP0.R): UN deck revealjs POR MAGNITUD (`srs.at.qmd` =
  timeseries de aceleracion; `srs.vt.qmd`, `srs.dt.qmd`; `srs.psa.qmd`/
  `srs.psv.qmd`/`srs.sd.qmd` = espectros), cada uno parametrizado por un
  directorio de corrida (`PathSRS`) y con tabset H1/H2/UP; el builder
  (`scripts/fig/TS.R`, `PS.R`) superpone TODOS los registros del TSW.csv.
  Asi se evita el ppt monolitico pesado: N escenarios = N renders del mismo
  deck parametrico (qrt es dueno del render), no N tabsets en un archivo.
- Para blasting: PathSRS -> `data/records/scenarios/<ScenarioID>/` (cada
  escenario ya escribe TSW.csv + IMW.csv + espectros tras la cascada).
  Traer el bundle con `psha pull` y adaptar el setup (raiz de escenarios,
  unidades mm) + un indice de escenarios para navegar los 36.
- SOLO timeseries interesan al usuario como export (mas los espectros como
  plots SRS); SOLO los 36 escenarios originales.

## Que hidratar despues (ya planificado en active.md, plan V2)

- Tabla de auditoria en deck y books (builder listo).
- Series de tiempo al ppt: DISCUTIR formato con el usuario primero (peso).
- Inventario de escenarios (D, MIC, targets, n registros) como tabla de C05.
- Seleccion de registros (runSelect) NO se recorre — decision vigente.

## Reglas de proceso vigentes (no violarlas)

- La cascada es la etapa terminal cara: correr UNA vez, con todo congelado y
  aprobado (regla en active.md; tres cascadas se tiraron por violarla).
- Solo ssel predice; los scripts del proyecto preparan datos y verifican.
- Sin Co-Authored-By en commits. Sin notacion inventada: nombres de datasets
  por dominios; poblacion en el manifest.
- `dev/plan/blast-report/active.md` es la superficie de verdad; registrar
  alli todo antes de cualquier compactacion.
