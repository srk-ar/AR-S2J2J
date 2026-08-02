The dynamic analysis of the section uses three-component acceleration, velocity, and displacement time histories. This chapter constructs these excitations by combining the PPV amplitudes estimated for each blasting condition with the waveforms represented in the instrumental population. The resulting family of seismic-demand scenarios represents the measured temporal variability and the amplitudes conditioned on distance, charge, and predictive level.

A scenario condition $s$ is defined by the source-to-receptor distance $d_s$, maximum instantaneous charge (MIC) $q_s$, and predictive level $p_s$. A source history comprises a processed instrumental set in L/T/V, with kinematically consistent acceleration, velocity, and displacement time histories. Transforming source history $r$ for condition $s$ produces a realization in H1/H2/UP. The scenario comprises all realizations that share that condition and the same PPV targets; the scenario family comprises the set of evaluated conditions.

For each instrumental component $c\in\{L,T,V\}$, the target $\mathrm{PPV}^{\mathrm{tar}}_{s,c}$ is obtained from the physical prediction defined by @eq-model-quantiles at $(d_s,q_s,p_s)$. The level $p_s$ identifies the empirical quantile of the residual distribution used to establish the amplitude. Evaluation over the prediction grid uses successive linear interpolations in distance and charge and is confined to its envelope. Both the PPV targets and the particle velocities of the source time histories are expressed in $\mathrm{mm/s}$.

For scenario $s$, source history $r$, and component $c$, the scale factor is defined from the peak particle velocity $\mathrm{PGV}_{r,c}$ in @eq-records-pgv:

$$
\lambda_{s,r,c}
=
\frac{\mathrm{PPV}^{\mathrm{tar}}_{s,c}}
{\mathrm{PGV}_{r,c}}.
$$ {#eq-scenarios-scale-factor}

The factor is applied to all three motion quantities of the component:

$$
\begin{bmatrix}
a^{\mathrm{sc}}_{s,r,c}(t)\\[2pt]
v^{\mathrm{sc}}_{s,r,c}(t)\\[2pt]
u^{\mathrm{sc}}_{s,r,c}(t)
\end{bmatrix}
=
\lambda_{s,r,c}
\begin{bmatrix}
a_{r,c}(t)\\[2pt]
v_{r,c}(t)\\[2pt]
u_{r,c}(t)
\end{bmatrix}.
$$ {#eq-scenarios-component-scaling}

Applying a common factor to the acceleration, velocity, and displacement of a component preserves their kinematic consistency and establishes $\max_t|v^{\mathrm{sc}}_{s,r,c}(t)|=\mathrm{PPV}^{\mathrm{tar}}_{s,c}$. The factors are calculated independently for L, T, and V; consequently, the amplitude ratios among components may differ from those observed in the source history.

Transformation to the analysis directions follows scaling. For each realization, the dominant eigenvector of the covariance matrix of the scaled horizontal accelerations defines the angle $\theta_{s,r}$. For $\psi\in\{a,v,u\}$, the same orthogonal rotation is applied to all three quantities:

$$
\begin{bmatrix}
\psi_{s,r,H1}(t)\\
\psi_{s,r,H2}(t)
\end{bmatrix}
=
\begin{bmatrix}
\cos\theta_{s,r} & \sin\theta_{s,r}\\
-\sin\theta_{s,r} & \cos\theta_{s,r}
\end{bmatrix}
\begin{bmatrix}
\psi^{\mathrm{sc}}_{s,r,L}(t)\\
\psi^{\mathrm{sc}}_{s,r,T}(t)
\end{bmatrix}.
$$ {#eq-scenarios-principal-rotation}

H1 corresponds to the direction of greatest horizontal acceleration variance, and H2 to its orthogonal direction. The scaled vertical component retains its orientation and is identified as UP. Because the L and T factors depend on the scenario, $\theta_{s,r}$ may also vary among conditions. The resulting H1/H2/UP time histories are used to recalculate the intensity measures and 5%-damped pseudoacceleration response spectra.

The construction is required to reproduce the vertical amplitude target and preserve the quadratic norm of the horizontal accelerations during rotation. The relative vertical-amplitude error

$$
e^{\mathrm{PPV}}_{s,r}
=
\left|
\frac{\mathrm{PGV}_{s,r,UP}}
{\mathrm{PPV}^{\mathrm{tar}}_{s,V}}
-1
\right|
$$ {#eq-scenarios-vertical-amplitude-error}

and the relative error associated with the horizontal transformation are evaluated separately for each realization:

$$
e^{\mathrm{rot}}_{s,r}
=
\left|
\frac{
\sum_t\!\left[a_{s,r,H1}(t)^2+a_{s,r,H2}(t)^2\right]
}{
\sum_t\!\left[a^{\mathrm{sc}}_{s,r,L}(t)^2+a^{\mathrm{sc}}_{s,r,T}(t)^2\right]
}
-1
\right|.
$$ {#eq-scenarios-horizontal-rotation-error}

A relative tolerance of $10^{-3}$ is adopted for both properties. The acceleration time histories in H1, H2, and UP must also be nondegenerate, with positive PGA. A scenario satisfies these criteria when all its realizations meet both tolerances and this condition.

Each realization retains the identity of the source history, the condition $(d_s,q_s,p_s)$, and the prescribed PPV amplitudes. The set provided to the dynamic analysis comprises acceleration, velocity, and displacement time histories in H1/H2/UP, their intensity measures, and their spectra. This identification allows the subsequent geotechnical response to be interpreted with respect to the applied excitation and the blasting condition that established its amplitude. The complete family precedes any selection of realizations and evaluation of the geotechnical response.
