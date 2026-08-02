Las dos corrientes anteriores convergen aquí. Para cada escenario — una combinación de distancia $D$, carga $Q$ y nivel predictivo $p$ — el conjunto de realizaciones reúne una historia por cada registro fuente de la base normalizada, calibrada a las amplitudes que el modelo predice para ese escenario. Todas las realizaciones de un escenario comparten el nivel; difieren en la forma temporal, la duración y el contenido de frecuencias que heredan de sus registros de origen. Cada corrida del modelo dinámico de deformaciones sobre una realización producirá una observación del resultado binario falla/no-falla; el conjunto completo produce la muestra con la que se estimará la probabilidad de falla del escenario.

Para un registro $j$ y una componente original $c\in\{L,T,V\}$, el factor de escala se define respecto de la velocidad pico de la historia procesada:

$$
a'_{j,c}(t;D,Q,p)
= a_{j,c}(t)\,
  \frac{G\,\widehat{\mathrm{PPV}}_c(D,Q,p)}
       {\max_t |v_{j,c}(t)|} ,
$$ {#eq-scenario-scaling}

donde $\widehat{\mathrm{PPV}}_c(D,Q,p)$ es la predicción por componente del modelo de amplitudes, $\max_t |v_{j,c}(t)|$ la velocidad pico de la historia procesada y $G$ el factor de conversión entre la unidad de las predicciones y la unidad base de las historias, igual a uno con PPV en mm/s e historias en mm. El mismo factor multiplica las historias completas de aceleración, velocidad y desplazamiento de la componente: la operación fija la velocidad pico en el objetivo predicho, conserva el eje temporal y la forma normalizada, y mantiene la coherencia cinemática entre las tres magnitudes. Como cada componente recibe su propio factor, la relación de amplitudes entre componentes puede cambiar respecto del registro original.

Después del escalamiento, la dirección horizontal principal se obtiene del autovector dominante de la matriz de covarianza de las aceleraciones horizontales escaladas, y define la rotación ortogonal

$$
H1_j(t)=L'_j(t)\cos\theta_j+T'_j(t)\sin\theta_j,
\qquad
H2_j(t)=-L'_j(t)\sin\theta_j+T'_j(t)\cos\theta_j ,
$$ {#eq-scenario-rotation}

que se aplica por igual a aceleración, velocidad y desplazamiento; la componente vertical se conserva como UP. Las predicciones del modelo están expresadas en la base instrumental L/T/V: el escalamiento se ejecuta en esa base y la rotación a direcciones principales es posterior. H1, H2 y UP son historias temporales; el espectro horizontal rotado mediano, cuando se calcula, es un estadístico espectral adicional y no una nueva historia.

La verificación de cada conjunto comprueba propiedades que deben cumplirse por construcción. La velocidad pico de la componente UP debe reproducir la PPV vertical objetivo dentro de la tolerancia adoptada; la suma cuadrática de las aceleraciones horizontales debe conservarse al pasar de L/T a H1/H2, porque la transformación es ortogonal; y las aceleraciones pico de las tres direcciones deben ser positivas. Los resultados se registran por realización y se resumen por escenario, lo que distingue una falla aislada de un problema que afecta a toda una condición de distancia y carga. Estas pruebas verifican que el escalamiento reproduzca la amplitud vertical objetivo y que la rotación conserve la energía del par horizontal; no evalúan compatibilidad espectral ni respuesta geotécnica, y su resultado es evidencia que se revisa antes de aceptar los conjuntos, sin actuar como barrera automática de las etapas siguientes.

La composición del conjunto que se entrega al análisis dinámico queda definida por los parámetros de la selección: qué magnitud del movimiento y en qué dirección se extrae, la banda de procesamiento, el nivel predictivo, la cantidad de realizaciones por escenario y el criterio de retención — ordenamiento por una medida de intensidad o muestreo aleatorio. La medida usada para ordenar es un descriptor de demanda, no una demostración de representatividad; la interpretación de las realizaciones frente a la respuesta del depósito corresponde al modelo dinámico.

Las identidades seleccionadas conservan su relación con la banda, la distancia, la carga, el nivel predictivo, la dirección y las medidas de intensidad, y con ella se construyen el índice del conjunto entregado y el inventario de registros únicos que muestra en qué escenarios aparece cada identidad. Esa trazabilidad permite vincular cada resultado futuro del modelo dinámico con la realización que lo produjo y con la condición física que determinó su amplitud.
