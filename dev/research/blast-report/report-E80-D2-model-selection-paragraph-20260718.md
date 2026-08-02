# report-E80-D2-model-selection-paragraph-20260718

## Section

Blast report / E80-D2 — selección por respuesta de la iteración
multirrespuesta.

## Report Purpose

Reformular el candidato de E80 con precisión suficiente para una audiencia
experta en geotecnia sísmica, voladuras y aprendizaje automático. El usuario
aprobó el contenido general, pero rechazó la ambigüedad de «producto final»,
«cada estado» y «grados de refinamiento», y solicitó notación LaTeX inline para
RMSE, R2 y OOF.

## Sources Read

- Ruling editorial del usuario del 2026-07-18.
- `_chapters/model.es.md`.
- `scripts/runChain.R`, en sólo lectura.
- Código y documentación oficiales de `ssel::chainPipeline()`, en sólo lectura:
  iteración independiente `t=0`, hasta tres iteraciones condicionales Jacobi y
  selección por respuesta mediante el máximo R2 OOF.
- `dev/research/blast-report/report-E80-body-first-summary-crosswalk-20260718.md`.

No se ejecutó el modelo, no se leyó una corrida nueva y no se editó SSEL.

## Exact Claims Allowed

- `t=0` es el ensamble sin covariables de respuestas acompañantes y utiliza la
  representación `x(D,Q)` definida previamente.
- `t=1,2,3` son las iteraciones condicionales Jacobi; en las filas observadas
  incorporan predicciones OOF de las otras siete respuestas.
- RMSE OOF y R2 OOF se evalúan en la escala `log10` modelada.
- El R2 implementado es el cuadrado de la correlación entre observaciones y
  predicciones OOF.
- El soporte `n_(j,t)` puede variar entre respuesta e iteración y debe
  acompañar las métricas.
- Para cada respuesta se retiene la iteración que maximiza R2 OOF; no se impone
  una misma iteración a las ocho respuestas.
- Superficies, residuos OOF y cuantiles empíricos deben provenir de la misma
  iteración retenida para esa respuesta.

## Claims Not Allowed

- «Producto final» sin identificar la salida ingenieril o estadística.
- «Estado», «capa» o «grado de refinamiento» sin definir `t` y las covariables
  que diferencian cada iteración.
- Afirmar que una iteración condicional mejora todas las respuestas.
- Afirmar qué iteración fue retenida antes de la corrida fresca.
- Presentar R2 como `1-SSE/SST`; la implementación usa correlación al cuadrado.
- Comparar métricas sin declarar la escala y el soporte.

## Equations Allowed

Las métricas OOF en la escala modelada y la selección por respuesta:

$$
\mathrm{RMSE}^{\mathrm{OOF}}_{j,t}
=\left[
\frac{1}{n_{j,t}}\sum_{i=1}^{n_{j,t}}
\left(z_{ij}-\widehat z_{ij}^{\mathrm{OOF},(t)}\right)^2
\right]^{1/2},
\qquad
R_{j,t}^{2,\mathrm{OOF}}
=\operatorname{Cor}^2\!\left(
z_{ij},\widehat z_{ij}^{\mathrm{OOF},(t)}
\right),
$$

$$
t_j^*=\operatorname*{arg\,max}_{t\in\{0,1,2,3\}}
R_{j,t}^{2,\mathrm{OOF}}.
$$

En el candidato público estas relaciones se integran en línea para mantener el
flujo del capítulo; pueden ascenderse a display si la lectura ensamblada resulta
demasiado densa.

## Equations Excluded

- Criterios internos de convergencia, tolerancia, paciencia y divergencia: no
  son necesarios para identificar la formulación retenida en este párrafo.
- Una ecuación de «mejora» porque todavía no existe resultado fresco aceptado.
- Notación de software para snapshots, rutas o archivos.

## Vocabulary Allowed

- ensamble no condicionado; iteración condicional Jacobi; respuesta
  acompañante; predicción OOF; RMSE OOF; R2 OOF; escala `log10`; soporte;
  iteración retenida; formulación adoptada; superficie distancia--carga;
  distribución residual; cuantil predictivo empírico.

## Vocabulary Rejected

- producto final; estado sin definición; layer; grado de refinamiento; modelo
  mejorado sin resultado; salida del pipeline; snapshot; stitch; artefacto.

## Candidate Public Paragraph Or Section

Para cada respuesta $Y_j$, la iteración $t=0$ corresponde al ensamble no
condicionado, ajustado únicamente con el vector $\mathbf{x}(D,Q)$, mientras
$t=1,2,3$ corresponden a las iteraciones condicionales Jacobi, en las que las
predicciones OOF de las otras siete respuestas se incorporan como covariables
en las filas observadas. El desempeño se evalúa en la escala modelada
$z_{ij}=\log_{10}Y_{ij}$ mediante
$\mathrm{RMSE}^{\mathrm{OOF}}_{j,t}=\{n_{j,t}^{-1}\sum_i[z_{ij}-\widehat
z_{ij}^{\mathrm{OOF},(t)}]^2\}^{1/2}$ y
$R_{j,t}^{2,\mathrm{OOF}}=\operatorname{Cor}^2(z_{ij},\widehat
z_{ij}^{\mathrm{OOF},(t)})$. Cada comparación se presenta junto con su soporte
$n_{j,t}$, que puede cambiar cuando una respuesta acompañante no está disponible
para todas las observaciones.

La formulación adoptada para la respuesta $j$ corresponde a
$t_j^*=\operatorname*{arg\,max}_{t\in\{0,1,2,3\}}
R_{j,t}^{2,\mathrm{OOF}}$. Cuando $t_j^*=0$, la predicción conserva el ensamble
basado exclusivamente en las variables de distancia y carga; cuando
$t_j^*>0$, incorpora las predicciones acompañantes de la iteración condicional
seleccionada. La selección se realiza independientemente para las ocho
respuestas, y las superficies distancia--carga, los residuos OOF y los
cuantiles predictivos empíricos $p50$, $p90$ y $p95$ de cada respuesta se
obtienen de su correspondiente iteración $t_j^*$.

## Candidate Translation Terminology

None. El español continúa como texto master.

## Open Gaps

1. Veto del usuario sobre estos dos párrafos y su densidad matemática.
2. Confirmar en la corrida fresca los soportes por respuesta e iteración y la
   iteración retenida; no hardcodear resultados.
3. Decidir durante la lectura ensamblada si las métricas quedan inline o en un
   display único.
4. Recién después completar Resultados y auditar el resumen ejecutivo.

## Validation

- Cada símbolo queda definido en el propio bloque o en la formulación
  inmediatamente anterior del capítulo.
- Se distingue explícitamente ensamble no condicionado de iteración
  condicional.
- Se nombra OOF y se identifica la escala de las métricas.
- Se declara el soporte variable y la selección por respuesta.
- Cero resultado inventado, lenguaje de software o afirmación universal de
  mejora.
- Sin edición pública, render, datos o SSEL antes del veto.
