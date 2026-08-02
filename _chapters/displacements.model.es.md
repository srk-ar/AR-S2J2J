### Modelos de desplazamiento permanente

La idealización de Newmark representa la masa potencialmente deslizante mediante un bloque cuya resistencia se moviliza cuando la aceleración impulsora supera la aceleración de fluencia $k_y g$ [@Newmark1965]. Los modelos rígidos relacionan el desplazamiento con medidas de la excitación basal; los modelos flexibles incorporan además la respuesta dinámica de la masa mediante $T_s$ y la aceleración espectral evaluada en un período proporcional a $T_s$.

Las formulaciones activas expresan el desplazamiento positivo $D_n$, en centímetros, mediante

$$
D_n=\exp\!\left(\mu_{\ln D}+\epsilon\sigma_{\ln D}\right),
\qquad \epsilon\sim\mathcal N(0,1),
$${#eq-newmark-lognormal}

donde $\mu_{\ln D}$ y $\sigma_{\ln D}$ son la media y la desviación estándar de $\ln D_n$ definidas por cada modelo, y $\epsilon$ es un residuo normal estándar. Algunas formulaciones fuente contienen una rama discreta de desplazamiento nulo o despreciable; la evaluación implementada utiliza exclusivamente la rama lognormal positiva. En las ecuaciones siguientes, $k_y$, PGA y $S_a$ se expresan en unidades de $g$, $I_A$ en m/s y $T_s$ en segundos. La magnitud de referencia del proyecto, $M_w=$ `r .fmt(Mw.gmdp, 1)`, se aplica como entrada constante a los períodos de retorno, geometrías, materiales y sitios evaluados.

**Modelos de bloque rígido.** La formulación AM88 de Ambraseys y Menu [-@AmbraseysMenu1988] utiliza la razón entre aceleración de fluencia y PGA, limitada para mantener el dominio logarítmico, $r^\star=\min(k_y/\mathrm{PGA},0.9999)$:

$$
\begin{aligned}
\mu_{\ln D}
  &=\ln(10)\left[0.90+\log_{10}\!\left((1-r^\star)^{2.53}(r^\star)^{-1.09}\right)\right],\\
\sigma_{\ln D}&=0.30\ln(10).
\end{aligned}
$${#eq-newmark-am88}

La formulación JB07 de Jibson [-@Jibson2007] incorpora la intensidad de Arias y la razón $k_y/\mathrm{PGA}$:

$$
\begin{aligned}
\mu_{\ln D}
  &=\ln(10)\left[0.561\log_{10}I_A
    -3.833\log_{10}\!\left(\frac{k_y}{\mathrm{PGA}}\right)-1.474\right],\\
\sigma_{\ln D}&=0.616\ln(10).
\end{aligned}
$${#eq-newmark-jb07}

La formulación SR08 de Saygili y Rathje [-@SaygiliRathje2008] define $r=k_y/\mathrm{PGA}$ y combina PGA e intensidad de Arias:

$$
\begin{aligned}
\mu_{\ln D}
  ={}&2.39-5.24r-18.78r^2+42.01r^3-29.15r^4\\
     &-1.56\ln\mathrm{PGA}+1.38\ln I_A,\\
\sigma_{\ln D}={}&0.46+0.56r.
\end{aligned}
$${#eq-newmark-sr08}

**Modelos de bloque flexible.** La formulación BT07 de Bray y Travasarou [-@BrayTravasarou2007] emplea $S_a=S_a(1.5T_s)$ y $M_w$:

$$
\begin{aligned}
\mu_{\ln D}={}&a_0-2.83\ln k_y-0.333(\ln k_y)^2
  +0.566\ln k_y\ln S_a\\
 &+3.04\ln S_a-0.244(\ln S_a)^2
  +1.50T_s+0.278(M_w-7),\\
a_0={}&
\begin{cases}
-0.22, & T_s<0.05\ \mathrm{s},\\
-1.10, & T_s\geq0.05\ \mathrm{s},
\end{cases}\\
\sigma_{\ln D}={}&0.66.
\end{aligned}
$${#eq-newmark-bt07}

La formulación BM17 de Bray, Macedo y Travasarou [-@BrayEtAl2018] representa movimientos de interfaz de subducción con $S_a=S_a(1.5T_s)$:

$$
\begin{aligned}
\mu_{\ln D}&=a_0+a_1\ln S_a-0.225(\ln S_a)^2,\\
a_1&=3.060+0.538\ln k_y,\\
a_{0,<}={}&-5.864+0.550M_w-9.421T_s\\
           &-3.353\ln k_y-0.390(\ln k_y)^2,\\
a_{0,\geq}={}&-6.896+0.550M_w+3.081T_s-0.803T_s^2\\
              &-3.353\ln k_y-0.390(\ln k_y)^2,\\
a_0&=
\begin{cases}
a_{0,<}, & T_s<0.1\ \mathrm{s},\\
a_{0,\geq}, & T_s\geq0.1\ \mathrm{s},
\end{cases}\\
\sigma_{\ln D}&=0.73.
\end{aligned}
$${#eq-newmark-bm17}

La formulación BM19 de Bray y Macedo [-@BrayMacedo2019] representa movimientos corticales someros ordinarios con $S_a=S_a(1.3T_s)$:

$$
\begin{aligned}
\mu_{\ln D}&=a_0+\left(2.649+0.344\ln k_y\right)\ln S_a
  -0.090(\ln S_a)^2,\\
a_{0,<}={}&-4.684+0.603M_w-9.471T_s\\
           &-2.482\ln k_y-0.244(\ln k_y)^2,\\
a_{0,\geq}={}&-5.981+0.603M_w+3.223T_s-0.945T_s^2\\
              &-2.482\ln k_y-0.244(\ln k_y)^2,\\
a_0&=
\begin{cases}
a_{0,<}, & T_s<0.1\ \mathrm{s},\\
a_{0,\geq}, & T_s\geq0.1\ \mathrm{s},
\end{cases}\\
\sigma_{\ln D}&=0.72.
\end{aligned}
$${#eq-newmark-bm19}

La configuración activa contiene AM88, JB07, SR08 y BT07. La quinta formulación es BM17 cuando el proyecto declara control de subducción y BM19 cuando declara control cortical; por tanto, cada evaluación aplica cinco formulaciones, no ambas ramas BM simultáneamente. Los predictores y las dispersiones se aplican con la forma publicada de cada modelo; el soporte numérico de $k_y$ corresponde al intervalo definido en la sección de demanda y no introduce una corrección adicional de dominio.
