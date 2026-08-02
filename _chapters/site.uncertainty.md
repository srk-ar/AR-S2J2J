### Uncertainty Model {#sec-site_uncertainty}

The site-response stage transforms the reference-rock demand into the site-condition demand through the amplification factor $F(T_n, V_{S30})$, modeled as a lognormal variable ([@sec-site-response]): its median depends on the structural period, the site stiffness, and the intensity of the rock motion (nonlinear soil response, anchored at the rock PGA), and its dispersion $\sigma_{\ln F}$ is prescribed by the amplification model ([@eq-site-sigma-decomp]). Site-condition uncertainty therefore combines two statistically independent sources -- the distribution of the reference-rock ordinate and the dispersion of the amplification model -- so that, in log space,

$$
\mathrm{Var}[\ln S_a^{F}] = \mathrm{Var}[\ln S_a] + \mathrm{Var}[\ln F]
$${#eq-site-var}

The composition of the two distributions is evaluated period by period. The site-condition ordinate is the product of the rock ordinate and the amplification factor ([@eq-site-af]), so that $\ln S_a^{F} = \ln S_a + \ln F$, with $\ln F$ the lognormal variable of [@eq-site-lnf] anchored at the rock PGA of the same realization. For deterministic scenarios, the rock demand is the analytic mixture of [@eq-scenario-mixture]. Writing $(\mu_k^{0}, \sigma_k^{0})$ for the PGA parameters of component $k$, $q = \ln pga^*$ for its rock PGA, and $\rho = \rho(T_n, \mathrm{PGA})$ for the within-event inter-period correlation of [@eq-site-rho], the site-condition ordinate conditional on the component and its PGA is normal,

$$
\ln S_a^{F} \,\big|\, (k, q) \;\sim\; \mathcal{N}\!\left( \mu_k + \rho\,\frac{\sigma_k}{\sigma_k^{0}}\left(q - \mu_k^{0}\right) + \mu_{\ln F}\!\left(T_n, V_{S30}, e^{q}\right),\;\; \left(1-\rho^{2}\right)\sigma_k^{2} + \sigma_{\ln F}^{2} \right)
$${#eq-site-conditional}

and the site-condition distribution follows by exact integration over the PGA of each component,

$$
F^{F}(y) \;=\; \sum_{k} w_k \int_{-\infty}^{\infty} \Phi\!\left(\frac{\ln y - \mu_k(q)}{\varsigma_k(q)}\right) \varphi\!\left(\frac{q - \mu_k^{0}}{\sigma_k^{0}}\right) \frac{\mathrm{d}q}{\sigma_k^{0}}
$${#eq-site-mixture}

where $\mu_k(q)$ and $\varsigma_k(q)$ denote the conditional mean and standard deviation of [@eq-site-conditional] and $\varphi$ is the standard normal density. Fractiles of the site-condition spectrum are the quantiles of $F^{F}$, and its mean takes the closed form of [@eq-scenario-moments] applied to the conditional parameters. For probabilistic spectra, the rock demand is characterized by the hazard curve and its fractiles -- the epistemic distribution across the source and ground-motion logic trees ([@eq-mean-hazard]), with aleatory variability already integrated in the exceedance rates -- and the amplification dispersion is composed with that distribution in the same manner.

The site-condition spectrum reports a single quantile scale: each fractile is a quantile of the total conditional distribution, pooling the hazard and amplification contributions into one explicitly declared measure of dispersion. Both contributions are also reported separately -- reference-rock spectra and amplification factors -- so the composition remains traceable.

Where jointly distributed spectral ordinates at several periods are required -- notably in the displacement analysis, which evaluates coherent tuples (PGA, $S_a(1.3\,T_n)$, $S_a(1.5\,T_n)$) per realization -- the correlation between periods follows Baker and Jayaram [-@BakerJayaram2008]:

$$
\rho(T_i, T_j) = 1 - \cos\!\left(\frac{\pi}{2} - 0.366\,\ln\frac{T_{\max}}{\max(T_{\min},\,0.109)}\right)
$${#eq-site-rho}

for $T_{\min} > 0.109$ s, with the companion piecewise expressions of Baker and Jayaram [-@BakerJayaram2008, Eqs. 5--6] covering shorter periods; the model is valid for periods between 0.01 and 10 s and carries no magnitude or distance dependence. Site-condition spectra are themselves per-period marginal quantities; inter-period correlation enters where joint ordinates are consumed.
