Cada historia se representa sobre un eje temporal uniforme. Cuando la discretización debe modificarse, la señal se filtra antes del remuestreo para evitar aliasing y sus extremos se atenúan gradualmente para limitar artefactos de borde. La aceleración se obtiene mediante derivación en el dominio de la frecuencia, con una regularización pasabajos que limita la amplificación de altas frecuencias. El desplazamiento se obtiene mediante integración en el mismo dominio y eliminación de la componente continua. Aceleración, velocidad y desplazamiento son, por tanto, representaciones coherentes del mismo movimiento y no series procesadas de forma independiente.

Las historias canónicas conservan la señal medida completa: no se aplica ningún retiro selectivo de modos ni filtrado adicional más allá de la regularización descrita. Como análisis complementario, cada componente de aceleración se descompone en modos mediante la descomposición variacional en modos (VMD), que caracteriza la frecuencia central, el ancho de banda y la energía de cada modo. Ese análisis cumple un papel diagnóstico — en particular, informa la selección del ancho de banda de procesamiento a partir de la distribución de energía por modo — y no modifica las historias utilizadas en los escenarios.

La revisión de las historias procesadas considera forma de pulso, amplitud y tiempo del pico, polaridad, comportamiento en los extremos, tendencias de velocidad y desplazamiento, contenido frecuencial, demanda acumulada y espectros de respuesta. Estas verificaciones son necesarias porque el remuestreo, el tratamiento de bordes, la derivación y la integración pueden modificar los productos derivados aun cuando la traza de aceleración parezca visualmente aceptable [-@BooreBommer2005].

La intensidad de Arias y las duraciones significativas se calculan a partir de la historia de aceleración. Con paso de tiempo constante $\Delta t$ y aceleración expresada en una unidad base consistente, la intensidad de Arias discreta es

$$
\mathrm{AI}_c =
\frac{\pi}{2g}
\sum_{i=1}^{N} a_{c,i}^{2}\,\Delta t .
$$ {#eq-signal-arias-intensity}

La curva acumulada utilizada para las duraciones es proporcional a la suma acumulada de $a_{c,i}^2$. Si $t_{\alpha}$ denota el tiempo en que esta curva alcanza la fracción $\alpha$ de su valor final, las duraciones retenidas incluyen

$$
D_{5-95}=t_{0.95}-t_{0.05},\qquad
D_{5-75}=t_{0.75}-t_{0.05},\qquad
D_{20-80}=t_{0.80}-t_{0.20}.
$$ {#eq-signal-significant-duration}

La velocidad absoluta acumulada se calcula mediante

$$
\mathrm{CAV}_c = \sum_{i=1}^{N} |a_{c,i}|\,\Delta t .
$$ {#eq-signal-cav}

La medida CAV5 aplica la misma suma únicamente a las ordenadas cuya aceleración absoluta alcanza el umbral de $0.05g$. Las medidas pico describen la mayor amplitud instantánea; AI y CAV describen demanda acumulada; y las duraciones caracterizan la ventana temporal durante la cual actúan los ciclos. Son descriptores del movimiento impuesto, mientras la aceptación del TSF depende de la respuesta calculada mediante el modelo geotécnico.

Los espectros elásticos de respuesta se calculan a partir de las historias canónicas mediante un oscilador lineal de un grado de libertad. Para el período natural $T_n$ y la razón de amortiguamiento $\xi$,

$$
\omega_n = \frac{2\pi}{T_n},\qquad
C = 2\xi\omega_n,\qquad
K = \omega_n^2 .
$$ {#eq-signal-sdof-parameters}

El estado del oscilador $\mathbf{y}(t)$ se evalúa a partir de

$$
\dot{\mathbf{y}} =
\mathbf{A}\mathbf{y}+\mathbf{B}u(t),\qquad
\mathbf{A} =
\begin{bmatrix}
0 & 1\\
-K & -C
\end{bmatrix},\qquad
\mathbf{B} =
\begin{bmatrix}
0\\
1
\end{bmatrix}.
$$ {#eq-signal-sdof-state}

Una vez evaluada la respuesta, el desplazamiento espectral y las ordenadas pseudoespectrales son

$$
\mathrm{SD}(T_n)=\max_t |y_1(t)|,\qquad
\mathrm{PSV}(T_n)=\omega_n\,\mathrm{SD}(T_n),\qquad
\mathrm{PSA}(T_n)=\omega_n^2\,\mathrm{SD}(T_n).
$$ {#eq-signal-response-spectra}

El producto conserva el vínculo con la historia fuente: PSA se obtiene de la historia de aceleración, PSV de la historia de velocidad y SD de la historia de desplazamiento.
