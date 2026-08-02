El cálculo de desplazamientos utiliza la amenaza sísmica del sitio y los períodos fundamentales establecidos en el Capítulo [-@sec-slope_periods]. Para cada geometría, material y período de retorno se construye una muestra conjunta de las medidas de intensidad requeridas por las formulaciones de bloque rígido y flexible. Esa muestra es común a todos los modelos, de modo que sus diferencias representan la formulación del desplazamiento y no demandas sísmicas incompatibles.

### Demanda sísmica para el análisis de desplazamientos

La demanda corresponde a los espectros uniformes de amenaza probabilística definidos por período de retorno. La entrada en roca de referencia consiste en la UHS media para $V_{S30}=V_{\mathrm{ref}}=760$ m/s. Para cada escenario de geometría y material, sus ordenadas espectrales y su PGA media se transforman al $V_{S30}$ medio mediante el modelo de amplificación ST20 [@Stewart2020; @Hashash2020]. Los fractiles de la demanda amplificada provienen de la dispersión logarítmica del modelo de respuesta de sitio; la UHS de roca permanece representada por su media.

La muestra conjunta comprende PGA, $S_a(1.3T_s)$ y $S_a(1.5T_s)$ en la condición de sitio de cada escenario. Las tres medidas se representan mediante marginales empíricas en $\ln S_a$ y una cópula gaussiana con la matriz completa de correlación interperíodo de Baker y Jayaram [-@BakerJayaram2008]. Las muestras se recentran para conservar la media de cada marginal amplificada. En cada realización, las tres intensidades permanecen apareadas; cada formulación de desplazamiento utiliza las medidas que intervienen en su regresión.

La intensidad de Arias utilizada por JB07 y SR08 se estima para cada realización a partir de la PGA [@Verri2023a]:

$$
I_A=\exp(2.6109)\,\mathrm{PGA}^{1.9228}.
$${#eq-newmark-arias}

donde $I_A$ se expresa en m/s y PGA en unidades de $g$. La evaluación aplica esta relación de forma determinística: cada realización de PGA determina un único valor de $I_A$, y la muestra de desplazamientos propaga la variabilidad de PGA.

Para cada escenario se evalúan 30 valores de $k_y$ distribuidos logarítmicamente entre 0.01 y $\max(\overline{\mathrm{PGA}},0.80)$. Ese intervalo establece el soporte calculado de las relaciones $D_n(k_y)$.
