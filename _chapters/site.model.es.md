La evaluación de amenaza en roca de referencia se traslada a las condiciones someras del proyecto para establecer los espectros y las aceleraciones empleados en diseño. La geología superficial modifica la amplitud y el contenido espectral del movimiento: la respuesta lineal depende del contraste de rigidez, mientras que la respuesta no lineal depende además del nivel de deformación inducido por la intensidad del movimiento. Los suelos de menor rigidez pueden amplificar la demanda en períodos intermedios y largos y reducirla en períodos cortos cuando se activa la respuesta no lineal; la roca rígida produce modificaciones menores respecto del movimiento de referencia [@Baker2021; @Stewart2020; @Hashash2020].

La evaluación representa estos efectos mediante dos ramas independientes y adopta, para cada período estructural, período de retorno, estadístico y condición $V_{S30}$, la mayor ordenada de ambas ramas como demanda envolvente.

La rama directa evalúa en OpenQuake el árbol lógico de modelos de movimiento del suelo para las condiciones $V_{S30}$ del proyecto (`r paste(Vs30.gmdp, collapse = ", ")` m/s). Cada modelo incorpora su término empírico de sitio al estimar $S_a(T_n,V_{S30})$; los pesos del árbol lógico representan las alternativas epistémicas adoptadas y la variabilidad aleatoria de cada modelo queda integrada en las curvas de excedencia. Esta rama conserva, por tanto, la misma caracterización de fuentes y de movimiento del suelo utilizada en la evaluación en roca, con los términos de sitio evaluados directamente en la condición objetivo.

El término de sitio de las GMM y el modelo externo representan respuestas ergódicas medias derivadas de conjuntos de registros; la caracterización de un perfil estratigráfico específico corresponde a una evaluación de respuesta de sitio separada.

La segunda rama parte de la amenaza calculada para la condición de referencia $V_{\mathrm{ref}}=760\,\mathrm{m/s}$ y la transforma mediante el modelo ergódico de amplificación NGA-East de Stewart *et al.* [-@Stewart2020] y Hashash *et al.* [-@Hashash2020]. Para un período $T_n$, una condición $V_{S30}$ y un PGA de entrada $pga^*$, el factor $F$ se representa como una variable lognormal,

$$
\ln F \sim \mathcal{N}\!\left(\mu_{\ln F},\;\sigma_{\ln F}^{2}\right),
$${#eq-site-lnf}

donde $\mu_{\ln F}$ es la log-amplificación media condicional y $\sigma_{\ln F}$ es la dispersión total del modelo. La media combina el ajuste entre las referencias de 760 y 3000 m/s, el término lineal dependiente de $V_{S30}$ y el término no lineal dependiente de $pga^*$. La dispersión se expresa como

$$
\sigma_{\ln F}^{2}=\sigma_L^{2}+\sigma_I^{2}+\sigma_{NL}^{2},
$${#eq-site-sigma-decomp}

donde $\sigma_L$ corresponde al término lineal de sitio, $\sigma_I$ al cambio entre horizontes de referencia y $\sigma_{NL}$ al término no lineal dependiente de la intensidad. La formulación de los componentes y el tratamiento de la referencia se detallan en [@sec-amplification]. La ordenada transformada se obtiene como

$$
S_a^{F}\!\left(T_n,V_{S30}\right)=F\!\left(T_n,V_{S30},pga^*\right)\,S_a\!\left(T_n,V_{\mathrm{ref}}\right).
$${#eq-site-af}

El cálculo conserva la rama directa $S_a^{\mathrm{GMPE}}$ y la rama transformada $S_a^{F}$. La ordenada reportada en las tablas de diseño es la envolvente fila a fila,

$$
\begin{aligned}
S_a^{\max}\!\left(T_n,V_{S30},T_R,p\right)=\max\!\big\{&S_a^{\mathrm{GMPE}}\!\left(T_n,V_{S30},T_R,p\right),\\
&S_a^{F}\!\left(T_n,V_{S30},T_R,p\right)\big\},
\end{aligned}
$${#eq-site-envelope}

donde $T_R$ es el período de retorno y $p$ identifica el estadístico disponible. Esta envolvente constituye la regla de agregación adoptada para la demanda de diseño: los UHS permiten comparar las dos ramas y las tablas de PGA y PSA adoptan directamente $S_a^{\max}$.
