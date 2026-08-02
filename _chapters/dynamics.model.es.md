Los modelos de bloque flexible evalúan la demanda en períodos proporcionales al período fundamental de la masa potencialmente deslizante. Este capítulo establece, para cada geometría y clase de material, el perfil de rigidez de pequeña deformación, el módulo basal $G_o$, la velocidad basal de onda de corte $V_S^o$, el exponente de variación con la profundidad $m_o$ y el período fundamental $T_s$. Los valores medios resultantes constituyen la entrada dinámica de los modelos de desplazamiento del Capítulo [-@sec-newmark].

### Escenarios geométricos y perfiles de rigidez

Cada escenario geométrico se define mediante la altura $H_s$, la relación de talud $s$ y la razón de truncamiento de entrada $\lambda_o$. El parámetro geométrico $b$ y la dimensión basal $b_{\max}$ se derivan como

$$
\begin{aligned}
b&=\frac{2H_s s}{1/\lambda_o-1},\\
b_{\max}&=b+2H_s s,\\
\lambda_o&=\frac{b}{b_{\max}}.
\end{aligned}
$${#eq-slope-geometry}

En estas expresiones, $\tan\beta=1/s$ y $\beta$ es el ángulo medio del talud. El valor de $b$ se redondea en la tabla geométrica y la razón $\lambda_o$ empleada por el cálculo modal se actualiza a partir de esa geometría.

El hiperparámetro $N$ es el número de realizaciones sintéticas independientes del perfil generadas para cada combinación de geometría y clase de material. Cada realización está formada por capas de 1 m, representa la variación adoptada dentro de la clase correspondiente y no corresponde a un perfil medido. La caracterización adopta una presión de preconsolidación $POP=100$ kPa, un coeficiente de presión lateral en reposo $K_0=0.5$ y altura saturada nula. En cada capa se muestrean la clasificación USCS dentro del conjunto asignado, la relación de vacíos, el peso unitario y, para los suelos finos, el índice de plasticidad. Los parámetros de rigidez $A$, $C_e$ y $n$ se toman de las formulaciones tabuladas aplicables a la clase seleccionada.

Para la capa $k$, el incremento de presión octaédrica y la presión media se calculan mediante

$$
\begin{aligned}
\Delta p_k&=\frac{1+2K_0}{3}\gamma_k h_k,\\
p_{i,k}&=p_{o,k}+\Delta p_k,\\
p_{m,k}&=\frac{p_{i,k}+p_{o,k}}{2},
\end{aligned}
$${#eq-slope-pressure}

donde $\gamma_k$ y $h_k$ son el peso unitario y el espesor de la capa, $p_{o,k}$ es la presión en su límite superior y $p_{i,k}$ la presión en su límite inferior. La razón de sobreconsolidación es

$$
OCR_k=\max\!\left(\frac{p_{m,k}+POP}{p_{m,k}},1\right).
$${#eq-slope-ocr}

La formulación de rigidez adopta los parámetros tabulados por Ishihara [-@Ishihara1996]. El factor de relación de vacíos depende de la formulación tabulada:

$$
F_e=
\begin{cases}
C_e-\dfrac{e}{1+e}, & \text{formulación SS75},\\[6pt]
\dfrac{(C_e-e)^2}{1+e}, & \text{restantes formulaciones}.
\end{cases}
$${#eq-slope-void-factor}

SS75 identifica la formulación correspondiente en la tabla de parámetros; $e$ es la relación de vacíos y $C_e$ el parámetro tabulado. El exponente de sobreconsolidación $m_1$ se interpola a partir del índice de plasticidad en suelos finos y se adopta igual a cero en materiales granulares. Los parámetros de rigidez para las clases de material se presentan en el apéndice [-@sec-shear_appendix].

Con una presión de normalización $p_{\mathrm{ref}}=100$ kPa, el módulo de referencia y el módulo de cada capa se obtienen como

$$
\begin{aligned}
G_{\mathrm{ref}}&=A F_e OCR^{m_1}p_{\mathrm{ref}}^n,\\
G&=G_{\mathrm{ref}}\left(\frac{p_m}{p_{\mathrm{ref}}}\right)^n.
\end{aligned}
$${#eq-slope-modulus}

En estas expresiones, $A$ es el parámetro tabulado y $n$ el exponente de presión de la formulación aplicable. Cuando una clase de material admite más de una formulación tabulada, el módulo de la capa corresponde a la media aritmética de sus estimaciones.

El perfil obtenido se representa mediante la ley de potencia

$$
G(z)=G_o\left(\frac{z}{H_s}\right)^{m_o},
$${#eq-slope-profile}

equivalente al ajuste en el espacio logarítmico

$$
\ln G(z)=\ln G_o+m_o\ln\!\left(\frac{z}{H_s}\right).
$${#eq-slope-profile-fit}

La profundidad $z$ se mide desde la coronación, $G_o$ es el intercepto ajustado en $z/H_s=1$ y $m_o$ es la pendiente que representa el incremento de rigidez con la profundidad. Por tanto, $G_o$ procede del ajuste del perfil y no de la evaluación aislada de una capa basal. La velocidad basal de onda de corte se calcula como

$$
V_S^o=\sqrt{\frac{G_o}{\rho_{\mathrm{base}}}},
$${#eq-slope-basal-velocity}

donde $\rho_{\mathrm{base}}$ es la densidad correspondiente al peso unitario saturado de la capa basal y las unidades de $G_o$ se convierten de MPa a Pa.

La velocidad equivalente $V_{S30}$ se obtiene mediante el tiempo de viaje en los primeros 30 m:

$$
V_{S30}=\frac{30}{\displaystyle\sum_i\frac{h_i^{(30)}}{V_{S,i}}+\frac{\max(30-H_s,0)}{V_{\mathrm{ref}}}},
$${#eq-slope-vs30}

donde $h_i^{(30)}$ es el espesor de la capa $i$ comprendido dentro de los primeros 30 m. Cuando $H_s<30$ m, el espesor faltante se completa con la velocidad de la roca de referencia $V_{\mathrm{ref}}=760$ m/s; para taludes más altos sólo intervienen las capas contenidas en los primeros 30 m.

### Estimación del período fundamental {#sec-periods}

El período fundamental se determina con el modelo de viga de corte inhomogénea truncada de Dakoulas y Gazetas [-@DakoulasGazetas1985Inhomogeneous]:

$$
T_s=\frac{4\pi H_s}{a_1(2-m_o)V_S^o},
$${#eq-slope-period}

donde $a_1$ es la primera raíz modal correspondiente a $m_o$ y $\lambda_o$. La evaluación obtiene esa raíz por interpolación o extrapolación de la superficie modal y conserva el primer modo de vibración.

Las $N$ realizaciones de cada combinación se resumen mediante la media y los fractiles marginales de $G_o$, $m_o$, $V_S^o$ y $V_{S30}$. Para cada fila estadística se recalculan la raíz modal $a_1$ y $T_s$ a partir de los valores correspondientes de $m_o$ y $V_S^o$; por ello, los niveles reportados de $T_s$ son períodos derivados de cada fila estadística y no cuantiles empíricos directos de los períodos de las realizaciones individuales. Las etapas de demanda y desplazamiento adoptan los valores de $T_s$ y $V_{S30}$ de la fila media para cada escenario de geometría y material.

{{< include /_tbl/IDm.ES.qmd >}}
