La evaluación determinística caracteriza la demanda sísmica mediante un conjunto finito de escenarios de ruptura postulados. Cada escenario representa el sismo máximo creíble (MCE) de una fuente: el mayor terremoto razonablemente concebible a lo largo de una falla reconocida o dentro de una provincia tectónica geográficamente definida, bajo el marco tectónico actualmente conocido [@ICOLD2016]. Cada escenario conserva la identidad de la fuente tectónica, su régimen tectónico, la magnitud de momento adoptada, la geometría de ruptura y las distancias fuente--sitio requeridas por los modelos de movimiento del suelo. El objetivo es obtener la distribución condicional de la aceleración espectral para cada escenario y construir, período por período, las envolventes determinísticas empleadas en la comparación con la amenaza probabilística.

La construcción de los escenarios parte de la caracterización tectónica adoptada para cada fuente: régimen tectónico, magnitud y variantes geométricas explícitas de la ruptura. Cada realización representa una de esas variantes, recibe el mismo peso y aporta el vector de distancias exigido por los modelos de movimiento del suelo. El árbol lógico correspondiente al régimen tectónico aporta las ramas de modelo y sus pesos; cada combinación de realización de ruptura y rama GMM constituye una componente de la distribución del escenario [@OpenQuakeEngine].

### Formulación de la amenaza por escenarios {#sec-dsha_formulation}

La evaluación probabilística integra la probabilidad condicional de excedencia respecto de la recurrencia de las fuentes, mientras que la evaluación determinística calcula esa misma probabilidad condicionada a la ocurrencia del escenario postulado. Para el escenario $s=(m_s,\mathbf r_s,\boldsymbol\theta_s)$, $m_s$ es la magnitud de momento, $\mathbf r_s$ reúne las distancias fuente--sitio y $\boldsymbol\theta_s$ contiene los restantes parámetros de ruptura y la condición de sitio. La intensidad $I$ representa la ordenada máxima horizontal $S_a(T_n)$ al período $T_n$, y $i^*$ es el nivel cuya excedencia se evalúa.

Para una realización de ruptura $r$ y una rama GMM $g$, el logaritmo de la intensidad se representa mediante una distribución normal con media $\mu_{rg}=\ln\hat\eta_I(m_s,\mathbf r_r,F,S)$, evaluada con la formulación correspondiente, y desviación estándar $\sigma_{rg}=\sigma_{\ln I}$. En esta expresión, $\hat\eta_I$ es la mediana de la intensidad en unidades lineales, $\mathbf r_r$ es el vector de distancias de la realización, $F$ representa el estilo de falla y $S$ la condición de sitio. Al identificar cada par $(r,g)$ mediante $k$, el peso de la componente es

$$
w_k=\frac{v_g}{N_R},\qquad \sum_k w_k=1,
$${#eq-scenario-weights}

donde $v_g$ es el peso de la rama $g$ del árbol lógico y $N_R$ es el número de variantes explícitas de ruptura, representadas por realizaciones equiponderadas. La función condicional de excedencia del escenario se obtiene como

$$
G_s(i^*)=P\!\left[I>i^*\mid m_s,\mathbf r_s,\boldsymbol\theta_s\right]=\sum_k w_k\left[1-\Phi\!\left(\frac{\ln i^*-\mu_k}{\sigma_k}\right)\right],
$${#eq-dsha-exceedance}

donde $\mu_k$ y $\sigma_k$ corresponden a la componente $k$ y $\Phi$ es la función de distribución acumulada normal estándar. La distribución acumulada de la intensidad es el complemento de la función de excedencia:

$$
F_s(a)=1-G_s(a)=\sum_k w_k\,\Phi\!\left(\frac{\ln a-\mu_k}{\sigma_k}\right).
$${#eq-scenario-mixture}

Los fractiles se obtienen por inversión numérica de $F_s$, mientras que la media se calcula directamente a partir de las componentes lognormales:

$$
S_a^{(p)}=F_s^{-1}(p),\qquad \mathrm E[S_a]=\sum_k w_k\exp\!\left(\mu_k+\tfrac12\sigma_k^2\right).
$${#eq-scenario-moments}

El cálculo obtiene para cada escenario la mediana, los percentiles 84, 90 y 95 y la media. La evaluación se realiza analíticamente a partir de $(\mu_k,\sigma_k,w_k)$; la comparación de este capítulo presenta la media y el percentil 84 de cada escenario. Las ordenadas corresponden a la componente máxima horizontal con 5% de amortiguamiento crítico y se evalúan en la condición de referencia $V_{\mathrm{ref}}=760$ m/s; la PGA corresponde a $T_n=0$. Esta condición proporciona la referencia computacional desde la cual el modelo de respuesta de sitio deriva las condiciones de sitio efectivamente evaluadas ([@sec-site_uncertainty]).

Los espectros de los escenarios permanecen separados y conservan la identidad física del terremoto de cada fuente en el rango de períodos. La nomenclatura del reporte define dos envolventes sobre el conjunto de escenarios, construidas de manera distinta. La envolvente del fractil superior, reportada como MCE (84%), es el máximo por período de las ordenadas de los escenarios en ese fractil,

$$
S_{a,\mathrm{MCE}}^{(0.84)}(T_n)=\max_s S_a^{(s,0.84)}(T_n),
$${#eq-dsha-envelope}

un máximo sobre valores que no selecciona un escenario. La envolvente media, reportada como MCE, no es un máximo: sus ordenadas combinan las contribuciones de todas las ramas de escenario referidas a la trayectoria media de referencia y, por lo tanto, no pertenecen a ningún escenario individual. Ninguna de las dos envolventes identifica un par magnitud–distancia controlante. La comparación con la amenaza probabilística superpone la media y el percentil 84 de cada escenario a los espectros medios de amenaza uniforme disponibles y utiliza el espectro medio para $T_R=10{,}000$ años como nivel de comparación en los períodos seleccionados, junto con ambas envolventes determinísticas.
