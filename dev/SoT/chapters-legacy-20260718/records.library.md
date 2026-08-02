The source data are measured particle-velocity histories accompanied by event, station, component, sampling, and unit metadata. Particle velocity $v_c(t)$ describes the time evolution of motion in component $c$; its peak value, $\mathrm{PPV}_c=\max_t|v_c(t)|$, is a scalar amplitude. This distinction reserves PPV for amplitude modelling and scaling, whereas signal processing operates on the complete history $v_c(t)$.

Available records are organized through the instrumental index and retain their association with the event, station, and longitudinal, transverse, and vertical components. No design distance or MIC condition is assigned at this stage, amplitudes are not scaled, and records are not selected using intensity measures. The result is a traceable population of measured waveforms independent of the PPV/PPA predictive model.

For each component, the canonical representation contains the measured velocity history and the acceleration and displacement histories derived from it, with a common time axis and consistent base units. Peak measures are calculated directly from these histories:

$$
\mathrm{PGA}_c = \max_t |a_c(t)|,\qquad
\mathrm{PGV}_c = \max_t |v_c(t)|,\qquad
\mathrm{PGD}_c = \max_t |d_c(t)| .
$$ {#eq-signal-peak-measures}

These quantities describe demand amplitudes and connect the processed record to amplitude modelling, scenario generation, and subsequent selection. For the velocity histories used in this study, PGV and PPV denote the same maximum-absolute-value operation; PPV is used for the predicted physical amplitude, whereas PGV denotes the intensity measure computed from a time history.
