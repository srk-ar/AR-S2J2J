# HANDOFF — Reexportación completa de series sin retiro selectivo de IMF

## Why This Exists

El usuario decidió el 2026-07-11 que la próxima sesión volverá a exportar las series de tiempo sin retirar IMF1/IMF9/IMF10 ni ningún otro modo selectivo. Este handoff abre una rama de trabajo paralela para otro agente. La sesión que lo escribió no modificó configuraciones de producción ni ejecutó GMSP, escenarios, auditoría, selección, exports o renders.

Fuente operativa obligatoria antes de actuar:

```text
dev/SoT/ACTIVE.md -> dev/plan/blast-report/active.md -> este handoff
```

## Objective

Regenerar de forma controlada y trazable todos los productos autorizados a partir de series fuente sin retiro selectivo de IMF, manteniendo separados:

1. cache fuente GMSP;
2. escenarios escalados;
3. auditoría de escenarios;
4. selección y preparación de entrega;
5. integración editorial, que sigue fuera de alcance hasta autorización separada.

## Current-State Contradictions

- `scripts/runGMSP.R` todavía fija `IMF.remove <- c(1L, -1L, -2L)` y `OVERRIDE <- FALSE`.
- Los caches existentes `.eemd` representan retiros selectivos; no pueden reutilizarse como evidencia del nuevo contrato.
- Sin retiro selectivo hay dos rutas técnicamente distintas que el usuario debe confirmar antes de una corrida cara:
  - **A — EEMD completa:** descomponer y reconstruir con todos los IMF + residuo, conservando diagnósticos EEMD.
  - **B — bypass:** usar directamente el cache canónico `F*.Qo.Do`; si no se modifica la señal, EEMD no es necesaria para producir las series.
- Debe decidirse una identidad de producto. Reutilizar `.eemd` ocultaría el cambio de contrato; crear un ID nuevo evita esa ambigüedad, pero exige actualizar consumidores.
- Los IDs de escenario codifican Fmax/D/Q/p, no la procedencia del cache. Dos variantes fuente pueden colisionar en `data/records/scenarios/`.
- `runScenarios.json` actualmente solicita F125 sobre 54 celdas y `nTheta=36`; el handoff anterior solicitaba 36 celdas y `nTheta=180`. “Exportar todo” no debe inferirse: confirmar familias, grilla, probabilidad, rotaciones, señales y componentes.
- `runPlots.json` y `runSelect.json` conservan alcances antiguos (F80 y una selección H1/AT/PGV); no representan por sí solos una exportación completa.
- `scripts/gmsp/setup.R` y `scripts/runAudit.R` contienen el contrato local PPV/PGV. Preservar esos cambios; no restaurar la lógica PPA obsoleta.
- La auditoría paralela observó productos parciales/rancios bajo escenarios, auditoría y selección. Tratar todo output existente como no aceptado hasta reauditarlo; no limpiar por patrones amplios sin inventario y aprobación.

## Scope

### Source cache

- `scripts/runGMSP.R`
- `scripts/gmsp/setup.R`
- configuración/identidad de `data/gmsp/F*.Qo.Do*`

### Scenario generation

- `scripts/runScenarios.R`
- `scripts/runScenarios.json`
- `data/records/scenarios/`

### Scenario audit

- `scripts/runAudit.R`
- `scripts/runAudit.json`
- `data/audit/`

### Selection and delivery preparation — separate approval gate

- `scripts/runSelect.R`
- `scripts/runSelect*.json`
- `scripts/select/buildIndex.R`
- `scripts/select/buildPlots.R`
- `data/records/plaxis*`

### Optional diagnostics — separate approval gate

- `scripts/runPlots.R`
- `scripts/runPlots.json`

## Out Of Scope

- Books, PPT, captions, scaffold, chapter text, tables/slides, SRS decks, Quarto renders, deploys, commits, and pushes.
- Model retraining or changes to SSEL predictions unless a later audit proves the accepted `predictions.csv` is invalid.
- Changes to `gmsp` or `ssel` library code merely to make this project run.
- Destructive cleanup before an exact-path inventory and explicit user approval.

## Safe Ordered Plan

1. **Recover state.** Read the active chain and this handoff; run the exact status command below; confirm `Live Runs = none`; inspect only bounded metadata for output trees.
2. **Create a dedicated workstream.** Because the current worktree is dirty, do not switch/reset it casually. Propose a dedicated branch/worktree only after showing the user which uncommitted project changes must be preserved.
3. **Contract gate.** Obtain explicit user decisions for:
   - EEMD-complete reconstruction versus bypass;
   - new source-cache ID versus controlled replacement;
   - F50/F80/F125 families;
   - D/MIC grid, probability level, D50/D100 and `nTheta`;
   - AT/VT/DT and H1/H2/UP export scope;
   - selection rule, N, ranking columns and destination;
   - whether “todo” includes only source/scenario products or also selection/delivery products.
4. **Register an experiment ID in active.md.** No source rebuild before the ID, inputs, exact command, output path and validation are written.
5. **Implement the smallest no-removal contract.** Do not assume that `IMF.remove=integer(0)` is sufficient. Verify on a synthetic or one-record fixture that the zero-length selection is handled, the reconstructed acceleration equals the intended full signal within a declared numerical tolerance, and the sidecar records an empty removal set. Preserve base caches when only the reconstruction product must change.
6. **Parse/smoke validation.** Parse affected R files and run the bounded fixture. Stop if the output identity, sidecar, AT/VT/DT completeness, or reconstruction invariant is ambiguous.
7. **Source-cache replacement gate.** Present expected paths and destructive/replacement behavior. Run source-cache generation only after approval. Never rely on `OVERRIDE=FALSE` skip logic for a changed contract.
8. **Validate source caches before scenarios.** Verify every approved family independently; record the verdict before any scenario command.
9. **Scenario gate.** Freeze the accepted `predictions.csv`, source IDs, grid and rotation configuration. Inventory and approve cleanup/replacement of exact scenario paths. Then generate the full approved scenario set once.
10. **Validate scenario products.** Require a complete scenario tree and a rebuilt master `IMW.csv` before audit.
11. **Audit gate.** Clear/replace only approved audit outputs, run `runAudit.R`, and record the fresh verdict.
12. **Selection/delivery gate.** Only after scenario and audit acceptance, confirm every selection parameter and destination. Run `runSelect.R`, then `select/buildIndex.R`, then `select/buildPlots.R` if plots were explicitly approved.
13. **Stop before editorial integration.** Report output paths and validation. Books/PPT/SRS/scaffold require a separate user order and a new plan.

## Validation

### Source cache

- Sidecar states no selective IMF removal and identifies the new contract unambiguously.
- Complete expected TSL/TSW/IMW/META/PSL products for every approved family.
- AT/VT/DT and component domains are complete; schemas and units agree.
- No NA/non-finite samples introduced.
- Aligned source-versus-reconstruction comparison shows no loss attributable to IMF selection; tolerance and metric are written before the run.
- TSL/TSW table conversions and IMW recomputation are coherent.

### Scenarios

- Expected scenario count equals the frozen D x MIC x InputID x p contract.
- Every scenario contains exactly TSW/PSW/IMW/JSON; no partial folders.
- Master scenario `IMW.csv` is rebuilt from the accepted scenario folders.
- Scenario sidecars point to the accepted new source identity.
- Physical PPV preflight passes without silently changing its tolerance.

### Audit

- Fresh audit row count equals the accepted scenario count.
- Every accepted scenario has `UP.ok`, `energy.ok`, `PGA.pos`, and `PASS` true.
- `UP.ratio` is consistent with the PPV/PGV scaling contract.

### Selection/delivery

- Expected count formula is written before selection.
- Record files match the frozen scenario, ID, direction, N and selection rule.
- Folder-level `IMW.csv` and `unique.csv` are rebuilt after all selections.
- Review plots, if approved, are built last from the final folder contents.

## Risks

- Silent reuse of old caches with `OVERRIDE=FALSE`.
- EEMD stochastic/runtime cost even when no modes are removed.
- New and old source variants sharing misleading `.eemd` or scenario IDs.
- Mixing partial old scenario/audit/selection products into a new master index.
- Changing the physical preflight tolerance to force a cascade through.
- Treating no-removal EEMD as physically different from the canonical cache without a measured reconstruction difference.
- Losing uncommitted PPV/PGV project changes while creating a branch/worktree.

## Exact First Command

Run from the project root, read-only:

```bash
git status --short scripts/runGMSP.R scripts/gmsp/setup.R scripts/runScenarios.R scripts/runScenarios.json scripts/runAudit.R scripts/runAudit.json scripts/runPlots.R scripts/runPlots.json scripts/runSelect.R scripts/runSelect.json scripts/select data/gmsp data/records/scenarios data/audit data/records/plaxis
```

Then write the audit result and the unresolved contract decisions to `dev/plan/blast-report/active.md`. Do not run `runGMSP.R` yet.
