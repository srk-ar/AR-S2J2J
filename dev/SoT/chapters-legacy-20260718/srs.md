This chapter documents the selection and spectral matching of earthquake
ground-motion records for use in dynamic analyses of the project site. The
selected suite is intended to represent recorded motions that are compatible with
the controlling seismic hazard and with the target response spectrum adopted for
the analysis case. The relevant compatibility checks include amplitude level,
spectral shape, duration, tectonic environment, source-to-site distance, and site
conditions.

The target spectrum defines the spectral demand that the acceleration histories
must reproduce over the period range used in the analysis. Record selection is
therefore not limited to matching a single intensity measure. It also considers
whether the candidate motions have a seismological setting and a frequency
content that are consistent with the project hazard and with the expected dynamic
response of the system being analyzed.

Candidate records are obtained from indexed strong-motion databases and are
screened with project-specific seismological and engineering criteria. These
criteria may include moment magnitude, rupture or Joyner-Boore distance,
tectonic regime, site class or measured shear-wave velocity, component
availability, record quality, usable frequency range, and preliminary spectral
compatibility with the target motion. Event, station, component, and provider
metadata are retained so the selected records remain traceable to the original
recordings.

The selected acceleration time series are adjusted to the target spectrum using
the project modal-deconvolution procedure. The methodology follows empirical
mode decomposition concepts [@HuangEtAl1998], while the active implementation
uses Variational Mode Decomposition (VMD) [@DragomiretskiyZosso2014]. Each
record is decomposed into modal components and reconstructed so the adjusted
acceleration history satisfies the target spectrum over the specified period
range and tolerance.

This procedure is a form of response-spectrum matching implemented through
VMD-based modal decomposition. It preserves the record-level traceability of the
original accelerograms while modifying their spectral content in a controlled
manner. The adjustment is evaluated against the target spectrum rather than
treated as a separate alternative to spectral matching.

Matching diagnostics are reported at record level, including the initial and
final spectral misfit and the final check against the target tolerance. The
adjusted acceleration histories are then used to regenerate the velocity,
displacement, cumulative-intensity, response-spectrum, and scalar
intensity-measure products reported for the selected record suite. These
diagnostics and products provide the basis for verifying that the records used in
the dynamic analyses are consistent with the seismic demand adopted for the
project.
