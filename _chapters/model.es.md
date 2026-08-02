El propósito de este capítulo es establecer el componente predictivo multirrespuesta que relaciona la distancia fuente--receptor y la carga instantánea máxima con la velocidad y la aceleración pico de partícula. La formulación define la población y el dominio de aplicación, representa las condiciones de voladura, combina familias de aprendizaje mediante evidencia fuera de muestra, incorpora la dependencia entre respuestas y caracteriza el error predictivo. Las predicciones de PPV longitudinal, transversal y vertical fijan la amplitud de las historias procesadas utilizadas en los escenarios; las predicciones de PPA completan la caracterización de la demanda y participan en el refinamiento multirrespuesta.

La población local reúne las voladuras del sitio que disponen de distancia fuente--receptor, carga instantánea máxima y una familia completa de componentes PPV o PPA. Las amplitudes de PPV se expresan en $\mathrm{mm/s}$ y las de PPA en $g$. Cada respuesta por componente se estima con las observaciones que disponen de esa medición, mientras las resultantes requieren las tres componentes; por ello, el número de observaciones disponibles puede diferir entre respuestas.

La fuente complementaria S11D aporta observaciones situadas fuera de la envolvente rectangular cubierta por el sitio: su distancia queda fuera del intervalo local de distancias, su carga queda fuera del intervalo local de cargas, o ambas condiciones se cumplen. Dentro de la envolvente se utiliza exclusivamente la información local. Las observaciones externas admitidas participan en los ajustes globales bajo la hipótesis de que sus relaciones entre amplitud, distancia y carga son transferibles a partir de las observaciones situadas fuera de la envolvente local.

El control de calidad de PPA excluye las tripletas con valores exactamente iguales en las tres componentes ortogonales y los valores exactos de una componente repetidos en diez o más distancias distintas dentro de una misma fuente. Estos patrones no son compatibles con mediciones independientes de las componentes de aceleración. La exclusión se limita a la medición PPA afectada; las mediciones PPV de la misma observación se conservan.

Las predicciones se evalúan sobre una malla cartesiana de distancia y carga con la misma representación de covariables empleada en el ajuste. La malla delimita las condiciones consultadas, no aporta observaciones adicionales ni extiende el dominio observado. La generación de escenarios utiliza el subconjunto correspondiente a las condiciones operativas seleccionadas.

Las respuestas modeladas son PPV y PPA en las componentes longitudinal, transversal y vertical, junto con una resultante escalar para cada familia. La resultante de velocidad se define como

$$
\mathrm{PPV}=
\sqrt{\mathrm{PPV}_L^2+\mathrm{PPV}_T^2+\mathrm{PPV}_V^2}.
$$ {#eq-model-ppv-resultant}

La resultante de aceleración se define de manera análoga:

$$
\mathrm{PPA}=
\sqrt{\mathrm{PPA}_L^2+\mathrm{PPA}_T^2+\mathrm{PPA}_V^2}.
$$ {#eq-model-ppa-resultant}

Esta convención utiliza la norma de los tres picos por componente. Como esos picos no necesariamente ocurren en el mismo instante, la resultante no representa el máximo temporal del vector de movimiento; constituye una medida escalar común para la base y para el modelo.

Las condiciones de voladura se representan mediante la carga instantánea máxima, la distancia fuente--receptor y la distancia escalada. Sea $\mathbf X\sim F_{\mathbf X}$ el vector aleatorio de covariables. Para la observación $j$, sus valores realizados son $q_j$, $d_j$, $\mathrm{SD}_j=d_j/\sqrt{q_j}$ y $\mathbf x_j=\mathbf x(d_j,q_j)$. La misma función construye las covariables de cada punto $(d,q)$ de la malla, con $\mathrm{SD}=d/\sqrt q$:

$$
\mathbf{x}(d,q)=
\left[
q,\ \ln q,\ q^{-1},\
d,\ \ln d,\ d^{-1},\
\mathrm{SD},\ \log_{10}\mathrm{SD}
\right]^{\mathsf T}.
$$ {#eq-model-features}

La carga $q$ se expresa en kg y la distancia $d$ en m, por lo que $\mathrm{SD}$ queda en $\mathrm{m/kg^{1/2}}$. La distancia escalada se incorpora como referencia convencional de las relaciones de amplitud por voladura [@Langefors1963a]. Los términos $\ln q$ y $\ln d$ son logaritmos naturales; $\log_{10}\mathrm{SD}$ es decimal. La formulación conserva además $d$, $q$ y sus transformaciones, de modo que el ajuste representa por separado los efectos de distancia y carga en vez de concentrarlos en una única coordenada.

Sea $h=1,\ldots,m$ el índice del tipo o componente de respuesta y $j=1,\ldots,n_h$ el índice de observación. Para la variable aleatoria positiva $Y^{(h)}\sim F_{Y,h}$, la transformación logarítmica define $Z^{(h)}=\log_{10}Y^{(h)}$. El objeto predictivo es su distribución condicional:

$$
Z^{(h)}\mid\mathbf X=\mathbf x
\sim
F_{Z^{(h)}\mid\mathbf X}\!\left(\,\cdot\mid\mathbf x\right).
$$ {#eq-model-conditional-distribution}

Su realización observada se expresa como

$$
z_j^{(h)}=\log_{10}y_j^{(h)}.
$$ {#eq-model-log-response}

El ajuste produce un estimador puntual $\widehat z^{(h)}(\mathbf x)$ en la escala $\log_{10}$. La incertidumbre predictiva se representa posteriormente mediante la distribución empírica agregada de los residuos OOF de cada respuesta, de la cual se obtienen los niveles $p50$, $p90$ y $p95$.

Las familias candidatas abarcan una relación lineal global, funciones aditivas suaves, regresiones adaptativas multivariantes por tramos [@friedman1991], potenciación de gradiente [@friedman2001] y bosques aleatorios [@breiman2001]. Para cada familia, las configuraciones candidatas se comparan mediante la raíz del error cuadrático medio (RMSE) de las predicciones fuera de pliegue (*out-of-fold*, OOF), obtenidas por validación cruzada de cinco particiones [@kohavi1995]. En cada predicción OOF, la observación evaluada pertenece a la partición excluida del ajuste que la predice; la asignación de particiones se realiza dentro de cada familia.

La configuración con menor RMSE se reajusta con todas las observaciones disponibles para la respuesta. Sus predicciones OOF se conservan para determinar el desempeño de la familia, los pesos del ensamble y la distribución residual empleada en la caracterización del error predictivo.

En términos probabilísticos, el desempeño se refiere al error de generalización de $\widehat z^{(h)}$. Sobre la población de aplicación, su escala cuadrática es $\mathrm{RMSE}_h=\{\operatorname E[(Z^{(h)}-\widehat z^{(h)}(\mathbf X))^2]\}^{1/2}$ y se estima mediante los pares OOF. En este estudio, el RMSE conserva la unidad $\log_{10}$ de la respuesta modelada y penaliza con mayor intensidad los errores de mayor magnitud. El $R^2$ reportado es la correlación de Pearson al cuadrado entre las observaciones y sus predicciones OOF: cuantifica su correspondencia lineal, pero no corrige por sí solo un sesgo ni una descalibración. Por ello, RMSE y $R^2$ describen aspectos complementarios del desempeño predictivo.

Las predicciones OOF proporcionan el régimen de evaluación común porque cada observación es predicha por un ajuste que la excluyó. Esta separación impide que los residuos de ajuste de esa misma observación se utilicen como evidencia de generalización y reduce el optimismo que favorecería a familias capaces de reproducir variaciones particulares de la muestra. La selección de configuraciones, la ponderación del ensamble, la elección de la iteración multirrespuesta y la distribución residual utilizada para los niveles predictivos se sustentan así en predicciones obtenidas fuera del ajuste que produjo cada valor.

El conjunto $\mathcal K_h$ reúne las familias estimadas para la respuesta $h$. El ensamble asigna mayor peso a las familias con menor RMSE OOF; los pesos se estiman por respuesta:

$$
\widehat w_{hk}=
\frac{
\left(\widehat{\mathrm{RMSE}}_{hk}^{\mathrm{OOF}}\right)^{-1}
}{
\displaystyle\sum_{\ell\in\mathcal K_h}
\left(\widehat{\mathrm{RMSE}}_{h\ell}^{\mathrm{OOF}}\right)^{-1}
}.
$$ {#eq-model-ensemble-weights}

La predicción del ensamble es

$$
\widehat z^{(h)}(\mathbf x)=
\sum_{k\in\mathcal K_h}
\widehat w_{hk}\,\widehat f_{hk}(\mathbf x).
$$ {#eq-model-ensemble}

Aquí $\widehat f_{hk}$ es la predicción de la familia $k$ para la respuesta $h$ en escala $\log_{10}$. Los pesos suman uno. La evidencia fuera de muestra determina la ponderación y la caracterización posterior del error; una vez fijada la configuración de cada familia, el ajuste que predice la malla utiliza todas las observaciones disponibles para esa respuesta.

Sea $\mathbf Y=(Y^{(1)},\ldots,Y^{(m)})^{\mathsf T}\sim F_{\mathbf Y}$ el vector aleatorio de respuestas y $\mathbf Z=(Z^{(1)},\ldots,Z^{(m)})^{\mathsf T}\sim F_{\mathbf Z}$ su transformación en la escala de ajuste. La dependencia entre respuestas se representa mediante covariables predictivas. Para la respuesta $h$, la iteración $t=0$ utiliza únicamente $\mathbf x$; en cada iteración Jacobi $t=1,\ldots,T$, se incorporan las predicciones $p50$ de las restantes respuestas obtenidas en la iteración anterior [@spyromitros2016chains].

Para las observaciones de entrenamiento, esas covariables son las predicciones OOF desplazadas por el cuantil residual mediano, reunidas en $\widehat{\mathbf z}_{j,0.50,-h}^{\mathrm{OOF},(t-1)}$. En las iteraciones $t>0$, cada fila de ajuste debe disponer de la respuesta $h$ y de las predicciones OOF de todas las respuestas acompañantes; la muestra de ajuste es, por tanto, la intersección definida por esas disponibilidades. Sobre la malla se utilizan las predicciones $\widehat{\mathbf z}_{0.50,-h}^{(t-1)}(\mathbf x)$ de la iteración anterior. La predicción de malla se expresa como

$$
\widehat z^{(h,t)}(\mathbf x)=
\widehat f_h^{(t)}\!\left(
\mathbf x,
\widehat{\mathbf z}_{0.50,-h}^{(t-1)}(\mathbf x)
\right).
$$ {#eq-model-conditional}

La actualización es simultánea: todas las respuestas de la iteración $t$ utilizan el estado fijado en $t-1$. Sea $\mathcal I_{h,t}$ el conjunto de observaciones con predicción OOF y $n_{h,t}=|\mathcal I_{h,t}|$. El RMSE OOF se calcula como

$$
\widehat{\mathrm{RMSE}}_{h,t}^{\mathrm{OOF}}
=
\left\{
\frac{1}{n_{h,t}}
\sum_{j\in\mathcal I_{h,t}}
\left(
z_j^{(h)}-\widehat z_j^{\mathrm{OOF},(h,t)}
\right)^2
\right\}^{1/2}.
$$ {#eq-model-oof-rmse}

El coeficiente de determinación OOF se obtiene a partir de la correlación entre observaciones y predicciones fuera de muestra:

$$
\widehat R_{h,t}^{2,\mathrm{OOF}}
=
\operatorname{Cor}^2\!\left(
\{z_j^{(h)}\}_{j\in\mathcal I_{h,t}},
\{\widehat z_j^{\mathrm{OOF},(h,t)}\}_{j\in\mathcal I_{h,t}}
\right).
$$ {#eq-model-oof-r2}

Para cada respuesta se retiene

$$
t_h^*=
\operatorname*{arg\,max}_{t\in\{0,\ldots,T\}}
\widehat R_{h,t}^{2,\mathrm{OOF}}.
$$ {#eq-model-iteration-selection}

Si $t_h^*=0$, la formulación utiliza únicamente $\mathbf x$; si $t_h^*>0$, incorpora las predicciones $p50$ de las respuestas acompañantes. La selección se realiza separadamente para cada tipo de respuesta; los residuos OOF y los cuantiles predictivos empíricos se obtienen de la iteración retenida.

Para la observación $j$, la respuesta $h$ y la iteración $t$, el residuo del ensamble fuera de muestra es

$$
r_j^{\mathrm{OOF},(h,t)}=
z_j^{(h)}-\widehat z_j^{\mathrm{OOF},(h,t)}.
$$ {#eq-model-oof-residual}

El cuantil residual empírico de nivel $p$ se obtiene mediante

$$
\widehat q_{h,p}^{(t)}=
\operatorname{Quantile}_p\!\left(
\left\{
r_j^{\mathrm{OOF},(h,t)}:
j\in\mathcal I_{h,t}
\right\}
\right).
$$ {#eq-model-residual-quantile}

La predicción en unidades físicas para la condición $(d,q)$ resulta de la transformación inversa:

$$
\widehat y_p^{(h,t)}(d,q)=
10^{\,\widehat z^{(h,t)}(\mathbf x(d,q))+\widehat q_{h,p}^{(t)}},
\quad
p\in\{0.50,0.90,0.95\}.
$$ {#eq-model-quantiles}

Aquí $t=0$ identifica la formulación independiente y $t>0$ una iteración condicional. El nivel 0.50 incorpora la corrección mediana de los residuos OOF; los niveles 0.90 y 0.95 incorporan sus cuantiles empíricos superiores. La transformación inversa devuelve PPV en $\mathrm{mm/s}$ y PPA en $g$. Estos niveles utilizan la distribución residual agregada de cada respuesta y no establecen una garantía de cobertura condicional para cada combinación $(d,q)$ o procedencia.

Las predicciones se reportan por tipo de respuesta, combinación $(d,q)$ y nivel $p$. La generación de escenarios utiliza las predicciones PPV longitudinal, transversal y vertical para escalar las historias de la base instrumental L/T/V. PPA integra el refinamiento multirrespuesta, pero no determina los factores de escala.

El vínculo con el análisis de riesgos se establece mediante los objetivos PPV que escalan las historias de cada escenario $s=(D,Q,p)$, donde $D$ y $Q$ representan la distancia fuente--receptor y la carga instantánea máxima, respectivamente. Un RMSE OOF menor y un $R^2$ OOF mayor representan una predicción puntual más precisa únicamente en los sentidos definidos por esas métricas; la incertidumbre que acompaña al escenario depende además de los cuantiles superiores de la distribución residual. Cuando la separación entre los cuantiles residuales superiores y la mediana también disminuye, los niveles predictivos de amplitud incorporan una banda superior más estrecha y la demanda del escenario queda definida con menor dispersión predictiva. Para una misma probabilidad objetivo de falla, la metodología define la frontera de admisibilidad en el plano $(D,Q)$. La admisibilidad de una carga $Q$ mayor para una distancia $D$ dada, o de una distancia $D$ menor para una carga $Q$ dada, queda determinada por las respuestas dinámicas y las capacidades del modelo de riesgo.

La aplicabilidad de las predicciones queda limitada por el dominio cubierto conjuntamente por las observaciones locales y las observaciones externas admitidas. La malla no constituye evidencia adicional y la transferencia de la fuente complementaria es una hipótesis del modelo. Las predicciones y sus cuantiles describen relaciones condicionadas por esa muestra; su interpretación se acompaña con la población evaluada, la iteración retenida y la evidencia OOF correspondiente.
