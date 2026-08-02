The deterministic assessment characterizes the maximum credible earthquake as a set of postulated rupture scenarios, each defined by a tectonic source, a moment magnitude, and a source-to-site distance, following the ICOLD definition of the largest reasonably conceivable earthquake along a recognized fault or within a geographically defined tectonic province under the presently known tectonic framework [@icold2016]. Each scenario is evaluated conditionally: the analysis quantifies the distribution of spectral acceleration at the site given that the postulated earthquake occurs, and the scenario set covers the tectonic regimes capable of governing the site demand. This chapter develops the scenario hazard formulation, presents the uncertainty model that underlies it, and reports the scenario spectra together with their comparison against the probabilistic benchmark.

The deterministic assessment develops seismic scenarios upon which the ground-motion evaluation is based: each scenario postulates the occurrence of an earthquake of specified size at a specified location, whose motion is estimated with a specified empirical model. Each scenario represents the maximum credible earthquake (MCE) of one source: the largest earthquake reasonably conceivable along a recognized fault or within a defined source zone. The initial stages are shared with the probabilistic assessment — identifying every source capable of generating strong shaking at the site and selecting the prediction models appropriate to the sources, the seismotectonic setting, and the site conditions —; the fundamental difference lies in the treatment of occurrence: the probabilistic assessment incorporates the random spatial and temporal distribution of earthquakes through the recurrence rates, whereas the deterministic one conditions the evaluation on the occurrence of the postulated scenario.

The deterministic development comprises the identification of the sources capable of generating strong shaking at the site and their characterization — location, geometry, rupture style, and largest conceivable size —, the postulation of the maximum credible earthquake of each source under the known tectonic framework, the selection of the ground-motion models appropriate to the tectonic regime of each source and to the site condition, and the evaluation of the source-to-site distances required by each model over the rupture realizations of the scenario.

### Scenario Hazard Formulation {#sec-dsha_formulation}

Unlike the probabilistic assessment, the deterministic evaluation involves no occurrence rates and no summation of source contributions: there is no activity rate $\nu_0$ and no counterpart of [@eq-hazard-sum]. The scenario $s = \left(m_s, \mathbf r_s, \boldsymbol\theta_s\right)$ is postulated -- its occurrence is given -- and the assessment evaluates directly the conditional exceedance probability of the ground-motion model: the same kernel $P\left[I > i^* \mid m, \mathbf r\right]$ that the hazard integral [@eq-hazard-integral] weights against the recurrence model. The vector $\boldsymbol\theta_s$ collects the scenario parameters beyond magnitude and distance: the rupture geometry -- hypocentral depth, dip, rupture style, plane orientation -- and the site condition $S$ of the ground-motion model.

Because the rupture geometry is known only within credible ranges and several ground-motion models coexist, the conditional evaluation runs over rupture realizations $r$ and logic-tree models $g$. For a realization $r$ and a model $g$, the logarithm of the spectral ordinate at structural period $T_n$ is normally distributed with median $\mu_{rg} = \ln \hat{\eta}_I\!\left(m, \mathbf{r}_r, F, S\right)$, evaluated on the rupture geometry of realization $r$ per [@eq-gmpe], and standard deviation $\sigma_{rg} = \sigma_{\ln I}$ of model $g$. Indexing the realization--model pairs by $k = (r, g)$, the component weights combine the uniform realization weights with the branch weights of the logic tree ([@eq-weight-norm]):

$$
w_{k} = \frac{v_g}{N_R}, \qquad \sum_{k} w_{k} = 1
$${#eq-scenario-weights}

where $v_g$ is the branch weight of model $g$ and $N_R$ is the number of rupture realizations. The scenario exceedance function is the weighted mixture of the component exceedance probabilities:

$$
G_s(i^*) \;=\; P\left[I > i^* \mid m_s, \mathbf r_s, \boldsymbol\theta_s\right] \;=\; \sum_{k} w_k \left[1 - \Phi\!\left(\frac{\ln i^* - \mu_k}{\sigma_k}\right)\right]
$${#eq-dsha-exceedance}

where $\mu_k$ and $\sigma_k$ abbreviate $\mu_{rg}$ and $\sigma_{rg}$, and $\Phi$ is the standard normal cumulative function. The scenario distribution is its complement, a finite mixture of lognormal components:

$$
F(a) \;=\; 1 - G_s(a) \;=\; \sum_{k} w_k \, \Phi\!\left(\frac{\ln a - \mu_k}{\sigma_k}\right)
$${#eq-scenario-mixture}

The reported fractiles follow by numerical inversion of $F$, and the mean in closed form:

$$
S_a^{(p)} = F^{-1}(p), \qquad \mathrm{E}[S_a] = \sum_k w_k \exp\!\left(\mu_k + \tfrac{1}{2}\sigma_k^{2}\right)
$${#eq-scenario-moments}

The reported spectrum for each scenario consists of the median together with the 84th, 90th, and 95th percentile ordinates and the mean of the scenario distribution ([@eq-scenario-moments]). The evaluation is analytic -- the mixture is computed directly from the tabulated component parameters $(\mu_k, \sigma_k, w_k)$ -- so the reported quantiles carry no simulation noise and no truncation of the underlying distributions. The median provides a robust central estimate of the scenario demand, and the upper fractiles support the selection of the design performance level according to the applicable safety criteria.

Each tectonic source is reported as a separate conditional spectrum, preserving the physical identity of that source's earthquake across the period range. The report nomenclature defines two envelopes over the scenario set, constructed differently. The upper-fractile envelope, reported as MCE (84%), is the per-period maximum of the scenario ordinates at that fractile,

$$
S_{a,\mathrm{MCE}}^{(0.84)}(T_n)=\max_s S_a^{(s,0.84)}(T_n),
$${#eq-dsha-envelope}

a maximum over values that does not select a scenario. The mean envelope, reported as MCE, is not a maximum: its ordinates combine the contributions of all scenario branches referred to the mean reference path, and therefore belong to no individual scenario. Neither envelope identifies a controlling magnitude-distance pair. The comparison with the probabilistic hazard superimposes the mean and the 84th percentile of each scenario on the available mean uniform-hazard spectra, and uses the mean spectrum for $T_R=10{,}000$ years as a comparison level at the selected periods, alongside both deterministic envelopes.

Scenario spectra are defined at the reference rock condition: the site term of $\boldsymbol\theta_s$ is fixed at the reference rock $S$ ($V_{S30} = 760$ m/s). Site-condition scenario spectra follow from the composition of $G_s$ with the site-response amplification model ([@sec-site_uncertainty]) and report the same fractile set on a single quantile scale representing the total conditional demand at the site.

The behavior of the GMM set across the magnitude--distance ranges relevant to the scenarios is documented in the Ground Motion Models chapter ([-@sec-gmm_appendix]), which records the median and total dispersion of each individual formulation together with the fractiles of the weighted mixture.
