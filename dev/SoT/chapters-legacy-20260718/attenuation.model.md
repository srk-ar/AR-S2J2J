For a positive response $Y$, fitting is performed in the logarithmic domain,

$$
\log_{10} Y \mid \mathbf{x} = \eta_Y(\mathbf{x})+\varepsilon_Y,
$$ {#eq-amplitude-log-response}

where $\eta_Y(\mathbf{x})$ represents conditional mean log-amplitude. Linear regression, spline-based additive models, multivariate adaptive regression splines, gradient boosting, and random forest are fitted for each response. These model families can represent attenuation surfaces with different curvature without imposing a single functional law.

Hyperparameter selection and evaluation use five-fold cross-validation. Each observation receives a prediction from a fit that did not use that observation. The out-of-fold predictions define the RMSE of each family and the normalized ensemble weights:

$$
w_k =
\frac{\mathrm{RMSE}_k^{-1}}
     {\sum_{h=1}^{K}\mathrm{RMSE}_h^{-1}},
\qquad
\widehat{\eta}^{\mathrm{ens}}_Y(\mathbf{x})=
\sum_{k=1}^{K}w_k\widehat{\eta}^{(k)}_Y(\mathbf{x}).
$$ {#eq-amplitude-rmse-ensemble}

Weights, residuals, and metrics are estimated from out-of-fold evidence. Once model configurations are fixed, each model is refitted using all available observations to predict the grid. Final predictions therefore use the complete information set without contaminating the evidence used to compare models and characterize predictive error.

The independent model is extended through conditional multiple-response regression. To estimate $Y_j$, the predictor set is augmented with estimates of the other responses:

$$
\mathbf{x}^{(t)}_j =
\left[
\mathbf{x},\
\widehat{\mathbf{Y}}_{\setminus j}^{(t-1)}
\right],
\qquad
\widehat{Y}^{(t)}_j =
f_j\!\left(\mathbf{x}^{(t)}_j\right).
$$ {#eq-amplitude-conditional-response}

For observations, companion responses are represented by out-of-fold predictions; for the grid, they are the median predictions from the preceding iteration. Observed values of companion responses are never used as covariates. The adopted sweep is Jacobi: all eight responses are updated simultaneously from a frozen state of the previous iteration.

The initial iteration is the independent model. After refinement, each response retains the iteration—independent or conditional—that achieves the largest out-of-fold $R^2$. Predictions, residuals, metrics, and quantiles are assembled from that same iteration, avoiding combinations of statistical products from different model states.

Longitudinal, transverse, and vertical PPV predictions provide the target amplitudes for time-history scaling. PPA remains a reported blast-vibration response and participates in conditional estimation, but it does not determine scenario scale factors.
