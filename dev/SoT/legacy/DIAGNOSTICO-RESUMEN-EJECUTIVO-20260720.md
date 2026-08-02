# DIAGNÓSTICO — Resumen ejecutivo: contaminación, causas y recomendación

Fecha: 2026-07-20. Frente E135-A6y. Solicitado por el propietario («no sé
quién destruyó esto; está pésimo»). Solo diagnóstico; sin ediciones.

## 1. Procedencia (evidencia git)

- Los cuatro archivos de prosa del resumen (`_summary/{records,model,
  scenarios,risk}.summary.{es.md,md}`) **preceden a esta sesión**: el párrafo
  señalado por el propietario («The dynamic analysis uses complete excitation
  time histories…») existe **textual** en el commit `24cd45c` («finish blast
  report publication bundle»), y su gemelo ES ídem. Autoría: agente previo
  (frente E135-A5, «documento independiente de resúmenes»).
- Lo que esta sesión modificó está itemizado en `active.md` (A6c–A6w):
  glosas de autonomía (S11D, IMPALA, OOF, Jacobi, envolvente, L/T/V),
  correcciones de terminología, lead, Referencias, y eliminación de
  sub-headings por ruling del propietario. **Esta sesión no creó la voz de
  pipeline ni el presente-asertado; sí densificó los bloques con glosas y no
  detectó el vicio retórico en sus dos auditorías** (auditaron autonomía,
  terminología y paridad; no narrativa ni actualidad de las afirmaciones).

Conclusión de procedencia: contaminación **heredada** en su núcleo;
**expuesta** al eliminar los sub-headings (los cuatro bloques quedaron
pegados como una sección única que nunca fue escrita como tal); y
**agravada en densidad** por el parcheo incremental de esta sesión.

## 2. Problemas detectados

- P1. **Presente-asertado de un análisis inexistente**: «El análisis dinámico
  utiliza historias completas de excitación…» afirma como actual un análisis
  de deformaciones que está pendiente. Alucinación de actualidad. (Heredado.)
- P2. **Voz de pipeline / listado de tareas**: la prosa narra intenciones de
  diseño («la base conserva… aporta… caracteriza…») en lugar de afirmar
  hechos y hallazgos. Viola los gates de redacción del ledger («affirmative
  professional prose; do not describe pipelines as methodology»). (Heredado.)
- P3. **Estructura patchwork**: cuatro bloques autónomos escritos para una
  estructura de cuatro secciones que ya no existe. Concatenados: S11D
  presentado dos veces, escalamiento descrito dos veces, PPV/PPA y MIC
  expandidos dos veces, sin arco narrativo. (Heredado el patrón; expuesto por
  el ruling correcto de sección única; las glosas por-bloque de esta sesión
  sumaron repetición.)
- P4. **Fuga de metodología al memo**: K=10, IMF1, diferencia de cierre,
  «Jacobi», «t=0», cinco particiones — detalle de capítulo en un ejecutivo.
  (Heredado; esta sesión lo glosó en vez de cuestionarlo — error propio.)
- P5. **Punto ciego de las auditorías de esta sesión**: verificaron autonomía
  de términos, ledger y paridad; no verificaron (i) actualidad de las
  afirmaciones, (ii) voz narrativa, (iii) unicidad de introducciones a nivel
  documento. Error propio, registrado.
- P6. **Headings de results**: la compactación A6w fue truncado mecánico de
  frases-tarea, no renombrado por contenido. Error propio; propuesta
  corregida pendiente (Cobertura, Amplitudes, Dominio, Desempeño, Residuos,
  PPV, PPA, Inventario, y pares EN).
- P7. **Lead del memo**: enumera los cuatro frentes en una oración-índice;
  aceptable como transmittal, revisable bajo la misma lente si el propietario
  lo desea.
- P8. **«La muestra QDS»** en la prosa pública de results (ambos idiomas):
  identificador interno del pipeline en texto de cliente.

## 3. Por qué el rollback NO es la solución

`git checkout` del estado pre-sesión (`24cd45c`) restauraría P1–P4 intactos:
el texto committeado ya contenía el núcleo del problema. El camino es
re-autoría, no reversión. (Las correcciones de esta sesión que sí valen —
terminología, objetivos reales, licuación/suite, títulos, S11D — están sobre
el working tree y se preservan.)

## 4. Recomendación

- R1. **Re-autoría del resumen ejecutivo como UN documento** con arco único
  (datos → modelo → suite → confiabilidad), cada término introducido una sola
  vez, hallazgos y hechos en voz afirmativa, cero pipeline, cero
  presente-asertado. Propuesta de texto ES completa: Anexo A (presentada al
  propietario en chat; pendiente de ruling frase a frase si lo desea).
- R2. Conservar los bloques hidratados (números) con micro-ajustes de eco
  (p. ej. «La base instrumental procesada reúne…» → «La base reúne…»).
- R3. Tras aprobar ES: espejo EN con el ledger y gates de paridad.
- R4. Aplicar el set corregido de headings de results (P6).
- R5. Eliminar «QDS» de la prosa pública (P8): «La muestra de modelación…».
- R6. **Gates de redacción nuevos** para futuras pasadas (agregar al ledger):
  (i) prohibido afirmar en presente análisis pendientes; (ii) prohibida la
  narración de intenciones de diseño; (iii) regla de introducción única por
  término a nivel documento; (iv) título = nombre de lo mostrado.
- R7. **Proceso**: para prosa de cliente, proponer reescrituras completas de
  sección en lugar de inserciones incrementales — el parcheo incremental
  produjo el patchwork.

## Anexo A — Texto propuesto (ES)

### Movimiento 1 — reemplaza `records.summary.es.md`

La base instrumental procesada conserva las formas de onda completas medidas
durante las voladuras del sitio —duración, secuencia de ciclos y contenido de
frecuencias, además de las amplitudes pico—, tal como requiere el
modelamiento dinámico de deformaciones. La velocidad de partícula es la
medición primaria; cada registro se transformó en historias coherentes de
aceleración, velocidad y desplazamiento bajo una única convención temporal y
de unidades, con el contenido de muy baja frecuencia controlado mediante
descomposición variacional en modos (VMD) [@BooreBommer2005;
@DragomiretskiyZosso2014]. Las observaciones de amplitud combinan el
monitoreo local (fuente IMPALA) con la base complementaria S11D, compilada
por el autor a partir de mediciones en distintos proyectos en el mundo y
admitida únicamente fuera de la envolvente de distancia y carga cubierta por
el sitio, bajo la hipótesis de transferibilidad de sus relaciones
amplitud–distancia–carga. El subconjunto con distancia fuente–receptor y MIC
informadas define las condiciones de voladura observadas.

### Movimiento 2 — reemplaza `model.summary.es.md`

El modelo multirrespuesta estima PPV y PPA para cada condición de distancia
$d$ y carga $q$, por componente longitudinal, transversal y vertical y su
resultante; las predicciones PPV fijan las amplitudes de la suite de
registros y las PPA completan la caracterización de la demanda. Las
covariables comprenden $d$, $q$, la distancia escalada
$\mathrm{SD}=d/\sqrt q$ y sus transformaciones; las amplitudes se modelan en
escala logarítmica decimal. Cinco modelos base —regresión lineal, modelos
aditivos con splines, regresión adaptativa multivariante por tramos,
potenciación de gradiente y bosques aleatorios— se combinan por respuesta con
pesos inversamente proporcionales al RMSE de sus predicciones fuera de
pliegue (*out-of-fold*, OOF), en las que cada observación es predicha por un
ajuste que la excluyó [@friedman1991; @friedman2001; @breiman2001;
@kohavi1995]. Un refinamiento multirrespuesta de actualización simultánea
incorpora las predicciones OOF de las respuestas acompañantes y retiene, por
respuesta, la iteración con mayor $R^2$ OOF. Los cuantiles empíricos de los
residuos OOF definen los niveles predictivos p50, p90 y p95; la mejora
respecto de la formulación independiente se cuantifica sobre los mismos pares
observación–predicción.

### Movimiento 3 — reemplaza `scenarios.summary.es.md`

Cada escenario de la suite reúne las realizaciones triaxiales asociadas con
una condición de distancia, MIC y nivel predictivo: cada historia fuente
L/T/V se escala hasta los objetivos PPV predichos —el mismo factor para
aceleración, velocidad y desplazamiento, que preserva la coherencia
cinemática de cada componente— y el par horizontal se transforma a las
direcciones horizontales principal (H1) y ortogonal (H2), con la vertical
como UP. Los factores son independientes por componente, por lo que las
relaciones de amplitud entre componentes pueden diferir de las de la historia
fuente; la variabilidad temporal y espectral de la población instrumental
queda incorporada en la suite. Cada realización conserva la identidad de su
historia fuente y su condición de voladura, con sus medidas de intensidad y
espectros de pseudoaceleración con 5 % de amortiguamiento.

### Movimiento 4 — reemplaza `risk.summary.es.md`

La formulación de confiabilidad vincula la demanda de cada escenario con la
capacidad de la sección crítica del depósito de relaves BRPM. Para cada
criterio de desempeño, la demanda de cada realización se comparará con su
capacidad admisible; la probabilidad condicional de falla se estimará como la
fracción ponderada de realizaciones que exceden el estado límite y se
contrastará con la probabilidad admisible del criterio, con el índice de
confiabilidad equivalente $\beta=-\Phi^{-1}(p_f)$ expresando la misma
comparación. Los niveles admisibles, la ponderación de las realizaciones y
cualquier regla conjunta entre criterios corresponden al modelo geotécnico de
capacidad. Esta etapa define la metodología y no entrega resultados
cuantitativos de riesgo: su aplicación requiere las respuestas del modelo
dinámico de deformación plana y tensiones efectivas —incluida la evaluación
de licuación dinámica inducida por las voladuras— y las capacidades y
criterios aprobados.

## Qué baja al capítulo (ya está allí; no se pierde)

K=10, IMF1 y diferencia de cierre; «iteraciones Jacobi» y «t=0»; validación
cruzada de cinco particiones; criterio de varianza de H1; enumeración de
medidas de intensidad; convención PGV≡PPV.

## 5. Genealogía de la contaminación (adenda 2026-07-20)

Pregunta del propietario: ¿vino de la traducción literal del documento ES?

Evidencia:

- Ambos gemelos del resumen (ES y EN) nacen en el MISMO commit (6e5c1d6,
  «finish blast report evidence and scenario matrices»): redacción ES y
  traducción EN en un solo batch, bajo el régimen del ledger (ES master).
- El EN es calco estructural del ES: «de modo que» → "therefore", mismo
  orden de cláusulas, mismo contenido. La traducción propagó fielmente; no
  creó el vicio.
- El origen real está un paso antes: la oración condenada del resumen es
  una FUSIÓN de las aperturas metodológicas de dos capítulos ES:
  scenarios.es.md:1 («El análisis dinámico de la sección utiliza historias
  triaxiales…») + records.es.md:1 («La respuesta del modelo geotécnico
  dinámico se obtiene de la historia completa de la excitación. La duración,
  la secuencia de ciclos y el contenido de frecuencias…»). El resumen se
  ensambló comprimiendo y recombinando esas aperturas.

Mecanismo: en los capítulos, el presente («el análisis utiliza…») es voz de
especificación metodológica y es defendible en ese hábitat; extraído de ese
marco y pegado en un resumen ejecutivo, se convierte en aserción de un
análisis inexistente. La cadena fue: apertura metodológica ES → compresión
a resumen ES (contaminación nace aquí) → traducción literal a EN
(contaminación propagada).

- P9 (nuevo, opcional): las aperturas de los propios capítulos conservan esa
  voz de presente-especificación sobre el análisis pendiente
  (scenarios.es.md:1, records.es.md:1 y gemelos EN). En metodología es
  tolerable; si el propietario quiere, se endurecen a voz de requisito
  («requiere historias triaxiales…» / «se obtendrá de…»). La re-autoría del
  Anexo A ya evita importar esa voz al resumen.
