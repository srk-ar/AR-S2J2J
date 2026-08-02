# report-E80-D3-model-selection-vector-response-20260718

## Section

Blast report / E80-D3 — formulación vectorial y registro profesional de la
selección multirrespuesta.

## Report Purpose

Corregir el candidato E80-D2 según el veto del usuario: retirar las
cardinalidades rígidas «otras siete» y «ocho respuestas», usar el vector general
de respuestas y sustituir la frase hipotética sobre variación del soporte por
la definición directa del conjunto OOF empleado en las métricas.

## Sources Read

- Veto editorial del usuario del 2026-07-18.
- `dev/research/blast-report/report-E80-D2-model-selection-paragraph-20260718.md`,
  conservado sin modificaciones.
- `_chapters/model.es.md`.
- Código y documentación oficiales de `ssel::chainPipeline()`, en sólo lectura.

## Exact Claims Allowed

- El vector de respuestas se expresa como
  `Y=(Y_1,...,Y_n)^T`; para una respuesta `j`, `Y_-j` representa las restantes.
- La iteración `t=0` utiliza las covariables de voladura `x(D,Q)` sin
  predicciones de otras respuestas.
- Las iteraciones condicionales Jacobi incorporan las predicciones OOF de
  `Z_-j` obtenidas en la iteración anterior.
- Las métricas se calculan sobre los `N_(j,t)` pares OOF disponibles para la
  respuesta y la iteración correspondientes.
- La iteración retenida maximiza R2 OOF por respuesta.
- Las predicciones, residuos y cuantiles de una respuesta provienen de su misma
  iteración retenida.

## Claims Not Allowed

- Cardinalidades rígidas del vector de respuestas dentro de la formulación.
- «Puede variar» o «se presentará» como sustituto de la operación ejecutada.
- «Soporte» sin definir el conjunto de pares que interviene en la métrica.
- «Estado», «capa» o «grado de refinamiento» sin notación.
- Una única iteración común impuesta al vector completo.

## Equations Allowed

- `Y=(Y_1,...,Y_n)^T`, `Z=log10(Y)` y `Z_-j`.
- RMSE OOF, R2 OOF y `t_j^*` con `N_(j,t)` para el número de pares OOF.
- Cuantiles `p50`, `p90` y `p95` asociados con la respuesta retenida.

## Equations Excluded

- Los números ocho y siete como parte de la definición general.
- Criterios internos de parada y convergencia.
- Una ecuación de mejora no sustentada por resultados frescos.

## Vocabulary Allowed

- vector de respuestas; respuesta acompañante; iteración no condicionada;
  iteración condicional Jacobi; predicción OOF; par OOF; RMSE OOF; R2 OOF;
  iteración retenida; superficie distancia--carga; residuo; cuantil predictivo.

## Vocabulary Rejected

- producto final; estado; layer; grado de refinamiento; otras siete respuestas;
  ocho respuestas; soporte potencial; podría; se presentará.

## Candidate Public Paragraph Or Section

Sea $\mathbf{Y}=(Y_1,\ldots,Y_n)^{\mathsf T}$ el vector de respuestas del
modelo y $\mathbf{Z}=\log_{10}\mathbf{Y}$ su representación en la escala de
ajuste. Para la respuesta $Y_j$, la iteración $t=0$ corresponde al ensamble
condicionado por las covariables de voladura $\mathbf{x}(D,Q)$. En cada
iteración condicional Jacobi $t=1,\ldots,T$, las predicciones OOF
$\widehat{\mathbf{Z}}_{-j}^{\mathrm{OOF},(t-1)}$ de las respuestas acompañantes
se incorporan como covariables. El desempeño de la formulación $(j,t)$ se
cuantifica mediante
$\mathrm{RMSE}^{\mathrm{OOF}}_{j,t}=\{N_{j,t}^{-1}\sum_i[z_{ij}-\widehat
z_{ij}^{\mathrm{OOF},(t)}]^2\}^{1/2}$ y
$R_{j,t}^{2,\mathrm{OOF}}=\operatorname{Cor}^2(z_{ij},\widehat
z_{ij}^{\mathrm{OOF},(t)})$, calculados sobre los $N_{j,t}$ pares OOF de esa
respuesta e iteración.

Para cada respuesta $Y_j$ se retiene la iteración
$t_j^*=\operatorname*{arg\,max}_{t\in\{0,\ldots,T\}}
R_{j,t}^{2,\mathrm{OOF}}$. Si $t_j^*=0$, la formulación retenida utiliza
únicamente $\mathbf{x}(D,Q)$; si $t_j^*>0$, utiliza además las predicciones de
las respuestas acompañantes generadas por la iteración anterior. La selección
por respuesta permite que las componentes de $\widehat{\mathbf{Y}}$ provengan
de iteraciones distintas. La superficie $\widehat Y_j(D,Q)$, los residuos OOF
y los cuantiles predictivos empíricos $p50$, $p90$ y $p95$ se obtienen de la
iteración $t_j^*$ correspondiente.

## Candidate Translation Terminology

None. El español continúa como texto master.

## Open Gaps

1. Veto del usuario sobre el candidato E80-D3.
2. Fijar o parametrizar el valor aplicado de `T` cuando se acepte la corrida
   fresca.
3. Hidratar después los valores efectivos de `N_(j,t)`, métricas e iteraciones
   retenidas en Resultados.
4. Auditar el resumen sólo después del cierre del cuerpo y sus resultados.

## Validation

- Cero cardinalidades rígidas del vector de respuestas.
- Cada métrica identifica escala, predicción OOF y número de pares utilizados.
- La selección se define por respuesta y se conecta con los productos
  estadísticos que realmente se reportan.
- Cero condicionales hipotéticos sobre el comportamiento de la corrida.
- Sin edición pública, render, datos o SSEL antes del veto.
