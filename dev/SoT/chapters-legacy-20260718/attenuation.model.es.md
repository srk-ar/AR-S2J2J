Para una respuesta positiva $Y$, el ajuste se realiza en el dominio logarítmico,

$$
\log_{10} Y \mid \mathbf{x} = \eta_Y(\mathbf{x})+\varepsilon_Y,
$$ {#eq-amplitude-log-response}

donde $\eta_Y(\mathbf{x})$ representa la log-amplitud media condicional. Para cada respuesta se ajustan regresión lineal, modelos aditivos con splines, regresión adaptativa multivariante por tramos, *gradient boosting* y *random forest*. La diversidad de familias permite representar superficies de atenuación con distinta curvatura sin imponer una única ley funcional.

La selección de hiperparámetros y la evaluación utilizan validación cruzada de cinco particiones. Cada observación recibe una predicción producida por un ajuste que no utilizó esa observación. A partir de estas predicciones fuera de muestra se calcula el RMSE de cada familia y se definen los pesos normalizados del ensamble:

$$
w_k =
\frac{\mathrm{RMSE}_k^{-1}}
     {\sum_{h=1}^{K}\mathrm{RMSE}_h^{-1}},
\qquad
\widehat{\eta}^{\mathrm{ens}}_Y(\mathbf{x})=
\sum_{k=1}^{K}w_k\widehat{\eta}^{(k)}_Y(\mathbf{x}).
$$ {#eq-amplitude-rmse-ensemble}

Los pesos, los residuos y las métricas se estiman con evidencia fuera de muestra. Una vez fijadas las configuraciones, cada modelo se reajusta con todas las observaciones disponibles para predecir la malla. De este modo, las predicciones finales utilizan la información completa sin contaminar la evidencia empleada para comparar modelos y caracterizar el error predictivo.

El modelo independiente se extiende mediante una regresión condicional de múltiples respuestas. Para estimar $Y_j$, el conjunto de predictores se amplía con estimaciones de las otras respuestas:

$$
\mathbf{x}^{(t)}_j =
\left[
\mathbf{x},\
\widehat{\mathbf{Y}}_{\setminus j}^{(t-1)}
\right],
\qquad
\widehat{Y}^{(t)}_j =
f_j\!\left(\mathbf{x}^{(t)}_j\right).
$$ {#eq-amplitude-conditional-response}

Para las observaciones, las respuestas acompañantes son predicciones fuera de muestra; para la malla son las predicciones medianas de la iteración anterior. Nunca se incorporan como covariables los valores observados de las respuestas acompañantes. El barrido utilizado es Jacobi: las ocho respuestas se actualizan simultáneamente a partir de un estado congelado de la iteración previa, con un presupuesto de hasta tres iteraciones condicionales.

La iteración inicial corresponde al modelo independiente. Después del refinamiento, cada respuesta conserva la iteración —independiente o condicional— que alcanza el mayor $R^2$ fuera de muestra; el efecto del condicionamiento sobre cada familia de respuestas se cuantifica en los resultados de este capítulo. Las predicciones, los residuos, las métricas y los cuantiles se ensamblan desde esa misma iteración, evitando combinar productos estadísticos procedentes de estados diferentes.

Las predicciones PPV longitudinal, transversal y vertical constituyen las amplitudes objetivo para el escalamiento de historias temporales. PPA permanece como una respuesta reportada del modelo de vibraciones y participa en la estimación condicional, pero no fija los factores de escala de los escenarios.
