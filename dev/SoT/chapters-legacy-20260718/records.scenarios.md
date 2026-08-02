Scenario generation combines component PPV predictions with processed particle-velocity histories. Longitudinal, transverse, and vertical PPV values are interpolated for each configured distance $D$, MIC $Q$, and predictive level $p$. Each scenario retains one realization per source record, so amplitude is determined by the predictive model while time-domain shape and frequency content come from measured motions.

For record $j$ and original component $c\in\{L,T,V\}$, the scale factor is defined relative to the peak velocity of the processed history:

$$
a'_{j,c}(t;D,Q,p)
= a_{j,c}(t)
  \frac{G\,\widehat{\mathrm{PPV}}_c(D,Q,p)}
       {\max_t |v_{j,c}(t)|} .
$$ {#eq-scenario-component-scaling}

The same factor multiplies the complete acceleration, velocity, and displacement histories of the component. This operation fixes peak velocity at the predicted target, preserves the time axis and normalized waveform, and maintains kinematic consistency across the three quantities. Because L, T, and V receive different factors, component amplitude ratios may differ from those of the original record.

After scaling, the covariance matrix of horizontal L and T acceleration is calculated. Its dominant eigenvector defines H1, the direction of maximum acceleration variance, and the orthogonal direction defines H2:

$$
H1_j(t)=L'_j(t)\cos\theta_j+T'_j(t)\sin\theta_j,
\qquad
H2_j(t)=-L'_j(t)\sin\theta_j+T'_j(t)\cos\theta_j .
$$ {#eq-scenario-principal-rotation}

The same orthogonal transformation is applied to acceleration, velocity, and displacement, while V is retained as UP. H1, H2, and UP are time histories. When requested, D50 and D100 summarize SDOF spectra obtained from additional angular rotations and do not constitute new histories.

The resulting scenarios are demand histories for dynamic analysis. Pore pressure, cyclic mobility, deformation, and stability response are outputs of the geotechnical model and also depend on initial state, constitutive model, drainage assumptions, and boundary conditions [-@LucoBazzurro2007; -@WhittakerEtAl2011NISTGCRScaling].

Consistency checks verify properties that must hold by construction after scaling and rotation. For each record, UP peak velocity must reproduce the target vertical PPV within the adopted tolerance. The quadratic sum of horizontal accelerations must be preserved when L/T is transformed to H1/H2 because the transformation is orthogonal. H1, H2, and UP peak accelerations must be greater than zero.

Results are recorded by realization and summarized by scenario, allowing an isolated failure to be distinguished from a problem affecting an entire distance–MIC condition. These tests verify the vertical-scaling contract, consistency of horizontal rotation, and the presence of positive acceleration amplitude. They do not test spectral compatibility, pore pressure, deformation, representativeness of the set, or geotechnical response.

The audit and selection pipelines consume the same histories but run independently. Audit results do not currently act as an automatic gate within selection; they provide evidence that must be reviewed before scenarios are accepted for subsequent analysis.
