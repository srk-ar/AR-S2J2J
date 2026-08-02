El modelo de amplitudes estima los valores pico de vibración de voladura sobre el dominio distancia–carga. Las respuestas son PPV y PPA por componente longitudinal, transversal y vertical, y sus resultantes escalares, definidas como la norma euclídea de los picos por componente:

$$
\mathrm{PPV} =
\sqrt{\mathrm{PPV}_L^2+\mathrm{PPV}_T^2+\mathrm{PPV}_V^2},\qquad
\mathrm{PPA} =
\sqrt{\mathrm{PPA}_L^2+\mathrm{PPA}_T^2+\mathrm{PPA}_V^2}.
$$ {#eq-amplitude-resultants}

Los picos por componente no ocurren en el mismo instante, de modo que la resultante así definida acota por encima al pico del vector de movimiento; es la convención adoptada para toda la base de datos y para el modelo.

Cada respuesta utiliza las observaciones que contienen la familia de componentes necesaria. La población de entrenamiento reúne los registros del sitio con registros complementarios admitidos únicamente cuando su distancia a la fuente o su carga quedan fuera de la envolvente cubierta por las observaciones locales. Dentro de esa envolvente, los registros del sitio son la única información de entrenamiento; los complementarios extienden el soporte físico del modelo sin sustituir el nivel de amplitud observado localmente. Las unidades de PPV y PPA se declaran por registro y se verifican por homogeneidad antes del ajuste. La depuración de la base descarta de la familia de aceleraciones las lecturas incompatibles con una medición: tripletas con las tres componentes ortogonales idénticas y valores exactos repetidos entre registros de una misma fuente.

Las variables explicativas se construyen a partir de la carga instantánea máxima $Q$, la distancia fuente–receptor $D$ y la distancia escalada $S$, con transformaciones monótonas que permiten representar leyes de atenuación de distinta curvatura:

$$
\mathbf{x}(D,Q)=
\left[
Q,\ \ln Q,\ Q^{-1},\
D,\ \ln D,\ D^{-1},\
S,\ \log_{10} S
\right],
\qquad
S=\frac{D}{\sqrt{Q}} .
$$ {#eq-amplitude-feature-vector}

En esta expresión $Q$ es la carga instantánea máxima en kg, $D$ la distancia fuente–receptor en m, $\ln Q$ y $\ln D$ sus logaritmos naturales, $Q^{-1}$ y $D^{-1}$ sus recíprocos, $S$ la distancia escalada en m/kg$^{1/2}$ y $\log_{10} S$ su logaritmo decimal.

Las observaciones y la malla de predicción comparten esta representación, pero cumplen funciones diferentes. Las primeras intervienen en el ajuste; la malla contiene combinaciones de $D$ y $Q$ sin respuesta observada y define el dominio donde se evaluará el modelo.
