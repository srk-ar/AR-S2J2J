El análisis dinámico de la sección utiliza historias triaxiales de aceleración, velocidad y desplazamiento. Este capítulo construye esas excitaciones mediante la combinación de las amplitudes PPV estimadas para cada condición de voladura y las formas temporales de la población instrumental. El producto es una familia de escenarios de demanda que representa la variabilidad temporal medida y las amplitudes condicionadas por distancia, carga y nivel predictivo.

Una condición de escenario $s$ se define mediante la distancia fuente--receptor $d_s$, la carga instantánea máxima $q_s$ y el nivel predictivo $p_s$. Una historia fuente es una terna instrumental procesada en L/T/V, con historias coherentes de aceleración, velocidad y desplazamiento. La transformación de una historia fuente $r$ para una condición $s$ produce una realización en H1/H2/UP. El escenario reúne todas las realizaciones que comparten esa condición y los mismos objetivos PPV; la familia de escenarios comprende el conjunto de condiciones evaluadas.

Para cada componente instrumental $c\in\{L,T,V\}$, el objetivo $\mathrm{PPV}^{\mathrm{tar}}_{s,c}$ se obtiene de la predicción física definida por @eq-model-quantiles en $(d_s,q_s,p_s)$. El nivel $p_s$ identifica el cuantil empírico de la distribución residual utilizado para establecer la amplitud. La evaluación sobre la malla predictiva emplea interpolaciones lineales sucesivas en distancia y carga y se limita a su envolvente. Tanto los objetivos como las velocidades de las historias fuente se expresan en $\mathrm{mm/s}$.

Para el escenario $s$, la historia fuente $r$ y la componente $c$, el factor de escala se define a partir de la velocidad pico $\mathrm{PGV}_{r,c}$ de @eq-records-pgv:

$$
\lambda_{s,r,c}
=
\frac{\mathrm{PPV}^{\mathrm{tar}}_{s,c}}
     {\mathrm{PGV}_{r,c}}.
$$ {#eq-scenarios-scale-factor}

El factor se aplica a las tres magnitudes de movimiento de la componente:

$$
\begin{bmatrix}
a^{\mathrm{sc}}_{s,r,c}(t)\\[2pt]
v^{\mathrm{sc}}_{s,r,c}(t)\\[2pt]
u^{\mathrm{sc}}_{s,r,c}(t)
\end{bmatrix}
=
\lambda_{s,r,c}
\begin{bmatrix}
a_{r,c}(t)\\[2pt]
v_{r,c}(t)\\[2pt]
u_{r,c}(t)
\end{bmatrix}.
$$ {#eq-scenarios-component-scaling}

La aplicación de un factor común a la aceleración, la velocidad y el desplazamiento de una componente mantiene su coherencia cinemática y establece $\max_t|v^{\mathrm{sc}}_{s,r,c}(t)|=\mathrm{PPV}^{\mathrm{tar}}_{s,c}$. Los factores se calculan independientemente para L, T y V; por ello, las relaciones de amplitud entre componentes pueden diferir de las observadas en la historia fuente.

La transformación a las direcciones de análisis se realiza después del escalamiento. Para cada realización, el autovector dominante de la matriz de covarianza de las aceleraciones horizontales escaladas define el ángulo $\theta_{s,r}$. Para $\psi\in\{a,v,u\}$, la misma rotación ortogonal se aplica a las tres magnitudes:

$$
\begin{bmatrix}
\psi_{s,r,H1}(t)\\
\psi_{s,r,H2}(t)
\end{bmatrix}
=
\begin{bmatrix}
\cos\theta_{s,r} & \sin\theta_{s,r}\\
-\sin\theta_{s,r} & \cos\theta_{s,r}
\end{bmatrix}
\begin{bmatrix}
\psi^{\mathrm{sc}}_{s,r,L}(t)\\
\psi^{\mathrm{sc}}_{s,r,T}(t)
\end{bmatrix}.
$$ {#eq-scenarios-principal-rotation}

H1 corresponde a la dirección de mayor varianza de la aceleración horizontal y H2 a su dirección ortogonal. La componente vertical escalada conserva su orientación y se identifica como UP. Como los factores L y T dependen del escenario, $\theta_{s,r}$ también puede variar entre condiciones. Las historias H1/H2/UP resultantes se utilizan para recalcular las medidas de intensidad y los espectros de pseudoaceleración con 5 % de amortiguamiento.

La construcción debe reproducir el objetivo vertical de amplitud y conservar la norma cuadrática de las aceleraciones horizontales durante la rotación. Para cada realización se evalúan, por separado, el error relativo de amplitud vertical

$$
e^{\mathrm{PPV}}_{s,r}
=
\left|
\frac{\mathrm{PGV}_{s,r,UP}}
     {\mathrm{PPV}^{\mathrm{tar}}_{s,V}}
-1
\right|
$$ {#eq-scenarios-vertical-amplitude-error}

y el error relativo asociado con la transformación horizontal

$$
e^{\mathrm{rot}}_{s,r}
=
\left|
\frac{
\sum_t\!\left[a_{s,r,H1}(t)^2+a_{s,r,H2}(t)^2\right]
}{
\sum_t\!\left[a^{\mathrm{sc}}_{s,r,L}(t)^2+a^{\mathrm{sc}}_{s,r,T}(t)^2\right]
}
-1
\right|.
$$ {#eq-scenarios-horizontal-rotation-error}

Se adopta una tolerancia relativa de $10^{-3}$ para ambas propiedades. La aceptación numérica también exige historias no degeneradas, con PGA positiva en H1, H2 y UP. Un escenario satisface estos criterios cuando todas sus realizaciones cumplen las dos tolerancias y la condición de no degeneración.

Cada realización mantiene asociadas la identidad de la historia fuente, la condición $(d_s,q_s,p_s)$ y las amplitudes PPV prescritas. El conjunto entregado al análisis dinámico comprende las historias de aceleración, velocidad y desplazamiento en H1/H2/UP, sus medidas de intensidad y sus espectros. Esta identificación permite interpretar posteriormente la respuesta geotécnica con respecto a la excitación aplicada y a la condición de voladura que determinó su amplitud. La familia completa precede a cualquier selección de realizaciones y a la evaluación de la respuesta geotécnica.
