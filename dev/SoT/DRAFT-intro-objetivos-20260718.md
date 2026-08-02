# DRAFT v2 — Capítulo introductorio (objetivos a discusión, 2026-07-18)

Molde: introducción experta de AR-M2P2B (Background / Scope and
objectives / Organization), adaptada con el hilo explicado por el
usuario. No cableado al book. Los [corchetes] marcan decisiones
abiertas.

---

## Antecedentes [draft]

Las voladuras de producción de las operaciones mineras adyacentes al
depósito de relaves BRPM (Impala, Northern Concentrator) inducen
sismicidad de corta duración sobre relaves finos saturados. El objeto
del programa es determinar qué escenarios de operación —combinaciones
de distancia de voladura y carga instantánea máxima— son seguros para
el depósito, cuáles presentan riesgo moderado y cuáles deben
excluirse. La evaluación exige confrontar la demanda sísmica inducida
por las voladuras con la capacidad del depósito.

En un problema análogo resuelto por el autor [M2P2B / cita del
reporte de Brasil], la capacidad estaba gobernada por la fractura de
una roca frágil y podía parametrizarse mediante una velocidad pico de
partícula crítica: un pico de demanda superior al crítico constituía
la falla, y el análisis de confiabilidad se cerraba en términos de
valores pico. En el presente caso la métrica de falla es el exceso de
presión de poros de un modelo dinámico de deformaciones, y el
análisis de capacidad se encuentra en ejecución mediante modelos de
deformación [PLAXIS — ¿se nombra la plataforma?].

Esta diferencia define la motivación central del trabajo: el PPV no
es una métrica robusta para controlar el riesgo de licuación inducida
por voladuras. Historias de tiempo distintas, calibradas a un mismo
PPV y PPA, producen respuestas de presión de poros y deformaciones
desviadoras sustancialmente diferentes: cada historia es una
observación distinta de una función de densidad de capacidad
desconocida. Mientras en el caso análogo esa densidad provenía de la
variabilidad de la resistencia a tracción de la roca, aquí proviene
de la variabilidad del contenido de frecuencias de la demanda. Por
ello, la evaluación de un escenario requiere una suite de
realizaciones —varias historias de tiempo escaladas al mismo
escenario— que muestree esa variabilidad ante el modelo dinámico.
[Sustento: desarrollo matemático en el capítulo del modelo + tarea
de research (TITO) o paper in-press del autor — título a definir,
propuesta abajo.]

## Alcance y objetivos [draft]

El propósito de este informe es desarrollar la demanda sísmica
inducida por voladuras del sitio en la forma que el análisis dinámico
del depósito requiere: suites de historias de tiempo calibradas por
escenario de distancia y carga. Los objetivos son:

- **O1 — Base de registros normalizados.** Procesar numéricamente los
  registros de vibración medidos en el sitio (ruido, amplitudes
  espurias, coherencia cinemática) y normalizarlos para remover el
  sesgo de carga y distancia que cada uno trae. La normalización
  descansa en una hipótesis explícita: el contenido de frecuencias de
  los registros del sitio no se altera fuertemente con la distancia
  (efecto de paso de onda), válida porque los rangos de distancia
  involucrados son cortos.
- **O2 — Modelo de predicción de amplitudes.** Establecer el modelo
  que fija qué amplitud debe tener un registro a una distancia y
  carga dadas. Los modelos de predicción para voladuras alcanzan
  típicamente R² inferiores a 0.50 con datasets convencionales de
  distancia, carga y PPV; este trabajo emplea una metodología de
  ensamble con refinamiento condicional entre respuestas —las
  relaciones entre componentes de PPV y PPA actúan como variables
  latentes del sitio— que eleva el desempeño hasta R² ≈ 0.85
  [valor hidratado por corrida]. Como los escenarios de interés
  incluyen distancias y cargas no observadas en el sitio, el dataset
  se amplía con eventos de proyectos análogos en geologías de roca
  similar, admitidos solo fuera de la envolvente local; la hipótesis
  de similitud de contenido de frecuencias se declara y podrá
  abandonarse a medida que nuevas mediciones del sitio pueblen esos
  rangos.
- **O3 — Suites de escenario para el análisis dinámico.** Generar,
  verificar y seleccionar las realizaciones de cada escenario —
  historias escaladas a las amplitudes predichas, rotadas a
  direcciones principales— de modo que el modelo dinámico disponga,
  para cada combinación de distancia y carga, de varias observaciones
  de la métrica falla/no-falla.

## Organización [draft — mapa B, a validar]

- Capítulo 1 <- O1: registros de vibración — procesamiento numérico
  y normalización (con la hipótesis de paso de onda).
- Capítulo 2 <- O2: modelo de predicción de amplitudes — marco
  probabilístico agnóstico (demanda condicional multiplicativa),
  ley paramétrica histórica como contexto, dataset aumentado,
  ensamble ssel + refinamiento condicional, cuantiles empíricos.
- Capítulo 3 <- O3: escenarios y suites — escalamiento, rotación,
  verificación física, selección y trazabilidad.
- Capítulo 4: análisis de riesgos (capacidad en proceso) —
  investigación futura.

NOTA: este mapa B REORDENA el actual (mapa A: atenuación primero,
registros+escenarios juntos). El hilo del usuario procesa/normaliza
ANTES del modelo, y separa el modelo de las suites.

## Propuesta de título del paper in-press (a veto)

"Frequency-content-controlled liquefaction demand from blast-induced
ground vibrations: why peak particle velocity is not a sufficient
risk metric" — Verri Kozlowski, in preparation. [Título y venue a
definir por el usuario; la entrada bib se crea recién con su OK.]

## Preguntas a discusión

1. ¿Mapa B (registros -> modelo -> suites -> riesgo) reemplaza al
   mapa A de dos temas? El hilo lo sugiere.
2. ¿Se nombra PLAXIS en el cuerpo o "modelo dinámico de
   deformaciones" sin plataforma?
3. ¿El umbral de presión de poros se menciona como "a determinar por
   la rama de capacidad" o se omite?
4. Título/venue del paper in-press; ¿o tarea TITO de research en su
   lugar?
