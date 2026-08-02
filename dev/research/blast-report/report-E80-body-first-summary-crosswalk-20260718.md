# report-E80-body-first-summary-crosswalk-20260718

## Section

Blast report / E80 — cierre body-first de `records`, `model`, `scenarios` y
`risk`, previo a la reauditoría de sus resúmenes ejecutivos.

## Report Purpose

Determinar qué cuerpos describen el trabajo efectivamente realizado, qué
faltantes impiden cerrarlos y qué contenido debe completarse antes de editar
los resúmenes. El resumen no funciona como apéndice de Metodología: después del
cierre de cada cuerpo, ambos deben poder leerse de manera autónoma y representar
el mismo alcance con diferente nivel de detalle.

## Sources Read

- `dev/SoT/ACTIVE.md` y la cadena Blast indicada por ese estado.
- `dev/plan/blast-report/active.md`, en particular E68--E74, E79 y E80.
- `garage/harness/HARNESS.md` y `RESEARCH-LEDGER-HARNESS.md`.
- `garage/style/summary.md` y `technical-writing.md`.
- `_chapters/{records,model,scenarios,risk}.es.md` completos.
- `_chapters/{records,model,scenarios,risk}.summary.es.md`, sólo para
  inventario; no se inició su reescritura.
- `_summary/records.executive.es.qmd` y
  `_summary/records.results.es.qmd`.
- `_index/{records,model,scenarios,risk}.ES.qmd`.
- `scripts/runGMSP.R`, `scripts/gmsp/setup.R`, `scripts/runScenarios.R`,
  `scripts/runScenarios.json`, `scripts/runAudit.R` y los contratos de
  selección inventariados en E70/E79.
- `scripts/runChain.R` y `scripts/runPost.R`, en modo de sólo lectura.
- Librería oficial instalada desde `origin/dev`: documentación y código de
  `ssel::chainPipeline()` para la selección por respuesta de la mejor iteración.
  No se editó, instaló ni ejecutó la librería.
- `dev/SoT/chapters-legacy-20260718/records.processing.md`.
- `dev/SoT/HANDOFF-timeseries-reexport-no-imf-removal-20260711.md`.
- `dev/research/blast-report/EVIDENCE-implementation-stack-20260707.md`.
- `dev/research/blast-report/HANDOFF-blast-report-methodology-20260707.md`.
- `dev/research/blast-report/DRAFT-report-reading-copy-20260707.md`.
- Auditoría E72 del precedente `AR-SABE0.R`, conservada como contrato de
  exposición profesional de soporte, desempeño OOF, ensamble, estados
  condicionales, residuos y cuantiles; ninguna cifra se transfiere a Blast.

## Exact Claims Allowed

### Records

- La fuente instrumental contiene historias medidas de velocidad en L/T/V; la
  aceleración y el desplazamiento se derivan bajo una convención común.
- La población completa aporta formas temporales y el subconjunto con distancia
  y carga aporta observaciones al modelo de amplitudes.
- La normalización por PGV separa la forma temporal de la amplitud que asigna el
  escenario.
- PGA, PGV, PGD, AI, CAV, CAV5, duraciones significativas y PSA al 5 % son
  descriptores calculados de las historias correspondientes.
- El capítulo de resultados materializado lee hoy la base
  `F125.Qo.Do`, mientras la generación activa de escenarios declara como entrada
  `F125.Qo.Do.eemd`.
- El flujo EEMD vigente descompone cada aceleración en diez IMF y reconstruye
  retirando IMF1 y las dos IMF más lentas; vuelve a derivar velocidad y
  desplazamiento desde la aceleración reconstruida.
- El handoff del 11 de julio registra una decisión posterior: la siguiente
  exportación no retirará IMF selectivas. Esa exportación no está ejecutada y
  el handoff deja abierta la elección entre reconstrucción EEMD completa y
  bypass de la descomposición.

### Model

- Se modelan ocho respuestas positivas en `log10`: PPV y PPA total y en L/T/V.
- Cinco familias se combinan por respuesta con pesos inversamente
  proporcionales a su RMSE OOF.
- El estado independiente es `t=0`; se evalúan hasta tres estados condicionales
  mediante actualizaciones simultáneas a partir de predicciones acompañantes.
- La librería oficial ensambla el producto final por respuesta seleccionando
  entre `t=0,1,2,3` el estado con mayor R2 OOF. Distintas respuestas pueden
  conservar estados distintos.
- Los cuantiles p50, p90 y p95 se construyen con residuos OOF y no garantizan
  cobertura condicional para cada combinación de distancia, carga o población.
- La nueva corrida está pendiente; no se permiten cifras heredadas ni
  afirmaciones sobre el estado seleccionado o la mejora obtenida.

### Scenarios

- Una condición se define por distancia, carga y nivel predictivo de amplitud;
  este último no es una probabilidad de ocurrencia ni de falla.
- Los objetivos PPV pertenecen a L/T/V; el escalamiento por componente aplica
  un único factor a aceleración, velocidad y desplazamiento.
- La rotación posterior produce H1/H2 y conserva V como UP.
- La verificación numérica controla la reproducción del objetivo vertical, la
  invariancia cuadrática de la rotación horizontal y PGA positiva.
- El procedimiento de selección conserva identidad y trazabilidad, pero su
  configuración final y su familia aceptada permanecen pendientes.

### Risk

- El cuerpo actual define únicamente la interfaz entre la demanda trazable y
  un análisis geotécnico receptor futuro.
- Las respuestas físicas no equivalen por sí solas a falla; la clasificación
  requiere criterios y umbrales aprobados.
- Una fracción de realizaciones fallidas no constituye automáticamente una
  probabilidad; se requieren población y pesos justificados.
- Una probabilidad condicional de falla no constituye riesgo anual sin
  frecuencias y consecuencias.

## Claims Not Allowed

- Presentar VMD como procesamiento de la base que alimenta los escenarios
  actuales. VMD pertenece a la etapa futura Wave3D/modal, no al flujo Blast
  activo.
- Afirmar simultáneamente que no se retiran modos y que los escenarios vigentes
  consumen `F125.Qo.Do.eemd`; son dos productos diferentes.
- Elegir por inferencia entre la exportación EEMD selectiva vigente y la
  reexportación sin retiro decidida pero pendiente.
- Presentar la ecuación del ensamble como descripción completa del modelo de
  amplitudes; falta el refinamiento multirrespuesta y la selección final por
  respuesta.
- Afirmar que el condicionamiento mejora una respuesta, identificar una
  iteración ganadora o publicar métricas antes de la corrida fresca.
- Presentar una especificación de selección disponible como la selección
  efectivamente aplicada y aceptada.
- Presentar PLAXIS, FLAC, PM4Sand, umbrales, pesos o `Pf` como ejecutados o
  aprobados cuando el modelo receptor no existe en este repositorio.
- Completar `risk` mediante matemática genérica sin el modelo receptor, los
  criterios y la población del proyecto.
- Usar resultados de junio/julio, PSV o SD para llenar huecos del reporte.

## Equations Allowed

### Records

- Operadores que generan la terna coherente, una vez verificados contra el
  producto definitivo que se documentará.
- Normalización por PGV y factor de escalamiento, porque conectan records con
  scenarios.
- Definiciones de descriptores en el cuerpo: picos, AI/CAV/CAV5, duración y PSA.
- Razón PSA/PGV, porque interpreta el resultado espectral normalizado.
- Si se mantiene el producto EEMD selectivo, una única ecuación de
  reconstrucción que identifique el conjunto de IMF retenidas; no una batería
  de métricas modales sin producto reportado.

### Model

- Resultantes PPV/PPA, representación de predictores y respuesta en `log10`.
- Pesos del ensamble por RMSE OOF.
- Actualización condicional multirrespuesta.
- Residuos y cuantiles predictivos empíricos.
- Métricas OOF y selección del estado final por respuesta:

  $$
  \operatorname{RMSE}^{(t)}_j=
  \left[\frac{1}{n_j^{(t)}}\sum_i
  \left(z_{ij}-\widehat z_{ij}^{\mathrm{OOF},(t)}\right)^2\right]^{1/2},
  \qquad
  R_j^{2,(t)}=
  \operatorname{Cor}^2\!\left(
  z_{ij},\widehat z_{ij}^{\mathrm{OOF},(t)}
  \right),
  $$

  $$
  t_j^*=\operatorname*{arg\,max}_{t\in\{0,1,2,3\}}
  R_j^{2,(t)}.
  $$

  El texto debe declarar `n_j^(t)` junto a cada comparación, porque el soporte
  puede cambiar entre estados.

### Scenarios

- Factor de escala PPV/PGV, rotación ortogonal y diagnóstico de consistencia.
- La tolerancia numérica y la configuración de selección deben derivarse de la
  familia aceptada, no de una instantánea histórica.

### Risk

None en el cuerpo actual. El ruling E74 retiró las ecuaciones genéricas de
estado límite y ponderación porque los contratos del receptor y de la población
no estaban autorizados. Sólo pueden volver mediante una tanda propia y con los
insumos reales.

## Equations Excluded

- Descomposición y métricas VMD en `records`.
- Batería de PGA/AI/CAV/duraciones en el resumen ejecutivo de `records`.
- Criterios de parada de la cadena expuestos como manual del algoritmo. El
  cuerpo necesita la regla de selección del producto; tolerancia y paciencia
  son controles de ejecución secundarios salvo que afecten el resultado
  reportado.
- Ecuaciones de interpolación y auditoría adicionales que no cambien la
  interpretación del escenario.
- Indicadores de falla, agregaciones o riesgo anual sin criterios, pesos,
  frecuencias y consecuencias aprobados.

## Vocabulary Allowed

- historia medida; base instrumental; base reconstruida; reconstrucción EEMD;
  IMF retenida/retirada; forma temporal; PGV; PSA normalizada por PGV; soporte;
  predicción OOF; estado independiente; estado condicional; selección por
  respuesta; R2 OOF; RMSE OOF; cuantil predictivo empírico; objetivo PPV;
  realización; trazabilidad; modelo receptor; criterio de desempeño; fracción
  descriptiva; probabilidad condicional; frecuencia; consecuencia.

## Vocabulary Rejected

- VMD para el flujo activo; modo físico; componente verdadera de voladura;
  historia canónica para dos productos distintos; capa o layer sin definición;
  modelo aceptado antes de la corrida; mejora por mera existencia de una
  iteración; selección conservadora sin prueba; probabilidad de falla como
  sinónimo del nivel `p`; riesgo ejecutado; nombres de scripts, rutas, archivos,
  columnas o helpers en prosa pública.

## Candidate Public Paragraph Or Section

### Records

None. El cuerpo no puede cerrarse hasta que el usuario confirme cuál producto
debe documentar el informe final: los escenarios vigentes con reconstrucción
EEMD selectiva o la reexportación sin retiro de IMF ya decidida pero todavía no
ejecutada. El texto actual de VMD no representa ninguna de esas dos opciones.

### Model — candidato para completar selección y métricas

> El producto final se selecciona por separado para cada respuesta entre el
> modelo independiente y los tres estados condicionales evaluados. La
> comparación utiliza las predicciones fuera de muestra de cada estado: se
> reportan la raíz del error cuadrático medio y el coeficiente de determinación,
> junto con el número de observaciones que sustenta cada estimación. Para la
> respuesta $j$ se conserva el estado $t_j^*$ que maximiza $R_j^2$; por ello,
> distintas respuestas pueden retener diferentes grados de refinamiento y el
> estado independiente continúa siendo una alternativa válida. Esta selección
> define qué predicciones, residuos y cuantiles integran el producto final.

El candidato es metodológico y no afirma que el condicionamiento haya mejorado
el producto. Las ecuaciones precedentes deben acompañarlo en el cuerpo; en el
resumen bastará, si luego se juzga indispensable, declarar la selección por
respuesta en prosa.

### Scenarios

None. La formulación de escalamiento, rotación y verificación está desarrollada;
falta materializar la configuración final de selección y la familia aceptada.

### Risk

None. El cuerpo sólo puede cerrarse como interfaz explícita de trabajo futuro,
o ampliarse después de recibir el modelo receptor y los criterios del proyecto.
No existe una tercera opción técnicamente honesta.

## Candidate Translation Terminology

None. El español es el master; no se crea espejo EN antes del cierre y la
aprobación de los cuatro cuerpos.

## Open Gaps

### Records

1. Decidir el producto final: EEMD selectiva vigente o reexportación sin retiro
   de IMF.
2. Hacer que Metodología, Resultados y scenarios describan la misma base, o
   distinguir explícitamente la base medida reportada de la base reconstruida
   consumida aguas abajo.
3. Verificar el contrato exacto de remuestreo, pasabajos, ventanas y derivación
   antes de conservar esos detalles.
4. Sólo entonces cerrar el cuerpo y ejecutar el crosswalk del resumen.

### Model

1. Aprobar el párrafo y las métricas/selección del estado final.
2. Ejecutar la corrida fresca fuera de esta tarea editorial.
3. Reportar soporte por respuesta y estado, familias/pesos del ensamble,
   desempeño OOF, estado seleccionado, residuos y cuantiles desde el producto
   vigente.
4. Recién después escribir resultados detallados y el párrafo parametrizado del
   resumen.

### Scenarios

1. Cerrar primero el modelo de amplitudes.
2. Fijar banda, nivel predictivo, dominio D--Q, cardinalidad y método de
   selección.
3. Generar y auditar una familia fresca; documentar completitud y resultados.
4. Recién después reauditar el resumen.

### Risk

1. Decidir si el capítulo final es una interfaz de etapa futura o una
   metodología ejecutada.
2. Para una metodología ejecutada: geometría y estado inicial, plataforma,
   modelo constitutivo y calibración, condiciones de borde/drenaje, aplicación
   de demanda, variables de respuesta, criterios/umbrales, población/pesos,
   frecuencias, consecuencias y resultados.

## Validation

- Auditoría body-first completada; no se editó ningún resumen.
- Contradicción `F125.Qo.Do` / `F125.Qo.Do.eemd` / reexportación sin retiro
  registrada como gate y no resuelta por conjetura.
- Regla oficial de selección SSEL leída en código y documentación actuales, sin
  ejecutar ni modificar la librería.
- Cada ecuación propuesta tiene una función explícita en la revisión.
- Cero resultados heredados, figuras/tablas nuevas, pipelines, SSEL o renders.
- Después del cierre de cada cuerpo: crosswalk párrafo por párrafo de resumen a
  Metodología y Resultados, con clasificación `indispensable`, `decisivo`,
  `redundante` o `demasiado metodológico`.
- `git diff --check` antes de cualquier migración pública.
