# HANDOFF — E26 velocity-anchor scenario cascade (2026-07-10)

> UPDATE (later same session, user "termina las corridas"): steps 1-2 of NOT DONE
> executed; F80 fossils + root IMW.csv also deleted. A runSemi export bug was
> found and fixed first (promoted grid rows unpublished — see active.md E26b);
> Yo.csv healed to 363 rows x 8 responses; books verified velocity-anchored; deck
> re-rendered clean. Cascade running at handoff-update time; verdict pending in
> `dev/plan/blast-report/active.md` (the authoritative surface).

Session ended on user order ("termina... actualiza los planes y deja un handoff")
BEFORE the E26 cascade relaunch. Everything below is live state, not intent.

## User directive (verbatim intent)

Scale factors are linear: one scalar per component moves PPV/PPA/PPD together.
PLAXIS consumes accelerograms either way. Therefore the scaling ANCHOR is PPV
(the well-predicted amplitude, adopted OOF R2 0.58-0.73), NOT PPA. The weak PPA
predictions leave the loop entirely ("no quiero usar las malas predicciones de
ppa"). PPA remains only as a reported conditional response.

## DONE (code + prose, all on disk, none committed)

1. `scripts/gmsp/setup.R` `.scaleAT` — velocity anchor:
   - GRID selects `ppvL/ppvT/ppvV` (was ppa*); keeps `Transformed == TRUE` filter
     (postProcess log/native twin-row trap).
   - Fail-loud unit bridge: ppv must be `mm/s`, gmsp TargetUnits must be `mm`,
     then `G <- 1` (gmsp `.getSF` has NO velocity mapping — do not "fix" via .getSF).
   - `Norm` = PGV from `ID == "VT"` peaks per RecordID/OCID; `eff = SF / PGV`;
     `.interp2D` on the ppv columns.
2. `scripts/runAudit.R` — same bridge (G=1, fail-loud); vertical check is now
   `pgv.UP` vs `SF.V*G` (UP.ok); energy check eff from VT peaks (`L.v`, `T.v`);
   reporting columns PGV.H1/H2/UP; PGA.pos retained.
3. Report chapters inverted to the velocity anchor, EN + ES twins:
   - `_chapters/intro.md` / `intro.es.md` — targets sentence.
   - `_chapters/amplitude.md` / `.es.md` — role paragraph (PPV targets, single
     scalar carries the accelerograms; PPA now the conditional response) and the
     closing metrics sentence.
   - `_chapters/scenarios.md` / `.es.md` — opening + realizations sentences,
     equation numerator PPV_c and denominator `max_t |v_{j,c}(t)|`, the $G$
     paragraph (velocity units; scalar rescales AT/DT too), audit sentence
     (vertical peak velocity).
   - `_chapters/results.md` / `.es.md` — centrality inverted (PPV central,
     PPA conditional descriptor); "target PPV values" in the scenario products.
   - `_chapters/summary.md` / `.es.md` — anchor sentence + scaling sentence.
   - Forbidden-term scan on the six EN chapters: CLEAN (only pre-existing
     approved "framework" in signal.md, not on the banned list).
4. Earlier this session: E23 (PPA-anchored) cascade STOPPED. `scripts/runSemi.R`
   adopted in production (semi-supervised PPV refinement, tau 0.15, gate-guarded).
   `scripts/runScenarios.json`: InputID F125.Qo.Do.eemd only, D/MIC 150-400 step
   50, p=0.90, D50 true, nTheta 36, OVERRIDE true.

## NOT DONE — exact next steps (in order)

1. **STALE FOLDERS**: `data/records/scenarios/F125.*` exist and are PPA-anchored
   (E23 leftovers). They MUST be deleted before any rerun — OVERRIDE=false resume
   would silently accept old targets. Command (repo root):
   `rm -rf data/records/scenarios/F125.*`
2. Relaunch the cascade (background, repo root, absolute paths; logs were agreed
   at /private/tmp/e26-*.log):
   `Rscript scripts/runScenarios.R > /private/tmp/e26-scenarios.log 2>&1 && Rscript scripts/runAudit.R > /private/tmp/e26-audit.log 2>&1`
3. Verify `data/audit/summary.csv`: all UP.ok / energy.ok / PGA.pos TRUE; UP.ratio
   ~1 confirms PGV(UP) == SF.V (velocity anchor working end-to-end).
4. Re-render: `qrt render report.en.qmd --profile book`, same for `report.es.qmd`,
   and `qrt render ppt.qmd --profile revealjs` (deck tables/curves are PPV-led
   already; verify no stale PPA-target wording in `_slides/`).
5. Record the E26 verdict in `dev/plan/blast-report/active.md` (Experiments) and
   clear its Live Runs entry.

## Pending beyond E26 (user-side gates, unchanged)

- ssel package commit GO (user must review diff; suggested 0.2.0 + NEWS.md +
  vignette notes: per-response invocation contract, OOF gauge). SoT plan:
  `~/github/libraries/ssel/dev/SoT/PLAN-semi-supervised-prototype.md`.
- Spanish chapter prose review (user).
- Export performance review (scenario export slower than seismic gmsp; suspects:
  86x36 spectra sets, D50 rotation, PARALLEL=false) — recorded in active.md Pending.
- Final export scope deferred; NO runSelect rerun; selection objects unpublished.
- Stage 2 IDUAPRIEM: reserved handoff
  `scripts/dev/sot/HANDOFF-agent-wave3d-vmd-modal-attenuation-2026-07-06.md`.
- NO Co-Authored-By trailers in any commit (global rule).

## Hard constraints (do not re-litigate)

- Site-only training (68 IMPALA rows) is a hard ceiling; no stage-2 monitoring
  campaign. F80 is OUT of the analysis; F125 is the input family.
- log10-response model, earth+gamSpline, H1 manifest config (QDS-only datasets,
  post.transform exp base 10). PPV from iteration 0 + semi refinement; PPA from
  chain. Physical gates (Q-shift monotonicity at D=300, near-field sanity at
  D=150/Q=400) run BEFORE any cascade.
- Scenario grid D/MIC 150-400; no training/predicting beyond D=700 for scenarios;
  Q domain = site envelope x2 = [60,598].
