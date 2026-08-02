The amplitude model estimates peak blast-vibration values over the distance–charge domain. Responses are PPV and PPA as scalar resultants and as longitudinal, transverse, and vertical component amplitudes. For measured component values,

$$
\mathrm{PPV} =
\sqrt{\mathrm{PPV}_L^2+\mathrm{PPV}_T^2+\mathrm{PPV}_V^2},\qquad
\mathrm{PPA} =
\sqrt{\mathrm{PPA}_L^2+\mathrm{PPA}_T^2+\mathrm{PPA}_V^2}.
$$ {#eq-amplitude-resultants}

Each response uses observations containing its required component family. The training population combines site records with complementary records admitted only when their source distance or charge lies outside the ranges covered by the site. Within those ranges, local observations are the only training information. PPV and PPA units are checked for homogeneity, and non-physical acceleration readings are excluded before model fitting.

Explanatory variables are constructed from maximum instantaneous charge $Q$, source–receiver distance $D$, scaled distance $S$, and monotonic transformations of $Q$ and $D$:

$$
\mathbf{x}(D,Q)=
\left[
Q,\ \log Q,\ Q^{-1},\
D,\ \log D,\ D^{-1},\
S
\right],
\qquad
S=\frac{D}{\sqrt{Q}} .
$$ {#eq-amplitude-feature-vector}

Observations and the prediction grid share this representation but serve different purposes. Observations participate in fitting; the grid contains $D$–$Q$ combinations without observed responses and defines the domain over which the model is evaluated.
