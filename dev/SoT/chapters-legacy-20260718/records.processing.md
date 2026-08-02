Each history is represented on a uniform time axis. When the discretization must be changed, the signal is filtered before resampling to prevent aliasing, and its ends are tapered gradually to limit edge artifacts. Acceleration is obtained by frequency-domain differentiation, with a low-pass regularization that limits high-frequency amplification. Displacement is obtained by integration in the same domain and removal of the zero-frequency component. Acceleration, velocity, and displacement are therefore coherent representations of the same motion rather than independently processed series.

The current products apply ensemble empirical mode decomposition (EEMD) to each acceleration component. EEMD is used as an adaptive decomposition and reconstruction procedure for non-stationary signals, following the empirical mode decomposition framework and its noise-assisted ensemble extension [-@HuangEtAl1998EMD; -@WuHuang2009EEMD]. For a component decomposed into intrinsic mode functions $\mathrm{IMF}_{k,c}(t)$ and a residual term $r_c(t)$, the reconstruction can be written as

$$
a^{(r)}_c(t) =
\sum_{k \in \mathcal{K}_c} \mathrm{IMF}_{k,c}(t)
+ I_c\,r_c(t),
$$ {#eq-signal-eemd-reconstruction}

where $\mathcal{K}_c$ identifies the included modes and $I_c$ indicates whether the residual is retained. Existing products were generated with ten modes and removed the first and the final two modes before reconstructing acceleration, velocity, and displacement. The approved next export will not apply this selective removal; it must establish whether EEMD remains as a diagnostic with complete reconstruction or whether the canonical histories are used directly. Until that export is completed, the two conditions must not be presented as a single product.

Review of processed histories considers pulse shape, peak amplitude and timing, polarity, end behavior, velocity and displacement trends, frequency content, cumulative demand, and response spectra. These checks are necessary because resampling, edge treatment, differentiation, and integration can alter derived products even when the acceleration trace appears visually acceptable [-@BooreBommer2005].

Arias intensity and significant durations are calculated from the acceleration history. For a constant time step $\Delta t$ and acceleration expressed in consistent base units, discrete Arias intensity is

$$
\mathrm{AI}_c =
\frac{\pi}{2g}
\sum_{i=1}^{N} a_{c,i}^{2}\,\Delta t .
$$ {#eq-signal-arias-intensity}

The cumulative curve used for duration measures is proportional to the running sum of $a_{c,i}^2$. If $t_{\alpha}$ denotes the time at which this curve reaches fraction $\alpha$ of its final value, the retained durations include

$$
D_{5-95}=t_{0.95}-t_{0.05},\qquad
D_{5-75}=t_{0.75}-t_{0.05},\qquad
D_{20-80}=t_{0.80}-t_{0.20}.
$$ {#eq-signal-significant-duration}

Cumulative absolute velocity is calculated as

$$
\mathrm{CAV}_c = \sum_{i=1}^{N} |a_{c,i}|\,\Delta t .
$$ {#eq-signal-cav}

CAV5 applies the same summation only to ordinates whose absolute acceleration reaches the $0.05g$ threshold. Peak measures describe the largest instantaneous amplitude; AI and CAV describe cumulative demand; and duration measures characterize the time window over which cycles act. They are descriptors of imposed motion, whereas TSF acceptance depends on the response calculated by the geotechnical model.

Elastic response spectra are calculated from the canonical histories using a linear single-degree-of-freedom oscillator. For natural period $T_n$ and damping ratio $\xi$,

$$
\omega_n = \frac{2\pi}{T_n},\qquad
C = 2\xi\omega_n,\qquad
K = \omega_n^2 .
$$ {#eq-signal-sdof-parameters}

The oscillator state $\mathbf{y}(t)$ is evaluated from

$$
\dot{\mathbf{y}} =
\mathbf{A}\mathbf{y}+\mathbf{B}u(t),\qquad
\mathbf{A} =
\begin{bmatrix}
0 & 1\\
-K & -C
\end{bmatrix},\qquad
\mathbf{B} =
\begin{bmatrix}
0\\
1
\end{bmatrix}.
$$ {#eq-signal-sdof-state}

Once the response has been evaluated, spectral displacement and the pseudo-spectral ordinates are

$$
\mathrm{SD}(T_n)=\max_t |y_1(t)|,\qquad
\mathrm{PSV}(T_n)=\omega_n\,\mathrm{SD}(T_n),\qquad
\mathrm{PSA}(T_n)=\omega_n^2\,\mathrm{SD}(T_n).
$$ {#eq-signal-response-spectra}

The product preserves its link to the source history: PSA is obtained from acceleration, PSV from velocity, and SD from displacement. H1, H2, and UP spectra are reported for scenario histories. When D50 or D100 is requested, GMSP rotates the horizontal pair over an angular grid and summarizes the oscillator ordinates at each period; these statistics are spectral products rather than additional time histories.
