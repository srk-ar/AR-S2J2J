# HANDOFF — Diagramas de etapas del pipeline (2026-07-10)

Encargo del usuario: documentar TODAS las etapas del pipeline con diagramas
en el formato de la casa — una pagina por figura — e hidratar reporte y ppt
con ellos. "Muy importante para la documentacion del reporte."

## Formato y reglas (fuentes verificadas, no buscar en otro lado)

- ESTILO: `~/github/tools/SPAS/_fig/methodology_flow.dot` — Graphviz DOT,
  rankdir TB, splines ortho, Helvetica, nodos HTML-table con header
  coloreado, circulo START, nota de comando monospace punteada, artefactos
  folded-note, callouts punteados para anotaciones. Comandos de render como
  comentario en el .dot: `dot -Tpng -Gdpi=240 ...` y `dot -Tpdf ...`.
- REGLAS: `~/Cloud/github/tools/tito/diagrams/README.md` — los bloques
  nombran ETAPAS estables (no rutas de archivos ni simbolos); detalles de
  implementacion dentro del cuerpo con prefijos `entry:`/`helper:`/
  `artifact:`; vocabulario visual Code/Decision/Workflow/Rules/Executor/
  Artifact/Annotation; si un bloque junta detalles inconexos, partir la
  etapa. Ejemplos vivos: `tools/tito/diagrams/*.dot` (master + un detalle
  por pipeline).
- NOTA: en `garage/` NO hay reglas de diagramas; `libraries/tito` no existe
  (es `tools/tito`). `dot` esta instalado (graphviz 15.1).

## Hidratacion (propuesta pendiente de confirmacion del usuario)

Diagramas AGNOSTICOS (logica de etapas, durable); los numeros del proyecto
van en el caption de cada pagina (wrapper qmd), que se actualiza con las
corridas sin pudrir el .dot. No mantener dos variantes del mismo diagrama.

## Inventario — una pagina por figura (nombres PROPUESTOS; convencion final
del usuario)

0. flow_master — blastDB -> runParse -> runData -> runModel/runChain (ssel)
   -> runPost -> escenarios gmsp -> runAudit -> exports/decks SRS -> books+ppt.
1. flow_parse — curacion de blastDB: fuentes, reglas de limpieza (tripletes
   L=T=V, valores repetidos entre distancias), unidades por fila.
2. flow_data — runData: buildDomains (fuentes -> ADMISION EXTERIOR: filas de
   fuentes marcadas "exterior" entran solo si su D o su Q cae fuera de la
   envolvente del sitio; chequeo de unidades por familia; log10; dominios
   Y/Q/D/S + sources.csv + index.csv) y buildDatasets (datasets por
   dominios, split train/predict).
3. flow_model — modelPipeline: por respuesta x dataset, 5 metodos caret
   (ranger, earth, gbm, gamSpline, glm), CV, ensambles R2/RMSE (w=1/RMSE),
   residuos OOF; artefactos metrics/response/residuals_oof/overfit/
   prediction_quantiles.
4. flow_chain — chainPipeline: barrido Jacobi, features companeras `.o`
   (OOF en train, predicciones en grilla), maxIter=3/patience=5, stitch
   nativo por respuesta (SIN overrides del proyecto); artefactos data/iter/*.
5. flow_post — postProcess: offsets q50/90/95, twins log/nativo
   (Transformed), predictions.csv (grilla + filas train con bandas OOF).
6. flow_scenarios — .scaleAT (scripts/gmsp/setup.R): preflight fisico
   fail-loud (filtra filas de grilla; tolerancia 0.025 dex), targets PPV
   p90, SF por componente = target/PGV del registro fuente, escalado con
   UN escalar (mueve AT/VT/DT juntos), rotacion H1/H2/UP, espectros D50;
   artefactos por escenario (TSW/IMW/PS/json).
7. flow_audit — runAudit: UP.ok (PGV vertical == SF.V), energy.ok
   (la rotacion conserva energia horizontal), PGA.pos; summary.csv.
8. flow_exports — seleccion + empaquetado de timeseries + decks SRS
   parametricos (bundle psha: un deck por magnitud, PathSRS por escenario;
   ver HANDOFF-exports-escenarios-20260710.md).
9. (opcional) flow_validation — chequeos permanentes: exponentes libres con
   IC, corredor S11D, preflight, escaneo de terminos.

## Integracion

- Books: cada capitulo abre con sus diagramas — C01/C02: master + parse/
  data; C03: model + chain + post; C04: scenarios + audit (+ exports).
  Una pagina por figura: wrapper en `_fig/` con caption hidratado EN y ES.
- PPT: seccion "Pipeline", un slide por diagrama (PNG a pagina completa).
- Scaffold psha: promover los .dot agnosticos como componente (naming del
  usuario; NO commitear en tools/ sin su gate).

## Orden de ejecucion (regla de proceso: barato primero)

1. SOLO `flow_master` en borrador -> preview PNG al chat -> aprobacion
   VISUAL DEL ESTILO por el usuario antes de producir los demas.
2. Tanda 1-5 (etapas ssel), preview por figura.
3. Tanda 6-8 (gmsp/exports; flow_exports recien tras decidirse el formato
   de timeseries en ppt con el usuario).
4. Wrappers + captions EN/ES + hidratacion de books y ppt + renders +
   escaneo de terminos prohibidos en captions.
5. Promocion a scaffold.

## Reglas vigentes que aplican

- Nombres: el usuario decide toda convencion; proponer y esperar.
- Sin Co-Authored-By en commits. active.md es la superficie de verdad.
- Estado del proyecto al momento del handoff: ver active.md E43-E46 (config
  final: dataset QDS con admision exterior S11D, PMC/CAV excluidos, stitch
  nativo de ssel, books y ppt hidratados y aprobados).
