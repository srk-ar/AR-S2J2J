# LEDGER — Blast professional English terminology

Date: 2026-07-19

Status: active translation control. Spanish approved text is MASTER.

## How this ledger is used

The approved English column controls public wording but does not authorize new
technical claims. Every translation remains bounded by the meaning, equations,
results, and citations of the approved Spanish source. A source marked as
metadata or terminology support cannot be used to extend the methodology.

## Blasting and vibration

| Spanish master concept | Approved English | Rejected or restricted wording | Basis and scope |
|---|---|---|---|
| vibraciones inducidas por voladuras | blast-induced ground vibration | blasting vibrations; blast vibration effects when only demand is meant | U.S. Bureau of Mines RI 8507 and USBR blasting guidance; terminology support |
| historia temporal de velocidad de partícula | particle-velocity time history | velocity record when the measured quantity would be ambiguous | RI 8507; measured geophone quantity |
| velocidad pico de partícula | peak particle velocity (PPV) | peak velocity | RI 8507 and USBR guidance |
| aceleración pico de partícula | peak particle acceleration (PPA) | PGA; peak ground acceleration | Project response definition; preserve the distinction from earthquake PGA |
| carga instantánea máxima | maximum instantaneous charge (MIC) | maximum charge; Q as a field name | Project/contractor convention; first mention expands MIC |
| carga máxima por retardo | maximum explosive quantity per delay | MIC when the source actually uses a different definition | USBR terminology; use only when describing the cited source |
| distancia fuente--receptor | source-to-receptor distance | source distance where the receptor relation matters | Project geometry |
| distancia escalada | scaled distance | normalized distance | Langefors and Kihlström plus USBR guidance; retain the project equation |
| componente longitudinal / transversal / vertical | longitudinal / transverse / vertical component | lateral component for T; up component for V | Project sensor axes L/T/V |
| dirección horizontal principal / ortogonal / vertical | principal horizontal direction (H1) / orthogonal horizontal direction (H2) / vertical direction (UP) | objective component; target component | Project/gmsp convention |
| escenario de demanda dinámica | dynamic-demand scenario | scenario package; exported scenario | Project definition in the approved chapter |
| demanda dinámica inducida por voladura | blast-induced dynamic demand | blast load when no force history is defined | Report product boundary |

Primary terminology sources consulted:

- U.S. Bureau of Mines, *Structure Response and Damage Produced by Ground
  Vibration from Surface Mine Blasting*, RI 8507, official full-text record:
  <https://stacks.cdc.gov/view/cdc/201726>.
- U.S. Bureau of Reclamation, *Blasting Vibrations and Their Effects on
  Structures*, GR 85-9, official report:
  <https://www.usbr.gov/tsc/techreferences/research/GR8509.pdf>.
- U.S. Bureau of Reclamation, *Geology Field Manual*, Chapter 19, official
  blasting guidance:
  <https://usbr.gov/tsc/techreferences/mands/geologyfieldmanual-vol2/Chapter19.pdf>.
- Langefors and Kihlström, *The Modern Technique of Rock Blasting*, existing
  project BibLaTeX key `Langefors1963a`; used within the scope already cited by
  the Spanish chapter.

## Signal and response-history processing

| Spanish master concept | Approved English | Rejected or restricted wording | Basis and scope |
|---|---|---|---|
| descomposición modal variacional | variational mode decomposition (VMD) | variational modal decomposition | Dragomiretskiy and Zosso, key `DragomiretskiyZosso2014` |
| modo de baja frecuencia | low-frequency mode | trend IMF unless the source defines a trend | Project VMD convention; IMF1 only where the chapter defines it |
| derivación / integración | differentiation / integration | derivative processing / integrated record | Standard signal operations |
| corrección de línea base | baseline correction | drift removal when the operation is broader | Boore and Bommer, key `BooreBommer2005`, within cited scope |
| historia de aceleración / velocidad / desplazamiento | acceleration / velocity / displacement time history | accelerogram for a velocity history | Quantity-specific terminology |
| espectro de pseudoaceleración | pseudoacceleration response spectrum | acceleration spectrum | Standard earthquake-engineering product; preserve damping ratio |
| terna de historias | three-component set of time histories | triaxial record when referring to a set rather than an instrument | Professional ground-motion usage |
| factor de escala | scale factor | scaling coefficient unless the equation specifically defines a coefficient | Project scenario equation |
| normalización por PPV | PPV normalization | unit normalization | Project operation; state the applied ratio |

## Machine learning and SSEL

The current SSEL package documentation and implementation are authoritative
over older Brazil reports.

| Spanish master concept | Approved English | Rejected or restricted wording | Basis and scope |
|---|---|---|---|
| respuesta / predictor | response / predictor | target when the public text denotes the random response rather than an optimization target | SSEL documentation and statistical convention |
| observación | observation | sample when a row-specific statistical realization is meant | Statistical notation |
| modelo base | base learner | algorithm; base model where SSEL specifically defines a learner | SSEL README and manuals |
| predicción fuera de muestra de la partición | out-of-fold (OOF) prediction | held-out test prediction; unseen-data test result | SSEL and cross-validation contract; OOF is internal cross-validation evidence |
| ensemble por respuesta | response-level ensemble | Super Learner | SSEL contract; do not claim Super Learner equivalence without a separate proof |
| ponderación por RMSE / R² | inverse-RMSE weighting / R² weighting | optimal weighting; calibrated weighting | SSEL implementation |
| residuo OOF firmado | signed OOF residual | prediction error distribution without defining the sign | SSEL residual convention |
| cuantil empírico del residuo OOF | empirical OOF-residual quantile | calibrated prediction interval; confidence interval | SSEL postprocessing contract |
| cadena de respuestas acompañantes | iterative multi-response companion chain | regressor chain when exact equivalence is not established | SSEL vignette; Spyromitros-Xioufis et al. only for conceptual context |
| actualización simultánea | simultaneous Jacobi update | recursive update; sequential Gauss--Seidel update | SSEL implementation contract |
| iteración retenida por respuesta | response-specific retained iteration | final iteration; globally best iteration | SSEL response-specific first-max-OOF-R² rule |
| desempeño predictivo | predictive performance | model quality; accuracy for continuous responses | ML/statistical reporting |
| error cuadrático medio | root-mean-square error (RMSE) | average error | Standard definition; preserve the chapter equation |
| coeficiente de determinación | coefficient of determination, R² | correlation | Standard definition; preserve OOF scope |
| variable aleatoria / realización | random variable / realization | uppercase observation; lowercase random variable | SSEL/statistical notation ruling |

Local authoritative sources read:

- `/Users/averrik/Cloud/github/libraries/ssel/README.md`
- `/Users/averrik/Cloud/github/libraries/ssel/man/trainRegressionModel.Rd`
- `/Users/averrik/Cloud/github/libraries/ssel/man/oofEnsemble.Rd`
- `/Users/averrik/Cloud/github/libraries/ssel/vignettes/chain-regression.Rmd`
- `/Users/averrik/Cloud/github/libraries/ssel/man/chainPipeline.Rd`

Literature already cited by the Spanish chapter remains under its existing
BibLaTeX keys: Friedman for MARS and gradient boosting, Breiman for random
forests, Kohavi for cross-validation, and Spyromitros-Xioufis et al. for
multi-target regression context. The translation does not add a new algorithmic
claim from those references.

## Geotechnical risk and dynamic analysis

| Spanish master concept | Approved English | Rejected or restricted wording | Basis and scope |
|---|---|---|---|
| instalación de almacenamiento de relaves | tailings storage facility (TSF) | tailings dam when the system scope is broader | GISTM terminology |
| modelo dinámico en tensiones efectivas y deformación plana | plane-strain effective-stress dynamic model | dynamic deformation model when constitutive scope matters | Approved project methodology |
| estado límite | limit state | failure criterion when the equation defines a broader state | Ang and Tang; Benjamin and Cornell; project definition |
| función de estado límite | limit-state function | performance function only if introduced as an explicit synonym | Reliability convention |
| probabilidad condicional de falla | conditional probability of failure | failure likelihood | Reliability convention |
| índice de confiabilidad | reliability index | safety index | Reliability convention |
| demanda / capacidad | demand / capacity | load / resistance when the modeled quantity is $\mathcal C_\ell$ | Approved Spanish master and project limit-state notation |
| deformación dinámica | dynamic deformation | dynamic displacement when strain/deformation is the modeled quantity | Project model boundary |
| presión de poros | pore-water pressure | pore pressure where water phase must be explicit at first mention | Geotechnical convention |
| reducción de resistencia | strength reduction | resistance degradation unless the constitutive mechanism is degradation | Project formulation |

Authoritative terminology sources:

- Global Industry Standard on Tailings Management, official source:
  <https://globaltailingsreview.org/global-industry-standard/>.
- Existing project keys `AngTang1984` and `BenjaminCornell1970`, within the
  probabilistic definitions already present in the Spanish chapter.

## Cross-domain writing gates

- Use affirmative professional prose. Do not tell the reader how to interpret a
  plot and do not describe file handling, checks, gates, pipelines, sidecars,
  exports, or internal execution state as methodology.
- Preserve the separation among method, public product, and project result.
- Do not claim that SSEL is superior to a conventional regression unless a
  like-for-like OOF comparison on the same observations and folds is reported.
- Do not call empirical residual quantiles calibrated intervals unless coverage
  calibration is independently demonstrated.
- Do not hardcode changing results. Hyperparameters explicitly defined by the
  approved analysis may remain literal; metrics and hydrated results remain
  data-driven.
- Executive summaries remain self-contained but carry only the mathematics
  essential to state what was done. They are not supplements to the methodology.
- Public captions state the engineering evidence shown; they do not document how
  the builder or pipeline verifies it.

## Static parity gates

Before promotion, compare ES and EN inventories for:

- 37 equation IDs;
- 17 `sec-*` anchors;
- all BibLaTeX citation keys;
- all figure/table IDs and include order;
- all dynamic result expressions and parameter selectors.

Any mismatch requires a written ruling; translation alone cannot change these
contracts.

## Additions — 2026-07-20 (owner rulings)

| Spanish master concept | Approved English | Rejected or restricted wording | Basis and scope |
|---|---|---|---|
| licuación dinámica inducida por las voladuras | blast-induced dynamic liquefaction | seismic liquefaction; blasting liquefaction | Owner ruling 2026-07-20; study-purpose statement in the blast objectives |
| suite calibrada de registros de vibración de voladura | calibrated suite of blast vibration records | seismic record suite; scenario package | Owner ruling 2026-07-20; deliverable statement in the blast objectives |

## Addition — 2026-07-20 (owner ruling: seismic demand)

| Spanish master concept | Approved English | Rejected or restricted wording | Basis and scope |
|---|---|---|---|
| demanda sísmica inducida por las voladuras | blast-induced seismic demand | blast-induced dynamic demand (superseded by owner ruling 2026-07-20); blasting demand | Owner dictation in study objectives; standardized report-wide. «Dinámica» remains for the deformation model, the analysis, and dynamic liquefaction |
| escenario de demanda sísmica | seismic-demand scenario | dynamic-demand scenario (superseded 2026-07-20) | Same ruling |
