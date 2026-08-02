```{r}
#| include: false
source(file.path(root, "scripts", "setup", "summary", "hazard_context.R"))
```

The probabilistic assessment quantifies seismic hazard through the annual rate at which each ground-motion level may be exceeded at the site. For a source $s$, the contribution is obtained by integrating the recurrence, the magnitude distribution, the rupture geometries, and the ground-motion distribution [@Cornell1968; @McGuire2004]:

$$
\lambda_I(i^*)^{(s)}=\nu_0^{(s)}\int_{M_{\min}}^{M_{\max}^{(s)}}\int_D P\!\left[I>i^*\mid m,\mathbf r\right]f_{M,s}(m)f_{\mathbf R\mid M,s}(\mathbf r\mid m)\,\mathrm d\mathbf r\,\mathrm dm.
$$

In this expression, $\lambda_I(i^*)^{(s)}$ is the annual exceedance rate contributed by the source, $\nu_0^{(s)}$ its activity rate above $M_{\min}$, $M_{\max}^{(s)}$ its maximum magnitude, $D$ the domain of admissible locations and geometries, $m$ the moment magnitude, $\mathbf r$ the vector of source-to-site distances, $I$ the intensity measure, $i^*$ the level evaluated, and $f_{M,s}$ and $f_{\mathbf R\mid M,s}$ the magnitude and distance densities. The total rate is the sum of the contributions of independent sources modeled as Poisson processes.

```{r}
#| echo: false
#| results: asis
BRANCH <- if (is.finite(Hazard.config$ssmBranches)) {
  sprintf(
    "%s %s",
    Hazard.config$ssmBranches,
    if (Hazard.config$ssmBranches == 1L) "source-model branch" else "source-model branches"
  )
} else {
  "the available branching structure"
}
if (!is.na(Hazard.config$ssmLabel) && nzchar(Hazard.config$ssmLabel)) {
  LEAD <- if (!is.na(Hazard.config$siteLabel)) {
    sprintf("For %s, the assessment", Hazard.config$siteLabel)
  } else {
    "The assessment"
  }
  cat(sprintf(
    paste0(
      "%s adopted the regional source model **%s**, with %s. ",
      "The calculation considers magnitudes from $M_w$ %s, ",
      "sources up to %s km, and residual truncation at $\\pm%s\\sigma$.\n"
    ),
    LEAD,
    Hazard.config$ssmLabel,
    BRANCH,
    .fmt(Hazard.config$minimumMagnitude, 1),
    .fmti(Hazard.config$maximumDistance),
    .fmt(Hazard.config$truncationLevel, 1)
  ))
  rm(LEAD)
}
rm(BRANCH)
```

The classical configuration of this assessment requests the mean curve at the reference rock condition, $V_{S30}=760$ m/s [@OpenQuakeEngine]. The fractiles available for $V_{S30}=800$ m/s correspond to that site condition and are not interpreted as fractiles of the rock hazard.

Under the Poisson assumption, the annual rate and the exact exceedance probabilities over one year and over $T$ years are related by

$$
P_{1\mathrm{yr}}[I>i^*]=1-e^{-\lambda_I(i^*)},\qquad P_T[I>i^*]=1-e^{-\lambda_I(i^*)T},\qquad T_R=\frac{1}{\lambda_I(i^*)}.
$$

The return period $T_R$ is the mean interval associated with the exceedance rate. The AEP curves present $\lambda_I$ in $1/\text{year}$; the PoE curves present the exact probability for the exposure interval of the calculation. Both are reported as total and by-source curves, together with PGA, spectral accelerations, the mean rock uniform hazard spectrum (UHS), and the site conditions evaluated.

Disaggregation recovers the combinations of magnitude, distance, and residual that contribute to the exceedance of each hazard level [@Bazzurro1999; @Kramer1997]. The reported disaggregation marginalizes over the residual and presents magnitude-distance matrices with magnitude bins of 0.1 $M_w$ and distance bins of 10 km for PGA, $S_a(0.10\,\mathrm{s})$, $S_a(0.20\,\mathrm{s})$, $S_a(0.50\,\mathrm{s})$, and $S_a(1.00\,\mathrm{s})$. The maximum of each matrix identifies the modal scenario for the corresponding return period and intensity measure.
