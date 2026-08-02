# report-E82-records-model-scenarios-summary-candidates-20260718

## Section

Blast report / E82 -- resúmenes ejecutivos de `records`, `model` y
`scenarios` después del cierre body-first.

## Report Purpose

Reescribir los tres resúmenes como capítulos condensados y autónomos, con las
decisiones metodológicas indispensables y sin trasladar la batería completa de
definiciones del cuerpo. Los párrafos de resultados se mantienen en partials
parametrizados separados y sólo se completan desde productos vigentes.

## Sources Read

- `garage/harness/HARNESS.md`.
- `garage/style/summary.md` y `garage/style/technical-writing.md`.
- `dev/plan/blast-report/active.md`, E68--E80-D6.
- `dev/research/blast-report/report-E80-body-first-summary-crosswalk-20260718.md`.
- `dev/research/blast-report/report-E80-D4-model-summary-crosswalk-20260718.md`.
- `_chapters/{records,model,scenarios}.es.md` después de E80-D3 y E80-D6.
- `_chapters/{records,model,scenarios}.summary.es.md`.
- `_summary/records.executive.es.qmd` y `_summary/records.results.es.qmd`.

## Audit Decisions

### Records

- Retirar las ecuaciones de PGA/PGV/PGD, AI/CAV y duraciones: son definiciones
  del cuerpo y no cargan la decisión ejecutiva.
- Conservar el motivo geotécnico de usar historias completas, la construcción
  coherente de aceleración/velocidad/desplazamiento, VMD con retiro de IMF1, la
  normalización por PGV y la hipótesis de transferencia de formas.
- Nombrar los descriptores y PSA al 5 % porque identifican los productos que el
  capítulo reporta.
- Mantener los resultados numéricos en `_summary/records.executive.es.qmd`.

### Model

- Adoptar el candidato E80-D5 completo: población, dominio, cinco familias,
  evidencia OOF, ensamble, refinamiento Jacobi, selección por respuesta y
  cuantiles residuales.
- Conservar una sola ecuación, la del ensamble ponderado, porque explica la
  combinación de familias. Las fórmulas Jacobi, RMSE, $R^2$, selección y
  cuantiles permanecen en el cuerpo.
- Evitar cardinalidades rígidas de respuestas e iteraciones.
- El párrafo de resultados requiere una corrida fresca aceptada.

### Scenarios

- Conservar la ecuación de escalamiento porque explica la construcción de cada
  historia de escenario.
- Explicar la interpolación, la rotación posterior del par horizontal, las
  verificaciones y la trazabilidad sin repetir todas las ecuaciones del cuerpo.
- Retirar el menú genérico de selección. La configuración aplicada sólo puede
  entrar desde la familia aceptada.
- El párrafo de resultados requiere la familia fresca y su auditoría.

## Candidate Public Summary -- Records

El modelo dinámico se evalúa con historias completas de excitación. Este capítulo establece la base instrumental que conserva la duración, la secuencia de ciclos y el contenido de frecuencias de las vibraciones medidas, y separa esas formas temporales de la amplitud que corresponde a cada combinación de distancia y carga. La población completa aporta historias para construir realizaciones; el subconjunto con distancia fuente--receptor y carga instantánea máxima aporta además observaciones al modelo de amplitudes.

La velocidad de partícula constituye la medición primaria. Cada registro se regulariza sobre un eje temporal uniforme y se transforma bajo una convención común para obtener ternas coherentes de aceleración, velocidad y desplazamiento [@BooreBommer2005]. La reconstrucción emplea descomposición variacional en modos (VMD) [@DragomiretskiyZosso2014] y excluye IMF1, correspondiente al modo de baja frecuencia en la convención del proyecto.

Cada terna procesada se normaliza por la velocidad pico de su componente. El mismo factor actúa sobre aceleración, velocidad y desplazamiento, de modo que las amplitudes PPV predichas para cada escenario pueden reasignarse sin alterar la forma relativa ni la coherencia cinemática de la historia. La transferencia de las formas normalizadas entre condiciones de distancia y carga constituye una hipótesis explícita del análisis.

La población se caracteriza mediante PGA, PGV y PGD; intensidad de Arias, CAV y CAV5; duraciones significativas; y espectros de pseudoaceleración con 5 % de amortiguamiento [@Arias1970]. La razón PSA/PGV separa la forma espectral del nivel de velocidad propio de cada registro y permite describir la diversidad que las realizaciones trasladan al modelo dinámico.

## Candidate Public Summary -- Model

El modelo de amplitudes asigna niveles de velocidad pico de partícula (PPV) y aceleración pico de partícula (PPA) a cada condición de distancia fuente--receptor $D$ y carga instantánea máxima $Q$. Las respuestas comprenden las componentes longitudinal, transversal y vertical, y la resultante escalar de cada familia. Las predicciones PPV por componente fijan la escala de las historias temporales de escenario; PPA completa la caracterización de amplitudes e interviene en el refinamiento multirrespuesta.

La población de modelamiento reúne las observaciones locales y los registros de S11D admitidos fuera de la envolvente rectangular de $D$ y $Q$ cubierta por el sitio. Las observaciones externas admitidas participan en los ajustes bajo la hipótesis de que sus relaciones entre amplitud, distancia y carga son transferibles fuera de la envolvente local. Cada respuesta utiliza las observaciones admisibles que disponen de esa medición. La evidencia procede de esas observaciones, mientras la malla cartesiana de $D$ y $Q$ establece el dominio donde se evalúan las superficies de amplitud.

Las covariables $\mathbf{x}(D,Q)$ combinan $D$, $Q$, la distancia escalada $S=D/\sqrt Q$ y sus transformaciones. Cada respuesta $Y_j$ se ajusta como $Z_j=\log_{10}Y_j$ mediante regresión lineal generalizada, modelos aditivos con splines, regresión adaptativa multivariante por tramos [@friedman1991], potenciación de gradiente [@friedman2001] y bosques aleatorios [@breiman2001]. La validación cruzada produce las predicciones fuera de pliegue (*out-of-fold*, OOF) [@kohavi1995]. Las familias con una raíz del error cuadrático medio OOF positiva y finita participan en el ensamble con pesos inversamente proporcionales a esa métrica:

$$
w_{jk}=
\frac{\left(\mathrm{RMSE}^{\mathrm{OOF}}_{jk}\right)^{-1}}
{\displaystyle\sum_{h=1}^{K_j}
\left(\mathrm{RMSE}^{\mathrm{OOF}}_{jh}\right)^{-1}},
\qquad
\widehat Z_j(\mathbf{x})=
\sum_{k=1}^{K_j}w_{jk}\,\widehat f_{jk}(\mathbf{x}).
$$

En esta expresión, $K_j$ es el número de familias participantes para la respuesta $j$, $\mathrm{RMSE}^{\mathrm{OOF}}_{jk}$ es el error OOF de la familia $k$, $\widehat f_{jk}$ es su predicción en escala $\log_{10}$ y $w_{jk}$ es su peso normalizado.

El refinamiento multirrespuesta parte de la formulación $t=0$, basada en $\mathbf{x}(D,Q)$, y evalúa iteraciones condicionales Jacobi $t=1,\ldots,T$, donde $T$ es el número máximo de iteraciones evaluadas. Para la respuesta $Y_j$, cada iteración incorpora las predicciones OOF de las respuestas acompañantes obtenidas en la iteración precedente; sobre la malla incorpora sus predicciones $p50$. La selección se realiza por respuesta: se retiene la iteración $t_j^*$ con mayor $R^2$ OOF sobre los $N_{j,t}$ pares correspondientes. En consecuencia, las componentes de $\widehat{\mathbf{Y}}$ pueden proceder de iteraciones distintas.

Los residuos OOF de la iteración retenida proporcionan los desplazamientos empíricos utilizados para obtener las superficies $p50$, $p90$ y $p95$ en unidades físicas. Estos niveles caracterizan la distribución residual agregada de cada respuesta en la población evaluada. La generación de escenarios utiliza las superficies PPV longitudinal, transversal y vertical para escalar las historias; PPA permanece en la evaluación de desempeño y en el refinamiento multirrespuesta.

## Candidate Public Summary -- Scenarios

La generación de escenarios combina las amplitudes PPV predichas con las formas temporales de la base instrumental. Cada escenario se identifica mediante la distancia fuente--receptor $D$, la carga instantánea máxima $Q$ y el nivel predictivo $p$, y reúne realizaciones que comparten los objetivos PPV longitudinal, transversal y vertical y conservan la diversidad temporal y espectral de los registros fuente. El nivel $p$ identifica el cuantil residual utilizado para asignar amplitud.

Las amplitudes objetivo se obtienen de las superficies PPV en unidades físicas. Las consultas interiores a la malla se interpolan en distancia y carga; el dominio de generación queda acotado por su envolvente. Para el registro $r$ y la componente $c$, el factor aplicado a la terna procesada es

$$
\lambda_{r,c}(D,Q,p)=
\frac{\mathrm{PPV}^{\ast}_c(D,Q,p)}
     {\max_t|v_{r,c}(t)|}.
$$

El mismo factor multiplica aceleración, velocidad y desplazamiento de cada componente, fija la velocidad pico en el objetivo y conserva la coherencia cinemática de la historia. El par horizontal L/T ya escalado se rota a H1/H2 mediante la dirección principal de la covarianza de aceleraciones; la componente vertical se conserva como UP. Cada realización entrega historias H1/H2/UP, medidas de intensidad y espectros de pseudoaceleración con 5 % de amortiguamiento.

La verificación comprueba la reproducción de la PPV vertical, la invariancia de la norma cuadrática horizontal bajo la rotación y una PGA positiva en las tres componentes resultantes. Estas comprobaciones acreditan la construcción numérica de las realizaciones. Cada una conserva además la identidad del registro fuente, la condición $D$--$Q$--$p$, los objetivos PPV y los productos temporales y espectrales que permiten relacionarla con la respuesta posterior del modelo dinámico.

## Open Gaps

1. Resultados frescos y aceptados de `model`.
2. Configuración y familia fresca aceptada de `scenarios`.
3. Párrafos ejecutivos parametrizados y resultados detallados para ambos.
4. Render registrado y lectura integral después de conectar resultados.

## Validation

- Cada afirmación del candidato se desarrolla en el cuerpo correspondiente.
- Cero definiciones matemáticas que sólo pertenecen a la metodología.
- Una ecuación portante en `model` y una en `scenarios`, ambas sin label.
- Cero cardinalidades rígidas de respuestas, iteraciones o escenarios.
- Cero resultados heredados.

