Cada escenario de demanda queda definido por una distancia $r$ y una carga instantánea máxima $q$; el modelo de este capítulo fija qué amplitud corresponde a un registro en ese escenario. La relación entre una respuesta positiva $Y$ — una amplitud pico de vibración — y un vector de condiciones $\mathbf{x}$ se plantea con el modelo probabilístico multiplicativo clásico [@AngTang1984; @BenjaminCornell1970]:

$$
Y \mid \mathbf{x} \approx \eta_Y(\mathbf{x})\,\varepsilon_Y,
\qquad
\log_{10} Y \mid \mathbf{x} = \eta^{\log}_Y(\mathbf{x}) + \varepsilon^{\log}_Y ,
$$ {#eq-model-probabilistic}

donde $\eta_Y(\mathbf{x})$ es la mediana condicional de la amplitud para las condiciones $\mathbf{x}$, y $\varepsilon_Y$ es un error multiplicativo cuyo logaritmo tiene media cero: el error estadístico representa variaciones multiplicativas en unidades físicas, que es el comportamiento observado en las amplitudes de vibración.

Los modelos de predicción empleados históricamente en voladuras son paramétricos, con la forma lineal en logaritmos de la ley de distancia escalada [@Langefors1963a]:

$$
\ln \eta_D(r,q) \approx a_0 + b\,\ln r + c\,\ln q ,
$$ {#eq-model-parametric}

donde $a_0$, $b$ y $c$ se calibran por regresión. Este trabajo generaliza esa construcción: conserva la distancia escalada como variable del modelo y estima la superficie de amplitudes con un ensamble de regresión de varias familias funcionales, cuyo desempeño se evalúa con evidencia fuera de muestra.

Las respuestas modeladas son PPV y PPA por componente longitudinal, transversal y vertical, y sus resultantes escalares, definidas como la norma euclídea de los picos por componente:

$$
\mathrm{PPV} =
\sqrt{\mathrm{PPV}_L^2+\mathrm{PPV}_T^2+\mathrm{PPV}_V^2},\qquad
\mathrm{PPA} =
\sqrt{\mathrm{PPA}_L^2+\mathrm{PPA}_T^2+\mathrm{PPA}_V^2}.
$$ {#eq-model-resultants}

Los picos por componente no ocurren en el mismo instante, de modo que la resultante así definida acota por encima al pico del vector de movimiento; es la convención adoptada para toda la base y para el modelo. Las variables explicativas se construyen a partir de la carga $Q$, la distancia $D$ y la distancia escalada $S$, con transformaciones monótonas que permiten representar leyes de atenuación de distinta curvatura:

$$
\mathbf{x}(D,Q)=
\left[
Q,\ \ln Q,\ Q^{-1},\
D,\ \ln D,\ D^{-1},\
S,\ \log_{10} S
\right],
\qquad
S=\frac{D}{\sqrt{Q}} ,
$$ {#eq-model-features}

donde $\ln Q$ y $\ln D$ son logaritmos naturales, $Q^{-1}$ y $D^{-1}$ los recíprocos, y $\log_{10} S$ el logaritmo decimal de la distancia escalada en m/kg$^{1/2}$.

La construcción de la base de entrenamiento enfrenta un problema propio de este sitio: los escenarios de interés incluyen distancias más cercanas y cargas distintas de las observadas en el monitoreo local, y las familias no paramétricas basadas en árboles no extrapolan fuera del soporte de sus datos. La base incorpora por eso registros de un proyecto análogo en geología de roca similar, admitidos únicamente cuando su distancia o su carga quedan fuera de la envolvente cubierta por las observaciones del sitio: dentro de esa envolvente, los registros locales son la única información de entrenamiento, y los externos extienden el soporte físico sin sustituir el nivel de amplitud observado localmente. Esta admisión supone que el nivel de amplitud del proyecto análogo es aplicable fuera de la envolvente local; la hipótesis queda declarada en la definición de la base de entrenamiento. Las unidades de las amplitudes se declaran por registro y se verifican por homogeneidad, y la depuración de la base descarta de la familia de aceleraciones las lecturas incompatibles con una medición: tripletas con las tres componentes ortogonales idénticas y valores exactos repetidos entre registros de una misma fuente.

Para cada respuesta se ajustan cinco familias de regresión — regresión lineal generalizada, modelos aditivos con splines, regresión adaptativa multivariante por tramos, potenciación de gradiente y bosques aleatorios — con validación cruzada de cinco particiones: cada observación recibe una predicción de un ajuste que no la utilizó. Con esas predicciones fuera de muestra se calcula el RMSE de cada familia y se forman los pesos del ensamble:

$$
w_k =
\frac{\mathrm{RMSE}_k^{-1}}
     {\sum_{h=1}^{K}\mathrm{RMSE}_h^{-1}},
\qquad
\widehat{\eta}^{\mathrm{ens}}_Y(\mathbf{x})=
\sum_{k=1}^{K}w_k\,\widehat{\eta}^{(k)}_Y(\mathbf{x}),
$$ {#eq-model-ensemble}

donde $K$ es el número de familias válidas, $\mathrm{RMSE}_k$ el error fuera de muestra de la familia $k$ y $\widehat{\eta}^{(k)}_Y$ su predicción. Fijadas las configuraciones, cada familia se reajusta con todas las observaciones para predecir la malla de escenarios; la evidencia para ponderar y caracterizar el error sigue siendo la de fuera de muestra.

La distancia y la carga, aun transformadas, explican solo una parte de la variabilidad: las condiciones del sitio que no están en la base — litología, trayectorias de propagación, geometría de los frentes — actúan como variables latentes. Las relaciones entre las componentes de PPV y entre las familias de PPV y PPA portan esa información, y el modelo la aprovecha mediante una regresión condicional de múltiples respuestas: para estimar la respuesta $Y_j$, el conjunto de predictores se amplía con las estimaciones de las demás respuestas,

$$
\mathbf{x}^{(t)}_j =
\left[\mathbf{x},\ \widehat{\mathbf{Y}}_{\setminus j}^{(t-1)}\right],
\qquad
\widehat{Y}^{(t)}_j = f_j\!\left(\mathbf{x}^{(t)}_j\right),
$$ {#eq-model-conditional}

donde $\widehat{\mathbf{Y}}_{\setminus j}^{(t-1)}$ son las predicciones de las otras respuestas en la iteración anterior. Para las observaciones se usan predicciones fuera de muestra y para la malla las medianas de la iteración previa; los valores observados de las respuestas acompañantes no ingresan nunca como covariables, de modo que el entrenamiento no dispone de información que no existirá al predecir un escenario. Las ocho respuestas se actualizan simultáneamente desde el estado congelado de la iteración previa, con un presupuesto de hasta tres iteraciones condicionales, y cada respuesta conserva la iteración — independiente o condicional — de mayor $R^2$ fuera de muestra, ensamblando desde ella sus predicciones, residuos, métricas y cuantiles. Este aporte condicional es el que eleva el desempeño del modelo por encima del rango típico de los modelos de predicción para voladuras; su efecto se cuantifica en los resultados de este capítulo.

La incertidumbre del modelo se caracteriza empíricamente, sin asumir una forma distribucional del error. Con los residuos del ensamble fuera de muestra, $r_i = \log_{10} Y_i - \log_{10}\widehat{Y}^{\mathrm{OOF}}_i$, la amplitud predictiva al nivel $p$ en cada punto de la malla es

$$
\widehat{Y}_p(D,Q)
= 10^{\,\widehat{Y}^{\log}(D,Q)+\widehat q_p(r)} ,
$$ {#eq-model-quantiles}

donde $\widehat{Y}^{\log}$ es la predicción del ensamble en escala logarítmica y $\widehat q_p(r)$ el cuantil empírico de los residuos. Los niveles exportados son cuantiles predictivos del error observado, no intervalos de confianza paramétricos. Las predicciones de PPV longitudinal, transversal y vertical constituyen las amplitudes objetivo del escalamiento de las realizaciones; PPA permanece como respuesta reportada del modelo y participa de la estimación condicional, pero no fija factores de escala.
