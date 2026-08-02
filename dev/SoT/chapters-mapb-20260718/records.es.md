Las métricas de falla del modelo dinámico dependen de la historia completa de la excitación, no solo de su amplitud pico. La base de registros de este capítulo aporta esa dimensión de la demanda: cada registro medido aporta una forma temporal y un contenido de frecuencias reales, y la colección completa es la muestra de diversidad que los conjuntos de realizaciones trasladarán al modelo dinámico. La fuente son las historias de velocidad de partícula del monitoreo del sitio, con sus componentes longitudinal, transversal y vertical y los metadatos del evento, la estación y el muestreo.

Cada historia se lleva a un eje temporal uniforme; cuando la discretización debe modificarse, la señal se filtra antes del remuestreo para evitar aliasing, y los extremos se atenúan gradualmente para limitar artefactos de borde. La aceleración se obtiene por derivación en el dominio de la frecuencia, con una regularización pasabajos que limita la amplificación de las altas frecuencias, y el desplazamiento por integración en el mismo dominio, con eliminación de la componente continua. El resultado, para cada componente, es una terna coherente de aceleración, velocidad y desplazamiento derivada del mismo movimiento bajo una convención común de tiempo y unidades, en lugar de tres series procesadas de forma independiente.

Como análisis complementario, cada componente de aceleración se descompone en modos mediante la descomposición variacional en modos (VMD), que caracteriza la frecuencia central, el ancho de banda y la energía de cada modo. Este análisis cumple un papel diagnóstico — en particular, informa la selección del ancho de banda de procesamiento a partir de la distribución de energía por modo — y no modifica las historias: la señal medida se conserva completa, sin retiro selectivo de modos.

La amplitud de cada registro refleja la carga y la distancia particulares de su voladura. Para que la base funcione como repositorio de formas y no de niveles, cada componente se normaliza a escala unitaria respecto de su velocidad pico. La normalización supone una hipótesis que este informe declara explícitamente: el contenido de frecuencias de los registros del sitio se trata como invariante frente a la distancia dentro de la ventana de distancias del monitoreo. El alcance de la hipótesis queda acotado a esa ventana.

La diversidad que la base aporta se cuantifica con descriptores calculados sobre las historias procesadas. Las amplitudes pico por componente son

$$
\mathrm{PGA}_c = \max_t |a_c(t)|,\qquad
\mathrm{PGV}_c = \max_t |v_c(t)|,\qquad
\mathrm{PGD}_c = \max_t |d_c(t)| ,
$$ {#eq-records-peaks}

donde $a_c(t)$, $v_c(t)$ y $d_c(t)$ son las historias de aceleración, velocidad y desplazamiento de la componente $c$. El contenido acumulado se mide con la intensidad de Arias y la velocidad absoluta acumulada; para un paso de tiempo constante $\Delta t$,

$$
\mathrm{AI}_c = \frac{\pi}{2g}\sum_{i=1}^{N} a_{c,i}^{2}\,\Delta t ,
\qquad
\mathrm{CAV}_c = \sum_{i=1}^{N} |a_{c,i}|\,\Delta t ,
$$ {#eq-records-cumulative}

donde $g$ es la aceleración de la gravedad y $N$ el número de muestras; la variante CAV5 restringe la suma a las ordenadas cuya aceleración absoluta supera el umbral de $0.05g$. La ventana temporal en que actúan los ciclos se caracteriza con las duraciones significativas: si $t_\alpha$ es el instante en que la curva acumulada de $a_{c,i}^2$ alcanza la fracción $\alpha$ de su valor final,

$$
D_{5-95}=t_{0.95}-t_{0.05},\qquad
D_{5-75}=t_{0.75}-t_{0.05},\qquad
D_{20-80}=t_{0.80}-t_{0.20}.
$$ {#eq-records-durations}

El contenido de frecuencias se caracteriza con espectros elásticos de respuesta de un oscilador lineal de un grado de libertad. Para el período natural $T_n$ y la razón de amortiguamiento $\xi$, con $\omega_n = 2\pi/T_n$, el estado del oscilador sometido a la historia $u(t)$ se evalúa de

$$
\dot{\mathbf{y}} =
\begin{bmatrix} 0 & 1\\ -\omega_n^2 & -2\xi\omega_n \end{bmatrix}\mathbf{y}
+ \begin{bmatrix} 0\\ 1 \end{bmatrix} u(t),
$$ {#eq-records-sdof}

y las ordenadas espectrales se obtienen del máximo de la respuesta: el desplazamiento espectral de la historia de desplazamiento, la pseudovelocidad de la historia de velocidad escalada por $\omega_n$ y la pseudoaceleración de la historia de aceleración escalada por $\omega_n^2$. Amplitud, contenido acumulado, duración y forma espectral son las dimensiones en las que difieren dos registros con la misma amplitud pico.
