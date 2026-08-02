The purpose of this chapter is to establish the multi-response predictive component that relates source-to-receptor distance and maximum instantaneous charge (MIC) to peak particle velocity and peak particle acceleration. The formulation defines the modeling population and domain of application, represents blasting conditions, combines learner families using out-of-fold evidence, incorporates dependence among responses, and characterizes predictive error. Longitudinal, transverse, and vertical PPV predictions set the amplitude of the processed time histories used in the scenarios; PPA predictions complete the demand characterization and contribute to the multi-response refinement.

The local population comprises site blasts for which source-to-receptor distance, maximum instantaneous charge, and a complete family of PPV or PPA components are available. PPV amplitudes are expressed in $\mathrm{mm/s}$ and PPA amplitudes in $g$. Each component response is estimated from the observations for which that measurement is available, whereas the resultants require all three components; consequently, the number of available observations can differ among responses.

The supplementary S11D source contributes observations outside the rectangular envelope covered by the site: their distance lies outside the local distance interval, their charge lies outside the local charge interval, or both conditions apply. Only local information is used within the envelope. The included external observations contribute to the global fits under the assumption that their amplitude--distance--charge relationships are transferable from observations outside the local envelope.

PPA quality control excludes three-component observations with exactly equal values in all three orthogonal components and exact values of one component repeated at ten or more distinct distances within a single source. These patterns are not consistent with independent measurements of the acceleration components. The exclusion is limited to the affected PPA measurement; PPV measurements from the same observation are retained.

Predictions are evaluated over a Cartesian grid of distance and charge using the same covariate representation applied in fitting. The grid defines the evaluated conditions, does not add observations, and does not extend the observed domain. Scenario generation uses the subset corresponding to the selected operating conditions.

The modeled responses are PPV and PPA in the longitudinal, transverse, and vertical components, together with a scalar resultant for each family. The velocity resultant is defined as

$$
\mathrm{PPV}=
\sqrt{\mathrm{PPV}_L^2+\mathrm{PPV}_T^2+\mathrm{PPV}_V^2}.
$$ {#eq-model-ppv-resultant}

The acceleration resultant is defined analogously:

$$
\mathrm{PPA}=
\sqrt{\mathrm{PPA}_L^2+\mathrm{PPA}_T^2+\mathrm{PPA}_V^2}.
$$ {#eq-model-ppa-resultant}

This convention uses the Euclidean norm of the peak amplitudes of the three components. Because those peaks do not necessarily occur at the same instant, the resultant does not represent the temporal maximum of the motion vector; it provides a common scalar measure for the dataset and the model.

Blasting conditions are represented by maximum instantaneous charge, source-to-receptor distance, and scaled distance. Let $\mathbf X\sim F_{\mathbf X}$ denote the random vector of covariates. For observation $j$, its realized values are $q_j$, $d_j$, $\mathrm{SD}_j=d_j/\sqrt{q_j}$, and $\mathbf x_j=\mathbf x(d_j,q_j)$. The same function constructs the covariates at each grid point $(d,q)$, with $\mathrm{SD}=d/\sqrt q$:

$$
\mathbf{x}(d,q)=
\left[
q,\ \ln q,\ q^{-1},\
d,\ \ln d,\ d^{-1},\
\mathrm{SD},\ \log_{10}\mathrm{SD}
\right]^{\mathsf T}.
$$ {#eq-model-features}

Charge $q$ is expressed in kg and distance $d$ in m, so $\mathrm{SD}$ has units of $\mathrm{m/kg^{1/2}}$. Scaled distance is included as the conventional reference for blast-amplitude relationships [@Langefors1963a]. The terms $\ln q$ and $\ln d$ are natural logarithms, whereas $\log_{10}\mathrm{SD}$ is decimal. The formulation also retains $d$, $q$, and their transformations so that the fit represents distance and charge effects separately instead of concentrating them in a single coordinate.

Let $h=1,\ldots,m$ index the response type or component and $j=1,\ldots,n_h$ index the observation. For the positive random variable $Y^{(h)}\sim F_{Y,h}$, the logarithmic transformation defines $Z^{(h)}=\log_{10}Y^{(h)}$. Prediction is formulated in terms of its conditional distribution:

$$
Z^{(h)}\mid\mathbf X=\mathbf x
\sim
F_{Z^{(h)}\mid\mathbf X}\!\left(\,\cdot\mid\mathbf x\right).
$$ {#eq-model-conditional-distribution}

Its observed realization is expressed as

$$
z_j^{(h)}=\log_{10}y_j^{(h)}.
$$ {#eq-model-log-response}

The fit produces a point estimator $\widehat z^{(h)}(\mathbf x)$ on the $\log_{10}$ scale. Predictive uncertainty is subsequently represented by the aggregate empirical distribution of the OOF residuals for each response, from which the $p50$, $p90$, and $p95$ levels are obtained.

The candidate base learners comprise linear regression, spline-based generalized additive models, multivariate adaptive regression splines [@friedman1991], gradient-boosted trees [@friedman2001], and random forests [@breiman2001]. For each learner, candidate configurations are compared using the root-mean-square error (RMSE) of out-of-fold (OOF) predictions obtained through five-fold cross-validation [@kohavi1995]. For each OOF prediction, the evaluated observation belongs to the fold excluded from the fit that predicts it; folds are assigned within each learner.

The configuration with the lowest RMSE is refitted using all observations available for the response. Its OOF predictions are retained to determine the predictive performance of the family, the ensemble weights, and the residual distribution used to characterize predictive error.

In probabilistic terms, performance refers to the generalization error of $\widehat z^{(h)}$. Over the population of application, its quadratic scale is $\mathrm{RMSE}_h=\{\operatorname E[(Z^{(h)}-\widehat z^{(h)}(\mathbf X))^2]\}^{1/2}$ and is estimated from the OOF pairs. In this study, RMSE retains the $\log_{10}$ unit of the modeled response and penalizes larger errors more strongly. The reported $R^2$ is the squared Pearson correlation between the observations and their OOF predictions: it quantifies their linear correspondence but does not by itself correct bias or miscalibration. RMSE and $R^2$ therefore describe complementary aspects of predictive performance.

OOF predictions provide the common evaluation basis because each observation is predicted by a fit that excluded it. This separation prevents the fitting residual for that same observation from serving as evidence of generalization and reduces the optimism that would favor families able to reproduce sample-specific variation. Configuration selection, ensemble weighting, selection of the multi-response iteration, and the residual distribution used for predictive levels are therefore based on predictions obtained outside the fit that produced each value.

The set $\mathcal K_h$ contains the learner families fitted for response $h$. The response-level ensemble assigns greater weight to families with lower OOF RMSE; the weights are estimated separately for each response:

$$
\widehat w_{hk}=
\frac{
\left(\widehat{\mathrm{RMSE}}_{hk}^{\mathrm{OOF}}\right)^{-1}
}{
\displaystyle\sum_{\ell\in\mathcal K_h}
\left(\widehat{\mathrm{RMSE}}_{h\ell}^{\mathrm{OOF}}\right)^{-1}
}.
$$ {#eq-model-ensemble-weights}

The ensemble prediction is

$$
\widehat z^{(h)}(\mathbf x)=
\sum_{k\in\mathcal K_h}
\widehat w_{hk}\,\widehat f_{hk}(\mathbf x).
$$ {#eq-model-ensemble}

Here, $\widehat f_{hk}$ is the prediction from learner family $k$ for response $h$ on the $\log_{10}$ scale. The weights sum to one. Out-of-fold evidence determines the weighting and subsequent error characterization; once the configuration of each family is fixed, the fit used to predict over the grid uses all observations available for that response.

Let $\mathbf Y=(Y^{(1)},\ldots,Y^{(m)})^{\mathsf T}\sim F_{\mathbf Y}$ denote the random vector of responses and $\mathbf Z=(Z^{(1)},\ldots,Z^{(m)})^{\mathsf T}\sim F_{\mathbf Z}$ its transformation to the fitting scale. Dependence among responses is represented through predictive covariates. For response $h$, iteration $t=0$ uses only $\mathbf x$; at each simultaneous Jacobi iteration $t=1,\ldots,T$, the $p50$ predictions of the remaining responses from the preceding iteration are incorporated [@spyromitros2016chains].

For the training observations, these covariates are the OOF predictions shifted by the median residual quantile, collected in $\widehat{\mathbf z}_{j,0.50,-h}^{\mathrm{OOF},(t-1)}$. At iterations $t>0$, each fitting row must have response $h$ and OOF predictions for all companion responses; the fitting sample is therefore the intersection defined by those availabilities. Over the grid, the predictions $\widehat{\mathbf z}_{0.50,-h}^{(t-1)}(\mathbf x)$ from the preceding iteration are used. The grid prediction is expressed as

$$
\widehat z^{(h,t)}(\mathbf x)=
\widehat f_h^{(t)}\!\left(
\mathbf x,
\widehat{\mathbf z}_{0.50,-h}^{(t-1)}(\mathbf x)
\right).
$$ {#eq-model-conditional}

The update is simultaneous: all responses at iteration $t$ use the state fixed at $t-1$. Let $\mathcal I_{h,t}$ be the set of observations with an OOF prediction and $n_{h,t}=|\mathcal I_{h,t}|$. The OOF RMSE is calculated as

$$
\widehat{\mathrm{RMSE}}_{h,t}^{\mathrm{OOF}}
=
\left\{
\frac{1}{n_{h,t}}
\sum_{j\in\mathcal I_{h,t}}
\left(
z_j^{(h)}-\widehat z_j^{\mathrm{OOF},(h,t)}
\right)^2
\right\}^{1/2}.
$$ {#eq-model-oof-rmse}

The OOF coefficient of determination is obtained from the correlation between observations and out-of-fold predictions:

$$
\widehat R_{h,t}^{2,\mathrm{OOF}}
=
\operatorname{Cor}^2\!\left(
\{z_j^{(h)}\}_{j\in\mathcal I_{h,t}},
\{\widehat z_j^{\mathrm{OOF},(h,t)}\}_{j\in\mathcal I_{h,t}}
\right).
$$ {#eq-model-oof-r2}

For each response, the retained iteration is

$$
t_h^*=
\operatorname*{arg\,max}_{t\in\{0,\ldots,T\}}
\widehat R_{h,t}^{2,\mathrm{OOF}}.
$$ {#eq-model-iteration-selection}

If $t_h^*=0$, the formulation uses only $\mathbf x$; if $t_h^*>0$, it incorporates the $p50$ predictions of the companion responses. Selection is performed separately for each response type; the OOF residuals and empirical predictive quantiles are obtained from the retained iteration.

For observation $j$, response $h$, and iteration $t$, the signed out-of-fold ensemble residual is

$$
r_j^{\mathrm{OOF},(h,t)}=
z_j^{(h)}-\widehat z_j^{\mathrm{OOF},(h,t)}.
$$ {#eq-model-oof-residual}

The empirical residual quantile at level $p$ is obtained as

$$
\widehat q_{h,p}^{(t)}=
\operatorname{Quantile}_p\!\left(
\left\{
r_j^{\mathrm{OOF},(h,t)}:
j\in\mathcal I_{h,t}
\right\}
\right).
$$ {#eq-model-residual-quantile}

The prediction in physical units for condition $(d,q)$ follows from the inverse transformation:

$$
\widehat y_p^{(h,t)}(d,q)=
10^{\,\widehat z^{(h,t)}(\mathbf x(d,q))+\widehat q_{h,p}^{(t)}},
\quad
p\in\{0.50,0.90,0.95\}.
$$ {#eq-model-quantiles}

Here, $t=0$ identifies the independent formulation and $t>0$ a conditional iteration. Level 0.50 incorporates the median OOF-residual correction, whereas levels 0.90 and 0.95 incorporate the corresponding upper empirical quantiles. The inverse transformation returns PPV in $\mathrm{mm/s}$ and PPA in $g$. These levels use the aggregate residual distribution of each response and do not establish a guarantee of conditional coverage for each combination $(d,q)$ or data source.

Predictions are reported by response type, combination $(d,q)$, and level $p$. Scenario generation uses the longitudinal, transverse, and vertical PPV predictions to scale the time histories from the instrumental L/T/V dataset. PPA contributes to the multi-response refinement but does not determine the scale factors.

The link to the risk analysis is established through the PPV targets used to scale the histories for each scenario $s=(D,Q,p)$, where $D$ and $Q$ represent source-to-receptor distance and maximum instantaneous charge (MIC), respectively. A lower OOF RMSE and a higher OOF $R^2$ represent a more precise point prediction only in the senses defined by those metrics; the uncertainty assigned to a scenario also depends on the upper quantiles of the residual distribution. When the separation between the upper residual quantiles and the median also decreases, the predictive amplitude levels incorporate a narrower upper band and scenario demand is defined with lower predictive dispersion. For a given target probability of failure, the methodology defines the admissibility boundary in the $(D,Q)$ plane. The admissibility of a larger MIC value $Q$ for a given distance $D$, or a smaller distance $D$ for a given MIC value $Q$, is determined by the dynamic responses and capacities represented by the risk model.

The applicability of the predictions is limited by the joint observed domain of the local and included external observations. The grid does not constitute additional evidence, and transfer from the supplementary source is a model assumption. Predictions and their quantiles describe relationships conditioned on this sample; the evaluated population, the retained iteration, and the corresponding OOF evidence define their interpretive context.
