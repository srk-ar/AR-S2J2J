# AUDIT — Autonomía y calidad del memo ejecutivo (ES)

Fecha: 2026-07-20. Solicitado por el propietario. Solo lectura; sin ediciones.

## Alcance

Auditar los cuatro frentes de `summary.es.qmd` como documento independiente:
autonomía (términos asumidos del capítulo), contraste resumen↔capítulo,
mapping objetivos (`_chapters/blast.es.md`) → reporte del memo, y calidad de
texto. ES primero; EN después con `dev/SoT/LEDGER-BLAST-ENGLISH-TERMINOLOGY-20260719.md`.

## Composición verificada del memo

| Sección del memo | Archivos que la hidratan |
|---|---|
| Datos de vibración y observaciones de amplitud | `_summary/records.setup.qmd` (R oculto: valida productos e hidrata) + `_summary/records.summary.es.md` + `_summary/records.executive.es.qmd` |
| Predicción multirrespuesta de PPV y PPA | `_summary/model.summary.es.md` + `_summary/model.executive.es.qmd` |
| Construcción de escenarios triaxiales | `_summary/scenarios.summary.es.md` + `_summary/scenarios.executive.es.qmd` |
| Formulación de confiabilidad | `_summary/risk.summary.es.md` (sin ejecutivo hidratado; coherente con etapa metodológica) |

Superficie: los `*.summary.*` y `*.executive.*` son consumidos únicamente por
`summary.es.qmd`/`summary.en.qmd` (verificado por grep de includes). Editar el
memo no altera Book ni Reveal.

Des-paridad estructural ES/EN: `summary.en.qmd` incluye además
`_tbl/metrics.qmd` y `_tbl/scenarios.qmd`; `summary.es.qmd` no incluye tabla
alguna. Resolver con la matriz Stage II (E135-A6); no tocar en este frente.

Los resúmenes no citan capítulos (`@sec-*`/`@eq-*` ausentes): cumple la
preferencia de autonomía sin referencias cruzadas.

## Verificación de datos

`data/audit/summary.csv` columnas `SF.L/SF.T/SF.V` contienen los **objetivos
PPV en mm/s**, no factores adimensionales: en `F125.D150.Q150.p90.csv` el
`PGV.UP` escalado (19.69816) coincide con `SF.V` (19.6982) para todos los
registros. El texto del ejecutivo de escenarios («Los objetivos PPV abarcan …
mm/s») es correcto. El nombre de columna `SF.*` es engañoso pero es contrato de
datos: fuera de alcance del memo.

## Hallazgos de autonomía por frente

### Records (`records.summary.es.md` + `records.executive.es.qmd`)

- R1. **S11D sin definir** — ni el memo ni el capítulo dicen qué es
  («observaciones S11D», «la fuente complementaria S11D»). Un lector externo no
  puede saber si es una operación, una estación o un dataset. Requiere una
  aposición de procedencia definida por el propietario.
- R2. **IMPALA sin definir** y grafía inconsistente con `blast.es.md`
  («Impala, Northern Concentrator» vs «IMPALA» como etiqueta de fuente).
  Decidir: nombre de operación (Impala) vs etiqueta de fuente (IMPALA), y
  glosar en primera mención.
- R3. «documentadas por **el contratista**» — sin antecedente standalone
  (el contratista de voladuras de la operación minera).
- R4. **VMD sin expandir** en primera mención del memo (el capítulo sí:
  «descomposición variacional en modos (VMD)»). **IMF** nunca se expande;
  «**diferencia de cierre**» es término del proyecto sin gloss (residuo de la
  descomposición).
- R5. El ejecutivo usa «En el orden **L, T y V**…» sin haber ligado las letras:
  primera mención debe ser «longitudinal (L), transversal (T) y vertical (V)».
- R6. «**envolvente local** de distancia o MIC» sin definición (capítulo:
  envolvente rectangular de distancia y carga cubierta por el sitio). Además
  «envolvente local de distancia o MIC» se lee mal; el capítulo dice «fuera de
  alguno de esos intervalos».
- R7. «cada observación … **sólo interviene en las respuestas disponibles**» —
  críptico standalone; significa: cada observación contribuye únicamente a las
  respuestas (PPV/PPA por componente) que tiene medidas.
- R8. «se transforma bajo **una convención común**» — vago; el capítulo dice
  «una única convención temporal y de unidades».

### Model (`model.summary.es.md` + `model.executive.es.qmd`)

- M1. **OOF**: la sigla se expande («predicciones fuera de pliegue,
  *out-of-fold*, OOF») pero la cláusula definitoria — cada observación es
  predicha por un ajuste que la excluyó — llega tarde e implícita (final del
  párrafo 3: «observaciones no utilizadas para producir su propia predicción»).
  Anclar la definición en la primera mención.
- M2. «**iteraciones Jacobi**» sin gloss; una cláusula: actualización
  simultánea en la que todas las respuestas de la iteración t usan el estado
  t−1.
- M3. «formulación **independiente** t=0» — precisar: usa solo las covariables
  de voladura, sin respuestas acompañantes.
- M4. **Identificadores caret** `glm`/`gamSpline`/`earth`/`gbm`/`ranger` en el
  memo: vocabulario de implementación que el propio capítulo evita. El memo es
  más técnico-software que el capítulo; reemplazar por nombres de método.
- M5. «***learners* de base**»: anglicismo que el capítulo no usa (usa
  «familias»); el ledger SSEL fija «modelo base» ↔ «base learner». Unificar.
- M6. Vocabulario capítulo↔memo divergente: capítulo «potenciación secuencial»
  y «agregación de árboles aleatorizados»; memo «potenciación de gradiente» y
  «bosques aleatorios». Decidir el estándar (recomendación: nombres estándar
  «potenciación de gradiente» y «bosques aleatorios» en ambos).
- M7. «**RMSE físico**» → «RMSE en unidades físicas (mm/s; g)».
- M8. «**pares OOF comunes**» → «pares observación–predicción OOF comunes».
- M9. **Hipótesis de transferencia S11D no declarada**: los objetivos prometen
  «bajo la hipótesis de transferencia documentada en el capítulo del modelo»;
  el memo incorpora S11D sin declarar la hipótesis (transferibilidad de las
  relaciones amplitud–distancia–carga fuera de la envolvente local).

### Scenarios (`scenarios.summary.es.md` + `scenarios.executive.es.qmd`)

- S1. **H1/H2/UP usados antes de introducirse** (párrafo 1) y nunca se define
  el criterio: H1 = dirección horizontal principal (mayor varianza de la
  aceleración horizontal), H2 = su ortogonal, UP = vertical. El ledger EN ya
  fija «principal/orthogonal horizontal direction / vertical direction».
- S2. **Caveat material omitido** (está en el capítulo): los factores se
  calculan independientemente por componente, por lo que las relaciones de
  amplitud entre componentes pueden diferir de las de la historia fuente.
- S3. «**medidas de intensidad**» genérico; opcional enumerar una vez
  (amplitudes pico, intensidad de Arias, velocidad absoluta acumulada,
  duraciones significativas).
- S4. **Notación de nivel predictivo inconsistente** en el memo: model usa
  «p50, p90, p95»; el ejecutivo de scenarios imprime «$p=0.90$». Unificar
  (recomendación: «nivel predictivo p90»).

### Risk (`risk.summary.es.md`)

- K1. «la sección crítica **del depósito**» — el memo nunca nombra el depósito
  (BRPM) ni el sitio; depende del hallazgo estructural G1.
- K2. **β omitido**: los objetivos prometen «índices de confiabilidad»; el
  capítulo define β = −Φ⁻¹(p_f) y la equivalencia de admisibilidad; el memo no
  lo menciona. Una oración lo cierra.
- K3. «criterios … **aprobados**» / «probabilidad admisible **aprobada**» —
  precisar por quién/qué marco (modelo geotécnico de capacidad).

## Hallazgos estructurales y transversales

- G1. **El memo no tiene párrafo de encuadre**: arranca en «El análisis
  dinámico utiliza…» sin nombrar instalación, propósito ni alcance del
  documento. La portada puede mitigar, pero la prosa debería nombrar una vez el
  sitio (BRPM; operaciones adyacentes) y la entrega (predicciones de amplitud e
  historias triaxiales; confiabilidad formulada, pendiente de resultados).
  Recomendación: lead de 3–5 líneas derivado de «Contexto y propósito» +
  «Secuencia analítica» de `blast.es.md`.
- G2. **Convención numérica inconsistente**: «6.356» (punto = miles, ejecutivo
  de scenarios) convive con «0.987»-estilo (punto = decimal, resto del memo).
  Ambigüedad real dentro de un mismo documento. Ruling de locale del
  propietario (opciones: decimal «.» + miles con espacio fino; o sin separador
  de miles; o decimal «,» en todo el memo).
- G3. **Política de primera mención documento-nivel**: PPV/PPA/MIC se expanden
  en Records y se re-expanden en Model. Aceptable por robustez de lectura por
  secciones; decidir si se conserva deliberadamente (recomendación: conservar).
- G4. Citas bibliográficas presentes en el memo (BooreBommer2005,
  DragomiretskiyZosso2014, friedman, breiman, kohavi): Quarto agregará la
  bibliografía al final del DOCX. Confirmar que se desea en un memo de ~3
  páginas.

## Mapping objetivos (`blast.es.md`) → memo

| Objetivo | Cobertura en el memo | Estado |
|---|---|---|
| O1 Caracterizar datos instrumentales y observaciones de amplitud | Ternas coherentes ✓; duraciones/Fs/períodos ✓; medianas y p16–p84 de PPA/PPV ✓; conteo de registros con D y MIC ✓; **rangos de cobertura D y MIC del subconjunto documentado ausentes**; diversidad espectral solo como cobertura de períodos | PARCIAL — agregar rangos D/MIC (hidratables de `RECORDS_META`, costo trivial) |
| O2 Estimar la demanda de amplitud (PPV/PPA, componentes y resultantes, evidencia OOF, niveles empíricos, S11D fuera de envolvente) | Todo reportado con métricas OOF y mejora vs t=0 ✓; **hipótesis de transferencia S11D no declarada** (M9) | PARCIAL — una cláusula |
| O3 Construir escenarios triaxiales | Definición, escalado, rotación H1/H2, inventario 36, realizaciones, rangos de objetivos PPV ✓ | CUBIERTO |
| O4 Formular la confiabilidad condicionada por escenario | Estados límite ✓; probabilidad condicional ✓; ponderación declarada pendiente ✓; **β ausente** (K2) | PARCIAL — una oración |

Objetivo general (monitoreo → predicciones de amplitud → historias triaxiales;
confiabilidad formulada sin resultados): cubierto y con guardas correctas («no
constituye todavía un resultado de riesgo geotécnico»; «no corresponde emitir
una clasificación…»).

## Calidad de texto (registro)

Registro profesional, afirmativo, no instruccional, no promocional: correcto en
los cuatro frentes. Tiempos verbales de Risk (futuro consistente) correctos.
Defectos puntuales: los listados arriba (R7, R8, M7, M8) más densidad de
cadenas nominales tolerable para audiencia experta. Sin texto-Wikipedia; las
correcciones deben ser aposiciones de una cláusula, no párrafos didácticos.

## Rulings pendientes del propietario

1. Lead del memo (G1): ¿se agrega? Recomendación: sí, 3–5 líneas.
2. Gloss de S11D (R1) e IMPALA (R2): texto de procedencia de una línea — lo
   define el propietario; el agente no debe inventarlo.
3. Locale numérico (G2).
4. Nombres de métodos ML sin identificadores caret (M4–M6). Recomendación:
   nombres estándar en español, sin backticks.
5. Notación de niveles predictivos (S4). Recomendación: «p90».
6. β en Risk (K2). Recomendación: agregar una oración.
7. Bibliografía al final del memo DOCX (G4): conservar o suprimir.
8. Confirmar que las ediciones se limitan a `_summary/*.summary.es.md` y
   `*.executive.es.qmd` (superficie exclusiva del memo, verificada).

## Próximo paso exacto

Con los rulings 1–5 decididos: batch de edición ES por frente (Records → Model
→ Scenarios → Risk), gates estáticos, render canario
`qrt render summary.es.qmd --profile docx`, y después traslado a EN con el
ledger de terminología y gates de paridad.

## Anexo A — hallazgos en capítulos del reporte principal (2026-07-20)

Detectados al contrastar resumen↔capítulo; verificados contra yml/crossref.
RevealJS (`ppt.qmd`) NO auditado en esta pasada.

- C1. **Doble prefijo de ecuación (confirmado, ambos gemelos)**:
  `_chapters/records.es.md:108` «en la Ecuación @eq-records-pgv» y
  `_chapters/records.md:108` "in Equation @eq-records-pgv". Con
  `eq-prefix: eq.` (yml/_quarto.yml) renderizan «la Ecuación eq. N» /
  "Equation eq. N". Corrección: referencia desnuda `@eq-records-pgv`,
  convención del resto del deck (verificada: los demás usos son desnudos).
- C2. **«demanda sísmica» (confirmado, solo ES)**: `_chapters/risk.es.md:1`
  «demanda sísmica inducida por las voladuras»; el gemelo EN dice
  "blast-induced dynamic demand" y el título/ledger fijan «demanda dinámica».
  Divergencia ES↔EN y desliz terminológico (el informe separa PPA de PGA
  para no connotar sismo). Corrección: «demanda dinámica inducida por las
  voladuras».
- C3. **Puntuación ecuación→«donde»**: en records.es.md, eq-records-pgd y
  eq-records-cav5 terminan en «.» seguidos de «donde …» en minúscula.
  Convención: coma al cierre de la ecuación cuando la oración continúa.
  Verificar el patrón espejo ("where") en records.md al pasar a EN.
- C4. **Convención PGV≡PPV duplicada** en records.es.md: declarada tras
  @eq-records-pgv (l.92) y otra vez tras PGD (l.116, generalizada a PPA).
  Candidato a consolidar en una sola declaración; puede ser redundancia
  deliberada — ruling del propietario.
- C5. **S11D/IMPALA sin procedencia también en capítulos** (records.es.md
  §Observaciones; model.es.md §Base de modelamiento): mismo ruling que el
  memo; definir la aposición una vez en Records y reutilizarla.
- C6. **Nombres de métodos ML**: capítulo usa paráfrasis («potenciación
  secuencial», «agregación de árboles aleatorizados»); si el memo adopta
  nombres estándar, alinear capítulo↔memo o registrar divergencia deliberada.
- C7. **Etiquetas EN en render ES (observación, requiere ruling)**: el
  scaffold comparte `crossref` (Table/Fig./eq.), `toc-title: Table of
  Contents` y `language: en` (_quarto-book.yml); report.es.qmd/index.qmd no
  fijan lang ni overrides, de modo que el Book ES muestra «Table N», «Table
  of Contents», «eq. N». Los renders ES fueron aprobados visualmente por el
  propietario (E133/E134), por lo que NO se corrige unilateralmente: si se
  desea localizar, el camino es override en los entrypoints ES (lang: es,
  toc-title, labels ec./Tabla) sin tocar el scaffold qrt compartido.
- C8. **RevealJS**: pendiente de pasada dedicada (texto de slides, captions,
  títulos de deck) tras cerrar el memo ES.

Capítulos scenarios y blast: sin defectos detectados en esta lectura.
