# EVIDENCE-ssel-architecture-20260709

Append-only evidence. Internal audit of the ssel chain machinery (agent-audited source with file:line citations) and its meaning for AR-S2J2J (2 physical features, 8 correlated responses). Complements EVIDENCE-implementation-stack-20260707.

## What the chain mathematically does here

- Chain features are OUT-OF-FOLD PREDICTIONS y_hat_k(x), i.e. functions of x alone (chain.R:12-60; oofEnsemble.R:44-110; own .o excluded per buildDataset.R:154). The chain therefore estimates E[Y_j | x, E_hat[Y_k|x]]: it transfers LEARNED MEAN STRUCTURE — each response's fitted attenuation surface becomes a nonparametric basis feature for the others. It does NOT exploit residual correlation Cov(Y_j, Y_k | x) (per-event coupling); feeding observed y_k would break the train/predict regime consistency ssel deliberately enforces (chain-regression vignette R1).
- Owner's thesis confirmed with this precision: "hidden features in the y's" = the shared latent attenuation shape, moved across responses through x. Mechanism closer to iterated stacking / self-distillation than to multivariate conditioning.
- This explains E18-V2: PPA (68 clean rows) gains strongly by borrowing the PPV surface (235 rows) — information flows from the data-rich channel to the data-poor one; PPV, already rich, gains nothing (stitched at iteration 0).

## Leakage audit

- First-order leak-free: OOF discipline is real (row's own response never enters its chain feature; caret savePredictions fold reconstruction in oofEnsemble.R:87-110).
- Honest caveats at small n: (i) R5 best-iteration stitch selects on the same OOF R2 it reports — winner's-curse optimism, material at n<100; (ii) r2 = cor(obs,pred)^2 (trainRegressionModel.R:280), not 1-SSE/SST — bias/scale-insensitive, optimistic; (iii) delta-convergence watches train rows only, grid predictions may still move; (iv) ensemble weights fitted on their own scoring data (moot with one method).

## Operational findings

- AR-S2J2J runs METHODS = c("ranger") ONLY (scripts/runChain.R:32): the K=3 ensemble is degenerate here, the ambiguity decomposition is void, and the semi-supervised design's confidence score (base-learner disagreement) is UNCOMPUTABLE with one learner. Restoring gbm+earth is a precondition for the semi-supervised step and would re-enable real ensemble variance reduction.
- chainGate "fixed" with chainThresh=0 = effectively ungated (all chain features active; chain.R:242): echo-chamber risk (components collapsing onto a shared surface). Mitigations available in-code: shadow gate, chainStable>1, iteration-0 fallback.
- AR-SABE0.R could not be audited directly (permission-blocked); reconstructed from ssel dev notes: model pipeline adopted, CHAIN STILL PENDING there — AR-S2J2J is the chain's actual proving ground. SABE0 techniques unused here: multi-view dataset declarations, 3-method ensemble, per-(sample,response) best-dataset selection as load-bearing feature.

## Semi-supervised step (gated design, semi-supervised.Rmd)

- Spec complete in the package: tri-training with co-regression confidence — promote predict rows (here: the QxD scenario grid) whose 3-learner prediction spread < tau; pseudo-label = ensemble value, frozen; refit via chainPipeline per round; mandatory held-out validation split with revert (default valFraction 0.2, epsRevert 0.02); stop on empty round/revert/cap/80% saturation; all behind M$semi$enabled=FALSE with byte-equivalence gate.
- The "one step" is literal: grid rows already carry chain features from their own predictions (transductive fixed point); flipping high-confidence grid rows to set=="train" with pseudo-labels turns the loop into self-training. In this regime it acts mainly as a smoothness prior over the response surface.
- Cautions for AR-S2J2J: restore >=2 base learners first; beware freezing extrapolation bias at grid edges beyond data support (Q>300 near-field cells).

## Parked (user): 36 per-cell models

Robust conditional medians per scenario cell are at most COMPLEMENTARY (diagnostic/verification of the global surface); trees force no continuity anyway. Requires a dedicated discussion with math and metrics on the table; "SSEL 36 times" is feasible by swapping per-cell datasets through the same machinery.
