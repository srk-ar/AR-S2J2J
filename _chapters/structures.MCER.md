### MCER and Elastic Design Spectra (ASCE) {#sec-mcer}

Seismic demand for conventional structures is established in accordance with ASCE/SEI 7-22 from the hazard and site-response spectra developed in Part I. Section 11.4.7 refers to the site-specific procedures of Sections 21.1 and 21.2; where those procedures are applied, the design spectrum and its parameters are determined in accordance with Sections 21.3 and 21.4 [@ASCE722, secs. 11.4.7, 21.1--21.4].

Under the standard, the MCER ordinates correspond to the direction of maximum horizontal response with 5% critical damping and are associated with a 1% probability of collapse in 50 years. The probabilistic ordinates follow Section 21.2.1: for each structural period and site condition $V_{S30}$, the ordinate results from iterative integration of the site-specific hazard curve with the lognormal collapse fragility prescribed by the standard — 10% probability of collapse at the ordinate and logarithmic standard deviation 0.6 — until a 1% collapse probability in 50 years is attained [@ASCE722, sec. 21.2.1]. The risk-targeted procedure adopted by the standard originates in Luco *et al.* [-@Luco2007].

The directional scaling of the standard is conditional: it applies only where the spectral accelerations predicted by the ground-motion models do not represent the maximum response in the horizontal plane, with factors of 1.2 for $T\leq0.2$ s, 1.25 for $T=1.0$ s and 1.3 for $T\geq10$ s where the models predict the geometric mean or a similar metric of the two horizontal components [@ASCE722, sec. 21.2]. The spectra in this report retain the horizontal measure supplied by the ground-motion models, with no additional directional factor.

In accordance with Section 21.3, the elastic design spectral accelerations follow from the MCER ordinates as

$$
S_a(T)=\frac{2}{3}S_{aM}(T).
$${#eq-structures-design-spectrum}

For site-specific procedures, the design acceleration parameters are computed as [@ASCE722, sec. 21.4]

$$
\begin{aligned}
S_{DS}
  &=0.9\max_{T\in[0.2,5]\,\mathrm{s}}S_a(T),\\
S_{D1}
  &=\max\!\left[
      0.9\max_{T\in[1,T^*]\,\mathrm{s}}\bigl(T\,S_a(T)\bigr),
      S_a(1\,\mathrm{s})
    \right],\\
T^*
  &=\begin{cases}
      2\,\mathrm{s}, & \bar v_S>442\,\mathrm{m/s},\\
      5\,\mathrm{s}, & \bar v_S\leq442\,\mathrm{m/s}.
    \end{cases}
\end{aligned}
$${#eq-structures-design-parameters}

The corresponding MCER parameters follow from the design values as

$$
S_{MS}=1.5S_{DS},\qquad S_{M1}=1.5S_{D1}.
$${#eq-structures-mcer-parameters}

The chapter retains the site-specific MCER spectra for the evaluated $V_{S30}$ conditions, with one ordinate per period of the hazard curves; the results report the MCER PGA and the maximum spectral ordinates per site condition.

Section 21.2.2 bounds the MCER spectrum from below by the values tabulated in Table 21.2-1, defined by site class from $T=0$ to 10 s and including PGA, and admits an exception: where the probabilistic spectrum remains below those values at all periods, deterministic motions are not calculated [@ASCE722, sec. 21.2.2]. Verifying that limit consists of comparing the probabilistic spectrum with the tabulated values at each evaluated site condition. The 80% floor of Section 21.2.3 is anchored to the USGS Seismic Design Geodatabase and its application is bounded by that database's coverage [@ASCE722, sec. 21.2.3].
