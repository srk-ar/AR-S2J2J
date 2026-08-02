Seismic record selection defines the suite of recorded strong-motion time
histories used as input to response-history or dynamic analyses and associated
performance assessment. The selected motions are required to be compatible with
the seismic hazard controlling the site, the target response spectrum adopted
for the analysis case, the response quantities to be evaluated, and the
intended representation of record-to-record variability [@NIST2011]. Records
are screened using seismological and engineering criteria, including earthquake
magnitude, source-to-site distance, tectonic environment, site conditions,
component availability, usable frequency content, record quality, and spectral
shape over the period range of interest [@BakerCornell2006]. Event, station,
component, and provider metadata are retained so that each selected motion
remains traceable to the original recording.

Compatibility is evaluated using both seismological and spectral criteria. The
selected records should be consistent with the site-specific seismic hazard,
including the controlling magnitude range, source-to-site distance, tectonic
setting or source mechanism, and site conditions identified from the hazard
model and its disaggregation. They should also be compatible with the target
response spectrum over the period range relevant to the analysis. In this
chapter, spectral shape denotes agreement with the target spectral demand across
that range; it is not used as a separate conditional-spectrum or epsilon-based
selection rule. Where lower and upper compatibility envelopes are adopted, they
define the acceptable range around the target spectrum for the matched records.

The selected acceleration histories are adjusted using a spectral-matching
formulation based on adaptive modal representation. Empirical Mode
Decomposition introduced intrinsic mode functions as data-adaptive components
for nonlinear and non-stationary time series [@HuangEtAl1998]. The adopted
procedure uses Variational Mode Decomposition [@DragomiretskiyZosso2014] to
obtain modal components and a residual term for each recorded motion. The
VMD-based spectral-matching formulation applied in this study, including the
retained modal reconstruction, energy normalization, and bounded suite-level
record scaling, is documented by Verri Kozlowski [-@VerriKozlowskiInPress].



For record $i$, the acceleration history $x_i(t)$ in channel H1^[In the processed matched products, H1 denotes the canonical processed horizontal component obtained after deterministic component mapping and principal-axis rotation of the two horizontal channels], is represented as

$$
x_i(t) =
\sum_{m=1}^{K_i} x_{im}(t) + r_i(t),
$$

where $x_i(t)$ is the recorded acceleration history, $x_{im}(t)$ is modal
component $m$, $K_i$ is the number of modal components, and $r_i(t)$ is the
residual term. The retained modal set $\mathcal{M}_i$ contains the components
used for spectral adjustment. With modal multipliers $b_{im}$, the retained
components define the reconstructed acceleration history

$$
\tilde{x}_i(t;\mathbf{b}_i) =
\sum_{m \in \mathcal{M}_i} b_{im} x_{im}(t).
$$

After modal reconstruction, the record is normalized with

$$
e_i =
\left[
\frac{\sum_t x_i(t)^2}
{\sum_t \tilde{x}_i(t;\mathbf{b}_i)^2}
\right]^{1/2},
\qquad
y_i(t) = e_i\,\tilde{x}_i(t;\mathbf{b}_i).
$$

This normalization preserves the quadratic acceleration norm of the recorded
motion after modal reconstruction. Spectral compatibility is evaluated with the
spectral-acceleration operator

$$
S_{a,j}[z] = S_a[z](T_j,\xi),
$$

where $z(t)$ is an acceleration history, $T_j$ is a target period, and $\xi$ is
the oscillator damping ratio. The target period set may include $T_j=0$, which
is treated as the zero-period acceleration ordinate of the same response
spectrum. The matching formulation minimizes target-normalized spectral
residuals and compatibility-envelope excursions over the adopted period grid,
subject to the bounds adopted for the modal multipliers.

After modal reconstruction and normalization, the selected records are adjusted
at suite level with one positive coefficient per record. Let $c_i$ denote the
record-scale coefficient applied to the normalized reconstructed history
$y_i(t)$. The final matched acceleration history is

$$
Y_i(t) = c_i y_i(t)
       = c_i e_i \sum_{m \in \mathcal{M}_i} b_{im}x_{im}(t).
$$

The suite coefficients are obtained by minimizing the target-normalized
residual of the suite-mean spectrum together with the
compatibility-envelope excursions of the scaled record spectra,

$$
\min_{c_i > 0} \;
\frac{1}{J}\sum_{j=1}^{J} w_j\, r_j^{2}
\;+\;
\frac{\lambda_B}{N J}\sum_{i=1}^{N}\sum_{j=1}^{J} v_{ij}^{2},
\qquad
w_j =
\begin{cases}
\lambda_D & r_j < 0,\\
1 & r_j \ge 0,
\end{cases}
$$

with

$$
r_j = \frac{\bar{S}_a(T_j) - S_a^{t}(T_j)}{S_a^{t}(T_j)},
\qquad
\bar{S}_a(T_j) = \frac{1}{N}\sum_{i=1}^{N} c_i\, S_{a,j}[y_i],
$$

$$
v_{ij} = \max\!\left(
\frac{S_a^{\mathrm{lo}}(T_j) - c_i\, S_{a,j}[y_i]}{S_a^{\mathrm{lo}}(T_j)},\;
\frac{c_i\, S_{a,j}[y_i] - S_a^{\mathrm{hi}}(T_j)}{S_a^{\mathrm{hi}}(T_j)},\;
0\right),
$$

where $N$ is the number of selected records, $T_j$ ($j = 1,\dots,J$) are the
target periods, $S_a^{t}$ is the target spectrum, $S_a^{\mathrm{lo}}$ and
$S_a^{\mathrm{hi}}$ are the lower and upper compatibility envelopes,
$\lambda_B$ is the envelope-containment weight, and $\lambda_D \ge 1$ is the
deficit weight that penalizes suite-mean deficit relative to the target when
the acceptance criterion requires the mean spectrum not to fall below the
target ($\lambda_D = 1$ recovers the symmetric residual). The containment term keeps
each scaled record spectrum inside or near the compatibility envelope, so the
coefficients remain individually conditioned; when a project adopts an
admissible scaling range, it acts only as a backstop. The resulting suite is used to
generate the acceleration, velocity, and displacement histories required for
the dynamic analyses, together with response spectra, cumulative intensity
measures, and scalar intensity measures. Record-level metadata are retained
with these products so that each selected and adjusted motion remains
traceable to its original event, station, component, and provider or source
information. The reported products therefore document both compatibility with
the target spectrum and provenance of the records used in the analyses.
