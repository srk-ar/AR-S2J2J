The response of the dynamic geotechnical model is obtained from the complete excitation history. Duration, cycle sequence, and frequency content act together with peak amplitude; accordingly, the instrumental database must preserve the measured time-history shape and separate that shape from the amplitude associated with each distance-and-charge condition.

The instrumental database comprises particle-velocity time histories measured during site blasting. Each record retains a unique identity and the longitudinal, transverse, and vertical components—$L$, $T$, and $V$. The source-to-receptor distance $d_r$ and maximum instantaneous charge (MIC) $q_r$ form part of the metadata for record $r$ when the contractor reported both values; this subset characterizes the observed coverage of monitoring conditions, whereas the complete instrumental population supplies the time-history shapes. Velocity is the primary measured quantity; acceleration and displacement time histories are derived from that signal under a common time and unit convention.

Amplitudes use a common length basis of millimeters, so acceleration, velocity, and displacement are expressed in $\mathrm{mm/s^2}$, $\mathrm{mm/s}$, and $\mathrm{mm}$, respectively. The time coordinate of each record is referenced to the start of the processed history and increases at a constant step $\Delta t$. This representation allows the same operations and descriptors to be applied throughout the instrumental population.

The estimation of peak particle acceleration (PPA) and peak particle velocity (PPV) combines local IMPALA observations with the supplementary S11D source, a database of peak amplitudes measured in different projects worldwide, compiled by the author. Evidence from the site is used within the rectangular distance-and-charge envelope covered by local monitoring; beyond either interval, S11D extends the observed distance--charge domain. Each observation retains its provenance and the responses available by component.

The samples are ordered in time and mapped onto a uniform grid. When the original time step is nonuniform, the signal is mapped by monotone cubic interpolation onto a grid with the smallest time increment compatible with the history. When the sampling frequency must be reduced, a low-pass antialiasing filter is applied first; its passband contains the frequency range of interest, and its stopband lies below the new Nyquist frequency. The transformation is evaluated in overlapping windows, and the ends of the signal are gradually tapered to limit edge discontinuities.

Let $V_c(\omega)$ be the Fourier transform of the velocity of component $c$, and let $W_{\mathrm{LP}}(\omega)$ be the low-pass regularization associated with the maximum processing frequency. Differentiation is represented by the operator

$$
H_{\mathrm{d}}(\omega)=
\begin{cases}
0, & \omega=0,\\
\mathrm{i}\omega\,W_{\mathrm{LP}}(\omega), & \omega\ne0,
\end{cases}
$$ {#eq-records-differentiation-operator}

Integration is represented by

$$
H_{\mathrm{i}}(\omega)=
\begin{cases}
0, & \omega=0,\\
(\mathrm{i}\omega)^{-1}, & \omega\ne0.
\end{cases}
$$ {#eq-records-integration-operator}

Acceleration and displacement are obtained as $a_c(t)=\mathcal{F}^{-1}\{H_{\mathrm{d}}V_c\}$ and $u_c(t)=\mathcal{F}^{-1}\{H_{\mathrm{i}}V_c\}$. Setting the zero-frequency term to zero controls the zero-frequency component of the integration, whereas $W_{\mathrm{LP}}(\omega)$ limits amplification of high frequencies during differentiation. A final window, defined from the processed acceleration, is applied jointly to acceleration, velocity, and displacement. The result is a time-aligned set $\{a_c(t),v_c(t),u_c(t)\}$ generated through a joint transformation of the same motion [@BooreBommer2005].

The instrumental processing criteria are the temporal alignment of the three quantities, consistent units, and the absence of terminal trends that alter the shape of the source pulse. These properties govern the subsequent use of the same acceleration, velocity, and displacement history under a common amplitude factor.

Let $a^{(0)}_{r,c}(t)$ be the acceleration of record $r$ and component $c$ obtained in the preceding stage. Each history is decomposed by variational mode decomposition (VMD) into $K=10$ modes $\phi_{r,c,k}(t)$, with center frequencies $\omega_{r,c,k}$ estimated simultaneously [@DragomiretskiyZosso2014]. Omitting the subscripts $r,c$, the reference formulation minimizes the combined bandwidth of the demodulated analytic signals:

$$
\begin{aligned}
\min_{\{\phi_k\},\,\{\omega_k\}}\quad&
\sum_{k=1}^{K}
\left\|
\partial_t
\left[
\left(\delta(t)+\frac{\mathrm{i}}{\pi t}\right)*\phi_k(t)
\right]
e^{-\mathrm{i}\omega_k t}
\right\|_2^2,\\
\text{subject to}\quad&
\sum_{k=1}^{K}\phi_k(t)=a^{(0)}(t).
\end{aligned}
$$ {#eq-records-vmd}

The numerical procedure adopts $\alpha=2000$, dual-ascent step $\tau=0$, the first mode constrained to $\omega_1=0$, center frequencies initialized at zero, and a convergence tolerance of $10^{-7}$. The closure residual is defined as

$$
\rho^{\mathrm{VMD}}_{r,c}(t)
=
a^{(0)}_{r,c}(t)
-\sum_{k=1}^{10}\phi_{r,c,k}(t).
$$ {#eq-records-vmd-closure}

The processed history incorporates this residual as

$$
\begin{aligned}
a^{\mathrm{VMD}}_{r,c}(t)
&=
a^{(0)}_{r,c}(t)-\phi_{r,c,1}(t)\\
&=
\sum_{k=2}^{10}\phi_{r,c,k}(t)+\rho^{\mathrm{VMD}}_{r,c}(t).
\end{aligned}
$$ {#eq-records-vmd-reconstruction}

The reconstruction retains modes IMF2–IMF10 and the closure residual and separates $\phi_{r,c,1}$—identified as IMF1—whose center frequency is constrained to zero. The position of the mode in the decomposition identifies the component separated from the reconstruction without assigning it a specific physical origin. The acceleration $a^{\mathrm{VMD}}_{r,c}(t)$ is used to reconstruct the kinematic set of acceleration, velocity, and displacement histories and calculate the subsequent intensity measures and spectra.

Each measured record combines a time-history shape with the amplitude specific to the charge and distance of that blast. To separate these contributions, the following quantity is defined for record $r$ and component $c$:

$$
\mathrm{PGV}_{r,c}=\max_t|v_{r,c}(t)|.
$$ {#eq-records-pgv}

In this report, $\mathrm{PGV}_{r,c}$ and $\mathrm{PPV}_{r,c}$ represent the same physical quantity: the maximum absolute particle velocity. PGV identifies the descriptor calculated from a time history, whereas PPV identifies the response variable of the predictive component. This convention distinguishes the two calculation contexts without changing the quantity or its units; the same convention applies to PGA and PPA for acceleration.

The separation of shape and amplitude is expressed algebraically as $\widetilde a_{r,c}=a_{r,c}/\mathrm{PGV}_{r,c}$, $\widetilde v_{r,c}=v_{r,c}/\mathrm{PGV}_{r,c}$, and $\widetilde u_{r,c}=u_{r,c}/\mathrm{PGV}_{r,c}$. This representation sets the peak particle velocity to unity; $\widetilde a_{r,c}$, $\widetilde v_{r,c}$, and $\widetilde u_{r,c}$ have units of $\mathrm{s}^{-1}$, $1$, and $\mathrm{s}$, respectively. The processed library retains the physical amplitudes of the source histories.

This algebraic separation allows the amplitude of the acceleration–velocity–displacement set to be modified through a single common factor, so its kinematic relationships remain invariant. The scenarios chapter defines the factor that assigns the predicted PPV to each component.

Transfer of waveform shapes is an explicit project assumption: within the distance-and-charge domain represented by the monitoring and the scenarios, the relative time-history shape and its frequency content are transferable among conditions $(d,q)$. Amplitude is obtained from the predictive component and assigned during scenario construction, whereas variability in duration, cycle sequence, and spectral shape comes from the population of processed records. The resulting histories retain the identity and time-history shape of the instrumental record from which they are derived.

The diversity of the processed histories is first described by their maximum absolute values. For each record $r$ and component $c$,

$$
\mathrm{PGA}_{r,c} = \max_t |a_{r,c}(t)|.
$$ {#eq-records-pga}

PGV is defined in @eq-records-pgv. Peak displacement is obtained as

$$
\mathrm{PGD}_{r,c} = \max_t |u_{r,c}(t)|,
$$ {#eq-records-pgd}

where PGA, PGV, and PGD are the peak acceleration, velocity, and displacement amplitudes. These measures characterize the instantaneous maximum and are supplemented by indicators that accumulate the action of successive cycles.

For the $n_r$ samples of record $r$, with constant time step $\Delta t$, Arias intensity [@Arias1970], cumulative absolute velocity, and its thresholded variant are calculated as

$$
\mathrm{AI}_{r,c} = \frac{\pi}{2g}\sum_{\ell=1}^{n_r} a_{r,c,\ell}^{2}\,\Delta t.
$$ {#eq-records-ai}

$$
\mathrm{CAV}_{r,c} = \sum_{\ell=1}^{n_r} |a_{r,c,\ell}|\,\Delta t.
$$ {#eq-records-cav}

$$
\mathrm{CAV5}_{r,c} = \sum_{\ell=1}^{n_r}|a_{r,c,\ell}|\,\mathbf{1}\!\left(|a_{r,c,\ell}|\ge0.05g\right)\Delta t,
$$ {#eq-records-cav5}

where $g$ is gravitational acceleration and $\mathbf{1}(\cdot)$ is the indicator function. AI gives greater weight to high-acceleration ordinates; CAV accumulates the absolute value of the complete history; and CAV5 retains the ordinates that reach the $0.05g$ threshold.

Significant durations are obtained from the cumulative curve of $a_{r,c,\ell}^{2}$. If $t_{r,c,\gamma}$ is the time at which that curve reaches the fraction $\gamma$ of its final value, the duration between fractions $\gamma_1$ and $\gamma_2$ is

$$
D^{(r,c)}_{[\gamma_1,\gamma_2]}=t_{r,c,\gamma_2}-t_{r,c,\gamma_1}.
$$ {#eq-records-duration}

The report presents the 5–95%, 5–75%, and 20–80% significant durations, corresponding respectively to the intervals $[0.05,0.95]$, $[0.05,0.75]$, and $[0.20,0.80]$ of cumulative action.

Peak amplitudes describe the instantaneous maxima; AI, CAV, and CAV5 represent cumulative measures of acceleration; and the durations express the temporal distribution of that action. Together, they distinguish histories with similar peak amplitudes but different numbers, sequences, and temporal concentrations of cycles.

The frequency content of each record $r$ and component $c$ is characterized by the elastic pseudoacceleration response spectrum for a damping ratio $\xi=0.05$. For a natural period $T_n$, with $\omega_n=2\pi/T_n$, the relative coordinate $w_{r,c}(t;T_n)$ of the linear oscillator satisfies

$$
\ddot{w}_{r,c}(t;T_n)+2\xi\omega_n\dot{w}_{r,c}(t;T_n)+\omega_n^2w_{r,c}(t;T_n)=-a_{r,c}(t).
$$ {#eq-records-psa-oscillator}

The response is evaluated using the exact state-transition matrix of the system for each interval $\Delta t$. The spectral ordinate is

$$
\mathrm{PSA}_{r,c}(T_n)=\omega_n^2\max_t|w_{r,c}(t;T_n)|.
$$ {#eq-records-psa}

The periods are logarithmically spaced from the reciprocal of the maximum processing frequency to $1\,\mathrm{s}$. The spectra by record and component allow the distribution of demand in the period domain to be compared among histories with similar peak amplitudes.
