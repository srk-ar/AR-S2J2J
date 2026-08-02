La generación de escenarios reúne las predicciones de PPV por componente y las historias procesadas de velocidad de partícula. Para cada combinación configurada de distancia $D$, MIC $Q$ y nivel predictivo $p$, se interpolan las PPV longitudinal, transversal y vertical. Cada escenario conserva una realización por registro fuente, de modo que la amplitud queda determinada por el modelo predictivo, mientras que la forma temporal y el contenido frecuencial proceden de movimientos medidos.

Para un registro $j$ y una componente original $c\in\{L,T,V\}$, el factor de escala se define respecto de la velocidad pico de la historia procesada:

$$
a'_{j,c}(t;D,Q,p)
= a_{j,c}(t)
  \frac{G\,\widehat{\mathrm{PPV}}_c(D,Q,p)}
       {\max_t |v_{j,c}(t)|} .
$$ {#eq-scenario-component-scaling}

En esta expresión $\widehat{\mathrm{PPV}}_c(D,Q,p)$ es la predicción por componente del modelo de atenuación, $\max_t |v_{j,c}(t)|$ la velocidad pico de la historia procesada y $G$ el factor de conversión entre la unidad de las predicciones y la unidad base de las historias, igual a uno con PPV en mm/s e historias en mm. El mismo factor multiplica las historias completas de aceleración, velocidad y desplazamiento de la componente. Esta operación fija su velocidad pico en el objetivo predicho por el modelo, conserva el eje temporal y la forma normalizada, y mantiene la coherencia cinemática entre las tres magnitudes. Como L, T y V reciben factores distintos, la relación de amplitudes entre componentes puede cambiar respecto del registro original.

Después del escalamiento se calcula la matriz de covarianza de las aceleraciones horizontales L y T. El autovector dominante define H1, la dirección de mayor varianza de aceleración, y su dirección ortogonal define H2:

$$
H1_j(t)=L'_j(t)\cos\theta_j+T'_j(t)\sin\theta_j,
\qquad
H2_j(t)=-L'_j(t)\sin\theta_j+T'_j(t)\cos\theta_j .
$$ {#eq-scenario-principal-rotation}

La misma transformación ortogonal se aplica a aceleración, velocidad y desplazamiento, mientras V se conserva como UP. H1, H2 y UP son historias temporales. D50 y D100, cuando se solicitan, resumen espectros SDOF obtenidos mediante rotaciones angulares adicionales y no constituyen nuevas historias.

Los escenarios resultantes son historias de demanda para el análisis dinámico. La presión de poros, la movilidad cíclica, las deformaciones y la respuesta de estabilidad son resultados del modelo geotécnico y dependen además del estado inicial, el modelo constitutivo, las condiciones de drenaje y las condiciones de borde [-@LucoBazzurro2007; -@WhittakerEtAl2011NISTGCRScaling].

El control de consistencia verifica propiedades que deben cumplirse por construcción después del escalamiento y la rotación. Para cada registro, la velocidad pico de UP debe reproducir la PPV vertical objetivo dentro de la tolerancia adoptada. La suma cuadrática de las aceleraciones horizontales debe conservarse al transformar L/T en H1/H2, porque la transformación es ortogonal. Las aceleraciones pico de H1, H2 y UP deben ser mayores que cero.

Los resultados se registran por realización y se resumen por escenario, lo que permite distinguir una falla aislada de un problema que afecta a toda una condición de distancia y MIC. Estas pruebas verifican el contrato de escalamiento vertical, la consistencia de la rotación horizontal y la existencia de una amplitud de aceleración positiva. No verifican compatibilidad espectral, presión de poros, deformación, representatividad del conjunto ni respuesta geotécnica.

La auditoría y la selección consumen las mismas historias, pero se ejecutan de forma independiente. El resultado de la auditoría no actúa actualmente como una barrera automática dentro de la selección; constituye evidencia que debe revisarse antes de aceptar los escenarios para análisis posteriores.
