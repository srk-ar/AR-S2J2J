# report-E80-D4-model-summary-crosswalk-20260718

## Section

Blast report / E80-D4 — auditoría body-to-summary del modelo de predicción de
amplitudes.

## Report Purpose

Reauditar `_chapters/model.summary.es.md` contra el cuerpo metodológico cerrado
en E80-D3 y redactar un resumen ejecutivo autónomo, dirigido a especialistas en
geotecnia sísmica, voladuras y aprendizaje automático. La síntesis conserva
las decisiones necesarias para comprender el modelo y sus productos, sin
reproducir la derivación completa del capítulo ni anticipar resultados de la
corrida pendiente.

## Sources Read

- `dev/SoT/ACTIVE.md` y `dev/plan/blast-report/active.md`, con énfasis en E69,
  E72, E79 y E80-D1--D3.
- `_chapters/model.es.md`, incluido el cierre aprobado E80-D3.
- `_chapters/model.summary.es.md`, en modo de sólo lectura.
- `_index/model.ES.qmd` y el inventario vigente de `_summary/`.
- `dev/research/blast-report/report-E80-body-first-summary-crosswalk-20260718.md`.
- `dev/research/blast-report/report-E80-D3-model-selection-vector-response-20260718.md`.
- `garage/style/summary.md` y `garage/style/technical-writing.md`.

## Paragraph-by-Paragraph Crosswalk

1. **Párrafo 1 — indispensable, revisión menor.** Conserva el propósito, las
   familias PPV/PPA, las componentes L/T/V y el papel exclusivo de PPV en el
   escalamiento. Se elimina cualquier lectura de PPA como objetivo de escala;
   su función queda en la caracterización de amplitudes y el refinamiento
   multirrespuesta.
2. **Párrafo 2 — indispensable, condensar y concretar.** La población local, la
   admisión exterior y la hipótesis de transferencia controlan el alcance del
   modelo. El resumen debe nombrar S11D, afirmar la operación ejecutada por
   respuesta y distinguir evidencia observada de malla de evaluación. La frase
   hipotética «puede tener» se reemplaza por la definición efectiva del soporte
   OOF por respuesta.
3. **Párrafos 3--4 y ecuación — ecuación portante, prosa a condensar.** La lista
   de familias y la ponderación inversa a RMSE OOF explican la construcción del
   ensamble. La ecuación se conserva porque identifica simultáneamente el
   criterio de peso y la predicción combinada. Se omite la enumeración completa
   de transformaciones de predictores, ya desarrollada en Metodología; en el
   resumen basta identificar $D$, $Q$, $S=D/\sqrt Q$ y sus transformaciones.
4. **Párrafo 5 — decisivo, reemplazo completo.** «Estado independiente», «hasta
   tres estados» y «la comparación no presupone una mejora» no describen la
   selección ejecutada. El reemplazo define $t=0$, las iteraciones Jacobi
   $t=1,\ldots,T$, el uso diferenciado de predicciones OOF y $p50$, y la
   retención por respuesta de la iteración con mayor $R^2$ OOF sobre
   $N_{j,t}$ pares. La regla se expresa en prosa técnica y notación inline, sin
   reproducir las ecuaciones completas del cuerpo.
5. **Párrafo 6 — indispensable, condensar.** Los cuantiles residuales
   $p50/p90/p95$ explican las superficies en unidades físicas y su alcance
   estadístico. Se reemplaza la advertencia por negación y la instrucción al
   lector por una definición afirmativa de la distribución residual agregada.
6. **Resultado ejecutivo — ausente y bloqueado.** El resumen final requiere un
   párrafo hidratado con población y soporte, desempeño OOF, iteración retenida
   por respuesta, efecto del condicionamiento y dominio de las superficies.
   No existe una corrida fresca aceptada que autorice esos valores.

## Exact Claims Allowed

- El modelo asigna PPV y PPA por componente y resultante a condiciones de
  distancia fuente--receptor y carga instantánea máxima.
- Las predicciones PPV L/T/V fijan la escala de las historias temporales; PPA
  integra la caracterización de amplitudes y el refinamiento multirrespuesta.
- La población combina observaciones locales y S11D admitida fuera de la
  envolvente rectangular local en $D$ y $Q$, bajo una hipótesis explícita de
  transferencia.
- Cada respuesta se ajusta con sus observaciones admisibles y dispone de su
  propio conjunto de pares OOF.
- Las familias candidatas son regresión lineal generalizada, modelos aditivos
  con splines, regresión adaptativa multivariante por tramos, potenciación de
  gradiente y bosques aleatorios.
- Las familias válidas se ponderan por el inverso de su RMSE OOF en escala
  $\log_{10}$.
- La iteración $t=0$ utiliza las covariables de voladura; las iteraciones
  condicionales Jacobi incorporan predicciones de respuestas acompañantes.
- Para cada respuesta se retiene la iteración con mayor $R^2$ OOF, calculado
  sobre los $N_{j,t}$ pares correspondientes a esa respuesta e iteración.
- Los cuantiles $p50$, $p90$ y $p95$ se obtienen de residuos OOF de la
  iteración retenida y representan la distribución residual agregada de cada
  respuesta en la población evaluada.

## Claims Not Allowed

- Fijar en el resumen una cardinalidad rígida del vector de respuestas o del
  número de iteraciones condicionales.
- Presentar la ecuación del ensamble como descripción completa del modelo.
- Afirmar que el condicionamiento mejora el desempeño, identificar iteraciones
  retenidas o publicar métricas antes de la corrida fresca aceptada.
- Transferir cifras, pesos, soportes, métricas o superficies de las corridas de
  junio/julio.
- Describir la malla como evidencia o usar PPA para fijar el factor de escala
  de las historias.
- Prometer resultados, remitir al cuerpo o instruir al lector sobre cómo debe
  interpretar el modelo.

## Equations Allowed

- La ecuación conjunta de pesos inversos a RMSE OOF y predicción del ensamble,
  sin label y con todos sus símbolos definidos.
- Notación inline $S=D/\sqrt Q$, $Z_j=\log_{10}Y_j$, $t=0$,
  $t=1,\ldots,T$, $N_{j,t}$, $R^2$ OOF y $p50/p90/p95$.

## Equations Excluded

- Normas de las resultantes PPV/PPA y vector completo de transformaciones.
- Ecuación de actualización Jacobi; su operación se describe en una frase.
- Fórmulas completas de RMSE, $R^2$, selección `arg max`, residuos y cuantiles;
  la precisión necesaria queda en la notación y en el criterio declarado.
- Criterios internos de parada, convergencia o implementación.

## Vocabulary Allowed

- distancia fuente--receptor; carga instantánea máxima; PPV; PPA; componente
  L/T/V; resultante; población local; S11D; envolvente local; hipótesis de
  transferencia; predicción fuera de pliegue; OOF; RMSE OOF; ensamble;
  iteración no condicionada; iteración condicional Jacobi; respuesta
  acompañante; $R^2$ OOF; par OOF; iteración retenida; cuantil predictivo
  empírico; superficie distancia--carga.

## Vocabulary Rejected

- producto final; estado; layer; grado de refinamiento; otras siete respuestas;
  ocho respuestas; hasta tres estados; puede mejorar; modelo aceptado; soporte
  potencial; véase el capítulo; se detallará; se presentará.

## Candidate Public Paragraph Or Section

El modelo de amplitudes asigna niveles de velocidad pico de partícula (PPV) y aceleración pico de partícula (PPA) a cada condición de distancia fuente–receptor $D$ y carga instantánea máxima $Q$. Las respuestas comprenden las componentes longitudinal, transversal y vertical, y la resultante escalar de cada familia. Las predicciones PPV por componente fijan la escala de las historias temporales de escenario; PPA completa la caracterización de amplitudes e interviene en el refinamiento multirrespuesta.

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

## Candidate Translation Terminology

None. El español permanece como texto master; no se genera espejo EN en esta
tanda.

## Open Gaps

1. Aprobación o veto del usuario sobre el candidato completo.
2. Corrida fresca y aceptada del modelo mediante el flujo autorizado.
3. Párrafo parametrizado de resultados con población y $N$, desempeño OOF en
   escala y unidades declaradas, iteración retenida por respuesta, efecto del
   condicionamiento y dominio de las superficies.
4. Resultados detallados que desarrollen la misma evidencia antes de declarar
   final el resumen ejecutivo.
5. Ensamblado, render registrado y lectura integral del capítulo sólo después
   de migrar texto aprobado e hidratar resultados vigentes.

## Validation

- Los seis bloques del candidato se trazan directamente al cuerpo metodológico
  E80-D3.
- La ecuación conservada cumple una función ejecutiva única: define la
  combinación de familias; todos sus símbolos se definen inmediatamente.
- La selección multirrespuesta queda explicada sin repetir la ecuación Jacobi,
  las fórmulas de métricas ni la derivación de cuantiles.
- Cero cardinalidades rígidas del vector de respuestas o de iteraciones
  condicionales.
- Cero cifras, pesos, métricas, iteraciones retenidas o mejoras heredadas.
- Cero edición de `_chapters/model.summary.es.md`, resultados, datos, scripts o
  SSEL; cero render.
