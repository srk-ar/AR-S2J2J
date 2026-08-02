La respuesta del modelo geotécnico dinámico se obtiene de la historia completa de la excitación. La duración, la secuencia de ciclos y el contenido de frecuencias intervienen junto con la amplitud pico; por ello, la base instrumental debe conservar la forma temporal medida y separar esa forma de la amplitud que corresponde a cada condición de carga y distancia.

La base instrumental está constituida por historias de velocidad de partícula medidas durante las voladuras del sitio. Cada registro conserva una identidad única y las componentes longitudinal, transversal y vertical —$L$, $T$ y $V$—. La distancia fuente–receptor $d_r$ y la carga instantánea máxima $q_r$ integran los metadatos del registro $r$ cuando el contratista informó ambos valores; este subconjunto caracteriza la cobertura observada de condiciones de monitoreo, mientras la población instrumental completa aporta las formas temporales. La velocidad es la magnitud primaria de la medición; las historias de aceleración y desplazamiento se derivan de esa señal bajo una única convención temporal y de unidades.

Las amplitudes se expresan con una base de longitud común en milímetros, de modo que aceleración, velocidad y desplazamiento quedan en $\mathrm{mm/s^2}$, $\mathrm{mm/s}$ y $\mathrm{mm}$, respectivamente. El tiempo de cada registro se refiere al inicio de la historia procesada y aumenta con un paso constante $\Delta t$. Esta representación permite aplicar las mismas operaciones y calcular los mismos descriptores en toda la población instrumental.

El ajuste de la aceleración pico de partícula (PPA) y la velocidad pico de partícula (PPV) combina las observaciones locales de IMPALA con la fuente complementaria S11D, una base de amplitudes pico medidas en distintos proyectos en el mundo, compilada por el autor. Dentro de la envolvente rectangular de distancia y carga cubierta por el sitio se utiliza la evidencia local; fuera de alguno de esos intervalos, S11D amplía el dominio observado de distancia y carga. Cada observación mantiene su procedencia y las respuestas disponibles por componente.

Las muestras se ordenan temporalmente y se llevan a una grilla uniforme. Cuando el paso original no es uniforme, la señal se interpola mediante una función cúbica monótona sobre el menor incremento temporal compatible con la historia. Cuando la frecuencia de muestreo debe reducirse, se aplica primero un filtro pasabajos antialias cuya banda de paso contiene el intervalo de frecuencias de interés y cuya banda de rechazo queda por debajo de la nueva frecuencia de Nyquist. La transformación se evalúa en ventanas superpuestas y los extremos de la señal se atenúan gradualmente para limitar discontinuidades de borde.

Sea $V_c(\omega)$ la transformada de Fourier de la velocidad de la componente $c$ y $W_{\mathrm{LP}}(\omega)$ la regularización pasabajos asociada con la frecuencia máxima de procesamiento. La derivación se representa mediante el operador

$$
H_{\mathrm{d}}(\omega)=
\begin{cases}
0, & \omega=0,\\
\mathrm{i}\omega\,W_{\mathrm{LP}}(\omega), & \omega\ne0,
\end{cases}
$$ {#eq-records-differentiation-operator}

La integración se representa mediante

$$
H_{\mathrm{i}}(\omega)=
\begin{cases}
0, & \omega=0,\\
(\mathrm{i}\omega)^{-1}, & \omega\ne0.
\end{cases}
$$ {#eq-records-integration-operator}

La aceleración y el desplazamiento se obtienen como $a_c(t)=\mathcal{F}^{-1}\{H_{\mathrm{d}}V_c\}$ y $u_c(t)=\mathcal{F}^{-1}\{H_{\mathrm{i}}V_c\}$. La anulación del término de frecuencia cero controla la componente continua de la integración, mientras la función $W_{\mathrm{LP}}(\omega)$ limita la amplificación de las altas frecuencias durante la derivación. Una ventana final, definida sobre la aceleración procesada, se aplica de manera común a aceleración, velocidad y desplazamiento. El resultado es una terna $\{a_c(t),v_c(t),u_c(t)\}$ temporalmente alineada y generada mediante una transformación conjunta del mismo movimiento [@BooreBommer2005].

El control instrumental se concentra en la alineación temporal de las tres magnitudes, la coherencia de unidades y la ausencia de tendencias terminales que alteren la forma del pulso fuente. Estas propiedades condicionan el uso posterior de una misma historia de aceleración, velocidad y desplazamiento bajo un factor común de amplitud.

Sea $a^{(0)}_{r,c}(t)$ la aceleración del registro $r$ y la componente $c$ obtenida en la etapa precedente. Cada historia se descompone mediante descomposición variacional en modos (VMD) en $K=10$ modos $\phi_{r,c,k}(t)$, con frecuencias centrales $\omega_{r,c,k}$ estimadas simultáneamente [@DragomiretskiyZosso2014]. Omitiendo los subíndices $r,c$, la formulación de referencia minimiza el ancho de banda conjunto de las señales analíticas demoduladas:

$$
\begin{aligned}
\min_{\{\phi_k\},\,\{\omega_k\}}\quad&
\sum_{k=1}^{K}
\left\|
\partial_t
\left[
\left(\delta(t)+\frac{\mathrm{i}}{\pi t}\right)*\phi_k(t)
\right]
e^{-\mathrm{i}\omega_k t}
\right\|_2^2,\\
\text{sujeto a}\quad&
\sum_{k=1}^{K}\phi_k(t)=a^{(0)}(t).
\end{aligned}
$$ {#eq-records-vmd}

El procedimiento numérico adopta $\alpha=2000$, paso de ascenso dual $\tau=0$, primer modo restringido a $\omega_1=0$, frecuencias centrales inicializadas en cero y tolerancia de convergencia $10^{-7}$. La diferencia de cierre se define como

$$
\rho^{\mathrm{VMD}}_{r,c}(t)
=
a^{(0)}_{r,c}(t)
-\sum_{k=1}^{10}\phi_{r,c,k}(t).
$$ {#eq-records-vmd-closure}

La historia procesada incorpora esa diferencia mediante

$$
\begin{aligned}
a^{\mathrm{VMD}}_{r,c}(t)
&=
a^{(0)}_{r,c}(t)-\phi_{r,c,1}(t)\\
&=
\sum_{k=2}^{10}\phi_{r,c,k}(t)+\rho^{\mathrm{VMD}}_{r,c}(t).
\end{aligned}
$$ {#eq-records-vmd-reconstruction}

La reconstrucción retiene los modos IMF2–IMF10 y la diferencia de cierre, y separa $\phi_{r,c,1}$ —identificado como IMF1—, cuya frecuencia central se restringe a cero. La posición del modo en la descomposición define el componente separado, sin asignarle un origen físico específico. La aceleración $a^{\mathrm{VMD}}_{r,c}(t)$ se utiliza para reconstruir la terna cinemática y calcular las medidas de intensidad y los espectros posteriores.

Cada registro medido combina una forma temporal con la amplitud particular de la carga y la distancia de esa voladura. Para separar ambas contribuciones, se define para el registro $r$ y la componente $c$

$$
\mathrm{PGV}_{r,c}=\max_t|v_{r,c}(t)|.
$$ {#eq-records-pgv}

En este informe, $\mathrm{PGV}_{r,c}$ y $\mathrm{PPV}_{r,c}$ representan la misma magnitud física: el máximo absoluto de la velocidad de partícula. PGV identifica el descriptor calculado sobre una historia temporal, mientras PPV identifica la variable de respuesta del componente predictivo. Esta convención distingue los dos contextos de cálculo sin modificar la magnitud ni sus unidades; la misma convención aplica a PGA y PPA para la aceleración.

La separación de forma y amplitud se expresa algebraicamente mediante $\widetilde a_{r,c}=a_{r,c}/\mathrm{PGV}_{r,c}$, $\widetilde v_{r,c}=v_{r,c}/\mathrm{PGV}_{r,c}$ y $\widetilde u_{r,c}=u_{r,c}/\mathrm{PGV}_{r,c}$. Esta representación fija una velocidad pico unitaria; $\widetilde a_{r,c}$, $\widetilde v_{r,c}$ y $\widetilde u_{r,c}$ tienen unidades de $\mathrm{s}^{-1}$, $1$ y $\mathrm{s}$, respectivamente. La biblioteca procesada conserva las amplitudes físicas de las historias fuente.

Esta separación algebraica permite modificar la amplitud de la terna mediante un único factor común para aceleración, velocidad y desplazamiento, de modo que sus relaciones cinemáticas permanecen invariantes. El capítulo de escenarios define el factor que asigna a cada componente la PPV predicha.

La transferencia de formas de onda adopta una hipótesis explícita del proyecto: dentro del dominio de distancia y carga representado por el monitoreo y por los escenarios, la forma temporal relativa y su contenido de frecuencias se transfieren entre condiciones $(d,q)$. La amplitud se obtiene del componente predictivo y se asigna en la construcción de escenarios, mientras la variabilidad de duración, secuencia de ciclos y forma espectral proviene de la población de registros procesados. Las historias resultantes conservan la identidad y la forma temporal del registro instrumental del que derivan.

La diversidad de las historias procesadas se describe primero mediante sus máximos absolutos. Para cada registro $r$ y componente $c$,

$$
\mathrm{PGA}_{r,c} = \max_t |a_{r,c}(t)|.
$$ {#eq-records-pga}

La PGV se define en @eq-records-pgv. El desplazamiento pico se obtiene como

$$
\mathrm{PGD}_{r,c} = \max_t |u_{r,c}(t)|,
$$ {#eq-records-pgd}

donde PGA, PGV y PGD son las amplitudes pico de aceleración, velocidad y desplazamiento. Estas medidas caracterizan el máximo instantáneo y se complementan con indicadores que acumulan la acción de los ciclos.

Para las $n_r$ muestras del registro $r$, con paso constante $\Delta t$, la intensidad de Arias [@Arias1970], la velocidad absoluta acumulada y su variante umbralizada se calculan mediante

$$
\mathrm{AI}_{r,c} = \frac{\pi}{2g}\sum_{\ell=1}^{n_r} a_{r,c,\ell}^{2}\,\Delta t.
$$ {#eq-records-ai}

$$
\mathrm{CAV}_{r,c} = \sum_{\ell=1}^{n_r} |a_{r,c,\ell}|\,\Delta t.
$$ {#eq-records-cav}

$$
\mathrm{CAV5}_{r,c} = \sum_{\ell=1}^{n_r}|a_{r,c,\ell}|\,\mathbf{1}\!\left(|a_{r,c,\ell}|\ge0.05g\right)\Delta t,
$$ {#eq-records-cav5}

donde $g$ es la aceleración de la gravedad y $\mathbf{1}(\cdot)$ es la función indicadora. AI pondera con mayor intensidad las ordenadas de aceleración alta; CAV acumula el valor absoluto de toda la historia; CAV5 conserva las ordenadas que alcanzan el umbral de $0.05g$.

Las duraciones significativas se obtienen de la curva acumulada de $a_{r,c,\ell}^{2}$. Si $t_{r,c,\gamma}$ es el instante en que esa curva alcanza la fracción $\gamma$ de su valor final, la duración entre las fracciones $\gamma_1$ y $\gamma_2$ es

$$
D^{(r,c)}_{[\gamma_1,\gamma_2]}=t_{r,c,\gamma_2}-t_{r,c,\gamma_1}.
$$ {#eq-records-duration}

El informe presenta las duraciones significativas 5–95 %, 5–75 % y 20–80 %, correspondientes a los intervalos $[0.05,0.95]$, $[0.05,0.75]$ y $[0.20,0.80]$ de la acción acumulada, respectivamente.

Las amplitudes pico describen los máximos instantáneos; AI, CAV y CAV5 representan medidas acumuladas de la aceleración, y las duraciones expresan la distribución temporal de esa acción. En conjunto distinguen historias con una amplitud máxima semejante pero diferente cantidad, secuencia y concentración temporal de ciclos.

El contenido de frecuencias de cada registro $r$ y componente $c$ se caracteriza mediante el espectro elástico de pseudoaceleración para una razón de amortiguamiento $\xi=0.05$. Para un período natural $T_n$, con $\omega_n=2\pi/T_n$, la coordenada relativa $w_{r,c}(t;T_n)$ del oscilador lineal satisface

$$
\ddot{w}_{r,c}(t;T_n)+2\xi\omega_n\dot{w}_{r,c}(t;T_n)+\omega_n^2w_{r,c}(t;T_n)=-a_{r,c}(t).
$$ {#eq-records-psa-oscillator}

La respuesta se evalúa mediante la matriz de transición exacta del sistema para cada intervalo $\Delta t$. La ordenada espectral es

$$
\mathrm{PSA}_{r,c}(T_n)=\omega_n^2\max_t|w_{r,c}(t;T_n)|.
$$ {#eq-records-psa}

Los períodos se distribuyen logarítmicamente desde el inverso de la frecuencia máxima de procesamiento hasta $1\,\mathrm{s}$. Los espectros por registro y componente permiten comparar la distribución de la demanda en el dominio de períodos entre historias que presentan amplitudes pico semejantes.
