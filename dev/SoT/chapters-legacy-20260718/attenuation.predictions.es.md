La distribución empírica del error se estima mediante los residuos del ensamble obtenidos fuera de muestra. Para cada punto de la malla y nivel $p$, la amplitud predictiva se calcula como

$$
\widehat{Y}_p(D,Q)
= 10^{\,\widehat{Y}^{\log}(D,Q)+\widehat q_p(r)},
\qquad
r_i = \log_{10} Y_i - \log_{10}\widehat{Y}^{\mathrm{OOF}}_i .
$$ {#eq-amplitude-predictive-quantile}

Aquí $\widehat{Y}^{\log}(D,Q)$ es la predicción del ensamble en escala logarítmica y $\widehat q_p(r)$ es el cuantil empírico de los residuos. Los niveles exportados representan cuantiles predictivos construidos a partir del error observado fuera de muestra; no son intervalos de confianza paramétricos ni bandas simétricas.

La transformación inversa devuelve PPV y PPA a sus unidades físicas y conserva para cada fila la distancia, la MIC, el nivel predictivo y las métricas asociadas. La generación de escenarios consume únicamente las filas de la malla correspondientes a PPV longitudinal, transversal y vertical. La tabla de auditoría mantiene el detalle por respuesta y permite rastrear las predicciones físicas hasta el ajuste y la evidencia fuera de muestra que las sustentan.
