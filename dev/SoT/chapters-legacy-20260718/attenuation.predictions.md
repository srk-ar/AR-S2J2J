The empirical error distribution is estimated from out-of-fold ensemble residuals. For each grid point and level $p$, predictive amplitude is calculated as

$$
\widehat{Y}_p(D,Q)
= 10^{\,\widehat{Y}^{\log}(D,Q)+\widehat q_p(r)},
\qquad
r_i = \log_{10} Y_i - \log_{10}\widehat{Y}^{\mathrm{OOF}}_i .
$$ {#eq-amplitude-predictive-quantile}

Here $\widehat{Y}^{\log}(D,Q)$ is the ensemble prediction in log space and $\widehat q_p(r)$ is the empirical residual quantile. Levels $p=0.50$, $0.90$, and $0.95$ are predictive quantiles constructed from observed out-of-fold error; they are not parametric confidence intervals or symmetric bands.

The inverse transformation returns PPV and PPA to physical units and retains distance, MIC, predictive level, and associated metrics for each row. Scenario generation consumes only grid rows for longitudinal, transverse, and vertical PPV. The audit table preserves response-level detail and traces physical predictions to their fitted model and supporting out-of-fold evidence.
