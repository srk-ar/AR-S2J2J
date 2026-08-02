### Modelo de incertidumbre {#sec-site_uncertainty}

La transformación de la demanda en roca se evalúa período por período y condicionada al PGA de la misma realización, porque el término no lineal de $F$ depende de esa intensidad. En espacio logarítmico, [@eq-site-af] se expresa como $\ln S_a^F=\ln S_a+\ln F$. Para una componente $k$ de la distribución en roca y $q=\ln pga^*$, la varianza condicional de la ordenada transformada es

$$
\operatorname{Var}\!\left[\ln S_a^{F}\mid k,q\right]=\left(1-\rho^2\right)\sigma_k^2+\sigma_{\ln F}^{2}\!\left(T_n,V_{S30},e^q\right),
$${#eq-site-var}

donde $\sigma_k$ es la dispersión de $\ln S_a(T_n)$ en la componente, $\rho=\rho(T_n,\mathrm{PGA})$ es la correlación intraevento entre la ordenada espectral y el PGA, y $\sigma_{\ln F}$ es la dispersión de amplificación de [@eq-site-sigma-decomp]. Esta formulación conserva la dependencia entre $S_a(T_n)$, el PGA que activa la respuesta no lineal y el factor de amplificación.

Para los escenarios determinísticos, la demanda en roca se representa mediante la mixtura analítica de [@eq-scenario-mixture]. Sean $(\mu_k^0,\sigma_k^0)$ los parámetros de PGA y $(\mu_k,\sigma_k)$ los parámetros de $S_a(T_n)$ para la componente $k$. La ordenada en condición de sitio, condicionada a la componente y a su PGA, sigue

$$
\begin{aligned}
\ln S_a^{F}\mid(k,q)\sim\mathcal{N}\!\Bigg(&\mu_k+\rho\frac{\sigma_k}{\sigma_k^0}(q-\mu_k^0)
+\mu_{\ln F}\!\left(T_n,V_{S30},e^q\right),\\
&\left(1-\rho^2\right)\sigma_k^2+\sigma_{\ln F}^{2}\!\left(T_n,V_{S30},e^q\right)\Bigg).
\end{aligned}
$${#eq-site-conditional}

La distribución marginal en condición de sitio se obtiene integrando sobre el PGA de cada componente,

$$
\begin{aligned}
F^{F}(y)=\sum_k w_k\int_{-\infty}^{\infty}&\Phi\!\left(\frac{\ln y-\mu_k(q)}{\varsigma_k(q)}\right)
\varphi\!\left(\frac{q-\mu_k^0}{\sigma_k^0}\right)\\
&\times\frac{\mathrm{d}q}{\sigma_k^0},
\end{aligned}
$${#eq-site-mixture}

donde $w_k$ es el peso de la componente, $\mu_k(q)$ y $\varsigma_k(q)$ son los parámetros condicionales de [@eq-site-conditional], y $\Phi$ y $\varphi$ son la función de distribución y la densidad normal estándar. Los cuantiles de $F^F$ definen los fractiles determinísticos en condición de sitio, y la media se evalúa con los momentos condicionales correspondientes de [@eq-scenario-moments].

En la rama probabilística implementada, la transformación recibe el UHS medio calculado en $V_{\mathrm{ref}}=760\,\mathrm{m/s}$; la dispersión del modelo de amplificación genera las estadísticas disponibles para la condición de sitio. La rama directa conserva la integración de la variabilidad aleatoria realizada en las curvas de excedencia de OpenQuake. La figura de UHS presenta ambas ramas y las tablas de PGA y PSA presentan la envolvente de [@eq-site-envelope], con el estadístico identificado explícitamente en cada fila o columna.

En las operaciones con ordenadas conjuntamente distribuidas en varios períodos —por ejemplo PGA, $S_a(1.3T_n)$ y $S_a(1.5T_n)$ para la evaluación de desplazamientos—, la correlación entre períodos se representa con el modelo de Baker y Jayaram [-@BakerJayaram2008]. Para el tramo $T_{\min}>0.109$ s,

$$
\rho(T_i,T_j)=1-\cos\!\left(\frac{\pi}{2}-0.366\ln\frac{T_{\max}}{\max(T_{\min},0.109)}\right),
$${#eq-site-rho}

complementado por las expresiones por tramos de Baker y Jayaram [-@BakerJayaram2008, Ecs. 5--6] para períodos más cortos. El modelo cubre el intervalo de 0.01 a 10 s, es independiente de la magnitud y la distancia, y se utiliza en las operaciones de coherencia conjunta entre ordenadas; los UHS reportados continúan siendo cantidades marginales por período.
