The primary objectives of this study are as follows:

* **Seismic Hazard:** Quantify annual exceedance probabilities for ground-motion intensity measures at the site using probabilistic seismic hazard analysis. Compute site-specific hazard curves and uniform hazard spectra at reference-rock conditions. Perform hazard disaggregation to identify controlling magnitude, distance, and residual scenarios at each governing hazard level. Summarize hazard results as mean and fractile annual exceedance probability curves for defined site conditions.

* **Site Response:** Compute site-specific peak ground acceleration and spectral ordinates through two ergodic branches: the direct evaluation of the ground-motion model tree, with each model's own empirical site terms, at each project site condition, and the transformation of the reference-rock motion through the Stewart and Hashash (2020) NGA-East ergodic amplification model. Present hazard and site response results as tables and figures summarizing peak ground acceleration values and uniform hazard spectra for all site classes and quantile levels.

* **Slope Design:** Quantify permanent slope displacements and derive performance-based horizontal seismic coefficients ($k_{\max}$, $k_h$) for slope stability design. Displacements are estimated using a weighted ensemble of rigid- and flexible-block Newmark models across geometry classes, material scenarios, return periods, and allowable displacement thresholds. Seismic coefficients are determined by inversion of the displacement framework for each prescribed performance objective. Summarize $k_{\max}$ and $k_h$ design values for all geometry–material–AEP combinations.

* **Design Criteria:** Establish seismic design criteria for tailing storage facilities based on international standards and consequence classification. Assign design ground motions and performance objectives for all project lifecycle phases, including operation, closure, and post-closure, as required by GISTM, CDA, and ANCOLD. Determine Maximum Credible Earthquake (MCE) scenarios in accordance with regulatory requirements. Define probabilistic design spectra and associated ground motions for each operational stage and consequence rating. Establish, for conventional structures, the risk-targeted Maximum Considered Earthquake (MCER) spectra of the ASCE/SEI 7-22 site-specific procedure (IBC 2021) and derive from them the elastic design spectra, defined as two-thirds of the MCER ordinates, with their $S_{DS}$ and $S_{D1}$ parameters.

```{r}
#| echo: false
#| results: asis
if (isTRUE(get0("_INCLUDE_RECORD_SELECTION", ifnotfound = FALSE))) {
  cat(sprintf(
    "\n* **Seismic Record Selection:** %s\n",
    get0("_TEXT_RECORD_SELECTION", ifnotfound = "")
  ))
}
```

* **Uncertainty Modeling:** Propagate epistemic uncertainty through logic-tree branching and aleatory variability through probabilistic integration across all analysis components. Propagate hazard-based and model-based uncertainties in site response through Monte Carlo sampling to generate fractile site response spectra. Aggregate uncertainties in ground-motion intensity measures, site response, and displacement models to generate robust confidence intervals for Newmark displacements and performance-based seismic coefficients.
