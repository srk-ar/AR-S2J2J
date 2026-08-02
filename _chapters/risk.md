The proposed risk-analysis methodology relates blast-induced seismic demand to the capacity of the critical section of the tailings storage facility. Each scenario $s=(D,Q,p)$ comprises three-component realizations with amplitude targets defined by source-to-receptor distance $D$, the maximum instantaneous charge (MIC) $Q$, and predictive level $p$. Realizations within the same scenario share these targets and retain the variability in time-history shape and spectral content represented by the records. The longitudinal, transverse, and vertical PPV predictions establish the excitation scale; PPA remains a complementary response of the amplitude model. The distribution of responses from the dynamic model establishes the geotechnical performance conditioned on the scenario.

In this formulation, each time history $\mathbf a_{s,r}(t)$ is applied to the same plane-strain effective-stress dynamic model of the evaluated section. For realization $r$, the operation is represented as

$$
\mathbf R_{s,r}=\mathcal M\!\left[\mathbf a_{s,r}(t);\boldsymbol\theta\right],
$$ {#eq-risk-response}

where $\boldsymbol\theta$ comprises the geometry, initial state, boundary and drainage conditions, material assignments, and constitutive parameters, and $\mathbf R_{s,r}$ contains the calculated responses. The numerical configuration, constitutive laws, and parameters of each material are defined by the dynamic model of the section. The responses of interest include pore-water pressure, deformations, displacements, and the stability or serviceability quantities adopted for the section.

Each performance criterion $\ell$ defines a measure of geotechnical demand $\mathcal D_{\ell,s,r}=h_\ell(\mathbf R_{s,r})$ and an admissible capacity $\mathcal C_\ell$. The function $h_\ell$ establishes the physical variable, spatial and temporal domain, and response-aggregation rule, under the convention that greater demand represents a more adverse condition. The margin and binary failure indicator are expressed as

$$
g_{\ell,s,r}=\mathcal C_\ell-\mathcal D_{\ell,s,r},
\qquad
I_{\ell,s,r}=\mathbf 1\!\left(g_{\ell,s,r}\le 0\right).
$$ {#eq-risk-limit-state}

Thus, $I_{\ell,s,r}=1$ identifies exceedance of limit state $\ell$ for a specific realization. Each indicator is associated exclusively with its performance criterion. The criteria are evaluated separately; any joint classification is incorporated through a rule established by the geotechnical capacity model.

For criterion $\ell$, the scenario conditional probability of failure and its estimator over the $N_s$ analyzed realizations are

$$
p_{f,\ell}(s)
=P\!\left[\mathcal D_{\ell,s}\ge\mathcal C_\ell\mid s\right],
\qquad
\widehat p_{f,\ell}(s)
=\sum_{r=1}^{N_s}w_{s,r}I_{\ell,s,r},
\qquad
\sum_{r=1}^{N_s}w_{s,r}=1.
$$ {#eq-risk-pf}

The weights $w_{s,r}$ represent the population and the time-history selection design. For a representative and equiprobable population, $w_{s,r}=1/N_s$, and the estimator equals the fraction of failed realizations. When realizations are selected deterministically according to intensity, explicit weights are required to support a probabilistic interpretation of the resulting set.

The equivalent reliability index is defined from the probability of failure [@AngTang1984; @BenjaminCornell1970]:

$$
\beta_{\ell}(s)=-\Phi^{-1}\!\left[p_{f,\ell}(s)\right],
\qquad
p_{f,\ell}(s)\le p_{f,\ell}^{\mathrm{adm}}
\;\Longleftrightarrow\;
\beta_{\ell}(s)\ge
\beta_{\ell}^{\mathrm{adm}}
=-\Phi^{-1}\!\left(p_{f,\ell}^{\mathrm{adm}}\right),
$$ {#eq-risk-beta}

where $p_{f,\ell}^{\mathrm{adm}}$ is the admissible probability for the criterion. For the finite population represented by the realizations, the estimated index is obtained as $\widehat\beta_\ell(s)=-\Phi^{-1}[\widehat p_{f,\ell}(s)]$, and admissibility is evaluated equivalently through $\widehat p_{f,\ell}(s)\le p_{f,\ell}^{\mathrm{adm}}$ or $\widehat\beta_\ell(s)\ge\beta_\ell^{\mathrm{adm}}$. This formulation preserves the separation between demand and capacity within the reliability framework and adapts it to dynamic responses by realization. The admissible levels and joint classification of the criteria will be established by the geotechnical capacity model in future stages of the study.
