# Blast-Induced Dynamic Demand for TSF Dynamic Response Assessment

## 1. Introduction, Motivation, and Dynamic-Analysis Program

The study develops blast-induced dynamic demand histories for the BRPM tailings storage facility (TSF), one of the Northern Concentrator facilities of the Impala mining operation, where production blasting at adjacent mining operations imposes short-duration transient vibration on saturated fine tailings. Vibration monitoring implemented at the site provides the measured records used throughout this work. The engineering concern is the response of the TSF materials and geometry to those transient loads, including excess pore-pressure generation, reduction of effective stress, cyclic mobility, deformation, and liquefaction-type behaviour. The vibration records define the imposed dynamic demand; pore pressure, deformation, and performance measures are calculated in the subsequent geotechnical response model. This work is the demand-development stage of a broader assessment whose objective is to propose practical limits for blasting distance and maximum instantaneous charge combinations that keep the TSF performance uncompromised; the generated demand histories feed a preliminary dynamic deformation assessment of the critical TSF section.

The planned dynamic analysis is scenario based. Each blast-loading scenario is indexed by source-to-receiver distance $D$ and maximum instantaneous charge $Q$, and each scenario retains multiple time-history realizations. This structure reflects the central uncertainty in the demand problem: two scenarios with similar peak amplitudes can differ in duration, pulse sequence, frequency content, cumulative energy, and horizontal directionality, and those differences can change the pore-pressure and deformation response of saturated fine tailings.

The later effective-stress plane-strain dynamic deformation analysis of the critical TSF section is the receiving model for the generated demand histories. Its response quantities include the excess pore-pressure ratio $r_u$, deformation measures, and any project-defined stability or serviceability indicators. The present methodology prepares the vibration demand histories used by that model; liquefaction interpretation remains a geotechnical response calculation.

The demand-development sequence has four linked stages. Measured blast vibration records are first converted into consistent acceleration, velocity, and displacement histories. Peak vibration amplitudes are then modelled over the $D$-$Q$ domain. Component PPA predictions define target acceleration levels for scenario histories. Finally, scenario histories are generated, audited, and selected for the dynamic response analyses.

The methodology is organized to preserve traceability from measured records to selected scenario histories. The source record identity, component convention, units, filtering state, target scenario, and selected demand descriptors remain attached to each generated history, so later geotechnical results can be interpreted against the demand realization that produced them.

## 2. Signal Processing and Demand-History Products

The source data are measured blast vibration histories with associated event, distance, charge, component, sampling, and unit metadata. The processing stage brings those records to a common time-history convention before any amplitude modelling or scenario generation is performed. The retained representation contains acceleration $a(t)$, velocity $v(t)$, and displacement $d(t)$ for each component, with a common time axis and consistent base units.

The measured records enter the processing sequence as velocity histories. For each component, the canonical output contains the measured velocity history and the acceleration and displacement histories derived from it. This convention allows the same source record to support peak velocity measures, acceleration-based scaling, displacement checks, cumulative acceleration measures, and elastic response spectra while keeping component and unit definitions stable between stages.

Peak measures are computed directly from the canonical histories:

$$
\mathrm{PGA}_c = \max_t |a_c(t)|,\qquad
\mathrm{PGV}_c = \max_t |v_c(t)|,\qquad
\mathrm{PGD}_c = \max_t |d_c(t)| .
$$

Here $c$ denotes the retained component. These peak quantities are demand descriptors. They identify amplitude levels in the processed histories and support model fitting, scenario checks, and record ranking.

The acceleration histories are filtered through ensemble empirical mode decomposition (EEMD). EEMD is used as an adaptive decomposition and reconstruction procedure for non-stationary signals, following the empirical mode decomposition framework and its noise-assisted ensemble extension [-@HuangEtAl1998EMD; -@WuHuang2009EEMD]. In this study, the retained reconstruction is interpreted as a processed scale-band representation of the measured vibration history; source mechanism, propagation medium, and material-response interpretations are evaluated from independent evidence.

For an acceleration component decomposed into intrinsic mode functions $\mathrm{IMF}_{k,c}(t)$ and a residual term $r_c(t)$, the filtered reconstruction can be written compactly as

$$
a^{(f)}_c(t) =
\sum_{k \in \mathcal{K}_c} \mathrm{IMF}_{k,c}(t)
+ I_c\,r_c(t),
$$

where $\mathcal{K}_c$ is the retained set of scale bands for component $c$, and $I_c$ indicates whether the residual trend term is retained. This expression states the reconstruction used by the signal-processing stage, while physical interpretation remains tied to independent modelling, instrumentation, or site evidence. In this study, each acceleration component was decomposed into ten intrinsic mode functions; the highest-frequency mode and the two slowest modes were removed, and the remaining modes together with the residual term form the retained reconstruction. After filtering, the velocity and displacement histories are re-derived from the filtered acceleration, so the three canonical histories remain mutually consistent.

The filtered histories are checked in the domains that control later engineering use. Time-domain checks compare pulse shape, peak amplitude, peak timing, polarity, endpoint behaviour, and integrated velocity and displacement trends. Frequency-domain checks compare the retained and removed scale content. Cumulative and spectral checks compare Arias intensity, CAV, duration measures, and response spectra. These checks are necessary because filtering, baseline choices, and integration can change derived velocity, displacement, and spectral products even when the acceleration trace appears visually acceptable [-@BooreBommer2005].

Arias intensity and significant duration are computed from the acceleration history. With constant time step $\Delta t$ and acceleration expressed in a consistent base unit, the discrete Arias intensity is

$$
\mathrm{AI}_c =
\frac{\pi}{2g}
\sum_{i=1}^{N} a_{c,i}^{2}\,\Delta t .
$$

The cumulative energy curve used for duration measures is proportional to the running sum of $a_{c,i}^2$. If $t_{\alpha}$ denotes the time at which the cumulative curve reaches fraction $\alpha$ of its final value, the significant durations used in the processed products include

$$
D_{5-95}=t_{0.95}-t_{0.05},\qquad
D_{5-75}=t_{0.75}-t_{0.05},\qquad
D_{20-80}=t_{0.80}-t_{0.20}.
$$

Cumulative absolute velocity is computed from the absolute acceleration history:

$$
\mathrm{CAV}_c = \sum_{i=1}^{N} |a_{c,i}|\,\Delta t .
$$

The accompanying $\mathrm{CAV5}$ measure applies the same summation to ordinates whose absolute acceleration reaches the adopted $0.05g$ threshold. In this report, CAV and CAV5 are demand descriptors used to compare records and generated scenarios, while TSF acceptance is evaluated through the geotechnical response model.

Elastic response spectra are computed from the canonical acceleration, velocity, and displacement histories through a linear single-degree-of-freedom oscillator. For oscillator period $T_n$ and damping ratio $\xi$,

$$
\omega_n = \frac{2\pi}{T_n},\qquad
C = 2\xi\omega_n,\qquad
K = \omega_n^2 .
$$

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
$$

After the oscillator response is evaluated, the spectral displacement and pseudo-spectral ordinates are

$$
\mathrm{SD}(T_n)=\max_t |y_1(t)|,\qquad
\mathrm{PSV}(T_n)=\omega_n\,\mathrm{SD}(T_n),\qquad
\mathrm{PSA}(T_n)=\omega_n^2\,\mathrm{SD}(T_n).
$$

The spectral product preserves the source-history mapping: PSA is computed from the acceleration history, PSV from the velocity history, and SD from the displacement history. For generated scenario histories, the component spectra are reported for the retained horizontal and vertical directions, and the median rotated horizontal spectrum is included for the horizontal spectral review used in the study.

## 3. Signal-Amplitude Modelling

The signal-amplitude model estimates peak blast vibration amplitudes over the distance-charge domain. The retained responses are PPV and PPA as scalar resultant amplitudes and as longitudinal, transverse, and vertical component amplitudes. For measured component values $\mathrm{PPV}_L$, $\mathrm{PPV}_T$, $\mathrm{PPV}_V$, $\mathrm{PPA}_L$, $\mathrm{PPA}_T$, and $\mathrm{PPA}_V$, the scalar amplitudes are

$$
\mathrm{PPV} =
\sqrt{\mathrm{PPV}_L^2+\mathrm{PPV}_T^2+\mathrm{PPV}_V^2},\qquad
\mathrm{PPA} =
\sqrt{\mathrm{PPA}_L^2+\mathrm{PPA}_T^2+\mathrm{PPA}_V^2}.
$$

Only records with complete component PPV and PPA values enter the amplitude training set. Unit declarations for PPV and PPA are checked for homogeneity across the retained measured records, because the amplitude model itself is numerical while the later scenario-scaling stage returns the predictions to physical units.

The explanatory variables are built from maximum instantaneous charge $Q$, source-to-receiver distance $D$, scaled distance $S$, and monotone transforms of $Q$ and $D$. The feature vector used by the distance-charge models can be written as

$$
\mathbf{x}(D,Q)=
\left[
Q,\ \log Q,\ Q^{-1},\
D,\ \log D,\ D^{-1},\
S
\right],
\qquad
S=\frac{D}{\sqrt{Q}} .
$$

The model is evaluated on a regular $D$-$Q$ scenario grid. In the current scenario set, the grid spans the adopted distances and MIC values used for dynamic-demand generation, and the exported predictions retain the same response definitions used in the measured records. This keeps the model target, the scenario target, and the later scaling operation in the same amplitude convention.

For a response $Y$, the supervised regression model is written as

$$
Y \mid \mathbf{x} = \eta_Y(\mathbf{x})+\varepsilon_Y,
$$

where $\eta_Y(\mathbf{x})$ is the conditional mean response and $\varepsilon_Y$ is the residual term. Cross-validation provides out-of-fold predictions for the measured records, and those out-of-fold residuals define empirical predictive offsets. For each scenario point, the predictive amplitude at quantile level $p$ is

$$
\widehat{Y}_p(D,Q)
= \max\{0,\widehat{Y}(D,Q)+\widehat q_p(r)\},
\qquad
r_i = Y_i - \widehat{Y}^{\mathrm{OOF}}_i .
$$

Here $\widehat{Y}(D,Q)$ is the fitted amplitude at the scenario point, $r_i$ is the residual between the observed training response and its out-of-fold prediction, and $\widehat q_p(r)$ is the empirical residual quantile at level $p$. The lower bound at zero enforces the physical sign convention for peak amplitudes. The scenario predictions are retained at $p=0.50$, $0.90$, and $0.95$.

The amplitude modelling is organized around the role of PPA in scenario generation. Component PPA predictions are the target peak accelerations used to scale the processed acceleration histories. PPV remains a reported vibration-amplitude response and can also be modelled conditionally on estimated companion responses, including PPA-family estimates, when the accepted multi-response run is used for final PPV reporting.

In the conditional multi-response formulation, the predictor set for response $Y_j$ is augmented with estimated values of the other amplitude responses. In compact notation,

$$
\mathbf{x}^{(t)}_j =
\left[
\mathbf{x},\
\widehat{\mathbf{Y}}_{\setminus j}^{(t-1)}
\right],
\qquad
\widehat{Y}^{(t)}_j =
f_j\!\left(\mathbf{x}^{(t)}_j\right).
$$

For measured records, the companion-response values in $\widehat{\mathbf{Y}}_{\setminus j}^{(t-1)}$ are out-of-fold estimates. For scenario-grid records, they are the corresponding grid predictions. This construction makes the conditional information seen during model assessment comparable to the information available during scenario prediction. Each response retains the model stage with the best cross-validated performance; in the accepted run, the conditional stage was retained for the PPA-family responses and for the resultant and horizontal PPV components, while the vertical PPV component retained the unconditional model.

The accepted multi-response run reports lower out-of-fold RMSE for the PPA-family responses than for the PPV-family responses in their native units. The final RMSE values are 0.0379 g for resultant PPA and 0.0264, 0.0236, and 0.0220 g for the L, T, and V PPA components; the corresponding PPV-family values are 2.8077 mm/s for resultant PPV and 1.7609, 2.0186, and 1.5058 mm/s for the L, T, and V components. These results support using component PPA as the controlling amplitude target for acceleration-history generation.

## 4. Scenario Generation and Record Selection

Scenario generation translates the accepted component PPA predictions into acceleration histories for specified $D$, $Q$, and predictive-quantile levels. The current scenario set uses the processed source-record families retained after filtering, a distance grid from 150 m to 400 m, a MIC grid from 150 kg to 400 kg, and the $p=0.90$ predictive level. Each scenario retains many source-record realizations, so the generated set preserves waveform variability across measured blast histories while imposing the scenario-specific component PPA targets.

For a source record $j$ and original component $c \in \{L,T,V\}$, the scenario acceleration history is

$$
a'_{j,c}(t;D,Q,p)
= a_{j,c}(t)
  \frac{G\,\widehat{\mathrm{PPA}}_c(D,Q,p)}
       {\max_t |a_{j,c}(t)|} .
$$

Here $G$ converts the predicted PPA units to the acceleration units of the processed histories. The denominator is the source-record peak acceleration for component $c$. The scale factor sets the peak acceleration of each original component to its corresponding scenario PPA target while preserving the time coordinates and the normalized waveform shape within that component.

After scaling the original L, T, and V components, the vertical component is carried forward as the vertical input direction and the two horizontal components are rotated into principal horizontal directions. For a scaled horizontal pair $L'_j(t)$ and $T'_j(t)$, the principal direction angle $\theta_j$ is obtained from the leading eigenvector of the horizontal acceleration covariance matrix. The rotated horizontal histories are

$$
H1_j(t)=L'_j(t)\cos\theta_j+T'_j(t)\sin\theta_j,
\qquad
H2_j(t)=-L'_j(t)\sin\theta_j+T'_j(t)\cos\theta_j .
$$

This rotation expresses the scaled horizontal motion in principal axes for each source record and scenario. The generated time histories then support component intensity measures, response spectra, and horizontal spectral review through the median rotated horizontal spectrum.

Scalar amplitude scaling preserves the sample times, relative timing within a component, pulse order, normalized component waveform, and frequency locations of the measured trace. It changes the amplitude level and, when different factors are applied to different components, it can change the measured component amplitude ratios and the resulting vector directionality. These properties make the generated records suitable as scenario demand histories, provided the scaling factors, component convention, and interpretation limits are documented [-@LucoBazzurro2007; -@WhittakerEtAl2011NISTGCRScaling].

The scenario products are interpreted as scaled measured demand histories for dynamic response analysis. Excess pore pressure, cyclic mobility, deformation, and stability response remain outputs of the geotechnical model, conditional on the material model, initial effective stresses, drainage assumptions, and loading sequence. This separation is important because the same acceleration history can lead to different pore-pressure response under different tailings states, permeability conditions, constitutive parameters, and boundary conditions.

The scenario audit checks three properties of the generated histories; in the current study the checks were executed on the 125 Hz-bandwidth scenario family. The vertical scaling check confirms that the vertical peak acceleration matches the scenario target after unit conversion. The horizontal energy check confirms that the rotation from scaled L/T to H1/H2 preserves the quadratic horizontal energy within the adopted tolerance. The positive-peak check confirms that generated component peak accelerations are finite and positive for every retained scenario realization.

Record selection is a demand-characterization step. The current selection set ranks available scenario records by PGV of the principal horizontal direction and retains the twenty-five highest-ranked records per matching scenario. PGV is used as a demand descriptor for velocity-amplitude ranking; the selected-record inventory also reports the accompanying acceleration peaks, Arias intensity, CAV, CAV5, duration, and spectral descriptors to document the broader demand content that may influence saturated-tailings response.

Selection metrics are interpreted by their physical role. Peak measures describe the largest instantaneous demand; duration measures describe the available cycle window; Arias intensity and CAV describe cumulative acceleration demand; spectra and frequency descriptors describe the relationship between the imposed motion and the dynamic response range of the TSF. The dynamic model evaluates how those demand descriptors map into pore pressure, deformation, and performance indicators.

## 5. Results Organization

The results are separated into model performance, scenario generation, selection, and geotechnical response. Model performance reports the predictive quality of the amplitude model by response, component, and model stage. Scenario generation reports the coverage of the $D$-$Q$ grid, the generated source-record realizations, the scaling factors, and the audit checks. Record selection reports the retained histories and the demand descriptors used to rank or compare them. Geotechnical response results report $r_u$, deformation, and project-defined performance measures after the dynamic model is run.

The amplitude-model results begin with the PPA-family and PPV-family errors. PPA results are central because component PPA values define the acceleration targets used to generate the scenario histories. PPV results remain important because PPV is the conventional blast-vibration amplitude measure and a useful descriptor of velocity-related demand. The multi-response results are reported beside a baseline-versus-conditional comparison on the same response definitions; in the accepted run, conditioning materially reduced the PPA-family out-of-fold errors, while the PPV-family changes remained within the reproducibility margin of that comparison.

The scenario-generation results show the realization count, target PPA values, component scale factors, intensity measures, and response spectra for each selected $D$-$Q$ scenario. The audit summary is reported beside these products because it documents the scaling, rotation, and peak behaviour of the generation procedure and identifies the cases requiring review.

The record-selection results define the final demand ensemble passed to the geotechnical analysis. For each selected scenario, the report shows the selected records, their ranking metric, peak amplitudes, cumulative measures, duration measures, and representative spectral content. This lets the later dynamic response results be traced back to the demand realization that produced them.

## 6. Executive Summary

The study prepares traceable blast-induced demand histories for a later TSF dynamic response assessment. Measured vibration records are processed into consistent acceleration, velocity, and displacement histories, filtered with an adaptive EEMD reconstruction, reduced to intensity and spectral descriptors, and used as source waveforms for distance-charge scenarios.

Peak vibration amplitudes are modelled over the distance-MIC domain. Component PPA predictions define the target acceleration amplitudes for scenario generation, while PPV remains a reported vibration response and a conditional response in the multi-response amplitude model. The accepted amplitude model attains an out-of-fold $R^2$ of 0.87 for resultant PPA, and the conditional multi-response formulation materially improved the PPA-family errors relative to the unconditional baseline.

Scenario generation scales each retained source record to the selected component PPA targets, rotates the horizontal motion into principal directions, computes the intensity and spectral products, audits the generated histories, and selects records for the downstream effective-stress dynamic model. The current scenario set spans source distances from 150 m to 400 m and maximum instantaneous charges from 150 kg to 400 kg at the $p=0.90$ predictive level.

The generated records are dynamic demand histories. Pore-pressure generation, cyclic mobility, deformation, and liquefaction-type response are evaluated in the geotechnical model using the selected material state, drainage, constitutive, and boundary-condition assumptions.
