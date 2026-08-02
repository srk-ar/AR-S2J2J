# AUDIT — Capítulos ES (calidad) y traducción EN vs ledger

Fecha: 2026-07-20. Frente E135-A6i. Read-only; hallazgos para ruling del
propietario. Alcance: `_chapters/{blast,records,model,scenarios,risk}` en ambos
idiomas, contra `dev/SoT/LEDGER-BLAST-ENGLISH-TERMINOLOGY-20260719.md`.
`ppt.qmd` excluido (sin texto). Contexto: los defectos C1–C4, C6 y «demanda
sísmica» ya fueron corregidos en batches previos (E135-A6c/A6h); este audit
cubre lo restante.

## Parte 1 — Calidad de los capítulos ES

- P1. **Orden del término MIC** («carga instantánea máxima» es el master del
  ledger y el uso dominante): dos ocurrencias invertidas como «carga máxima
  instantánea» en `_chapters/records.es.md:5` y
  `_summary/records.results.es.qmd:5` (sección Resultados del Book).
  Recomendación: normalizar al orden del ledger.
- P2. **Definición de $D,Q$ ausente en ES** donde el gemelo EN sí la tiene:
  `_chapters/model.es.md:175` usa «cada escenario $s=(D,Q,p)$» sin definir
  $D$ ni $Q$; el EN dice "where $D$ and $Q$ represent source-to-receptor
  distance and maximum instantaneous charge (MIC), respectively".
  Recomendación: espejar la cláusula al ES.
- P3. **Costura de notación entre capítulos** (registrar, no unificar):
  scenarios define la condición con minúsculas subindicadas $(d_s,q_s,p_s)$;
  model (l.175) y risk (l.1) usan la tupla $(D,Q,p)$ mayúscula; la malla
  predictiva usa $(d,q)$ continuas. Cada superficie define su notación en el
  punto de uso (con P2 aplicado, también model ES). Unificar exigiría tocar
  ecuaciones de scenarios y disparar los gates de paridad sin ganancia de
  significado. Recomendación: aceptar la convención documentada.
- P4. `_chapters/records.es.md:15` «La transformación se evalúa en ventanas
  superpuestas» — vaguedad menor (no dice qué transformación); el EN espeja la
  misma generalidad. Sin acción salvo que el propietario quiera precisar.

Los capítulos blast y scenarios ES no presentan hallazgos nuevos.

## Parte 2 — Traducción EN vs ledger

**Barrido de vocabulario rechazado: LIMPIO.** Cero ocurrencias en los cinco
capítulos EN de: blasting vibrations, velocity record, maximum charge (solo),
lateral component, accelerogram, acceleration spectrum, triaxial (para
conjuntos), scaling coefficient, normalized distance, unit normalization,
Super Learner, held-out, confidence interval, calibrated, tailings dam, safety
index, failure likelihood, blast load, Gauss–Seidel, regressor chain, trend
IMF. Términos aprobados presentes: blast-induced dynamic demand, base learner,
simultaneous Jacobi update (l.94/106 de model.md), out-of-fold (OOF),
principal/orthogonal horizontal direction, TSF, pore-water pressure, retained
iteration, response-level ensemble.

Hallazgos de consistencia y fidelidad:

- T1. **«supplementary» vs «complementary» para S11D (inconsistencia interna
  EN)**: records.md y blast.md usan *supplementary/supplement* (3 usos);
  model.md usa *complementary* (l.7 «The complementary S11D source», l.177
  «the complementary source»). El memo EN quedó alineado a *supplementary*.
  El «complementary response» de risk.md:1 (PPA) es otro sentido y NO se toca.
  Recomendación: unificar la fuente S11D a *supplementary* en model.md.
- T2. **Fidelidad scenarios.md:88**: el ES exige «historias no degeneradas,
  con PGA positiva en H1, H2 y UP»; el EN dice solo "must also be
  nondegenerate" y omite la especificación de PGA positiva. Recomendación:
  "…must also be nondegenerate, with positive PGA."
- T3. **«peak velocity» a secas** en `_summary/records.summary.md:7` (memo EN,
  párrafo 4): "scaled from its peak velocity to the predicted PPV". El ledger
  rechaza *peak velocity* como término; el ES dice «su velocidad pico»
  (también escueto). Recomendación: "from its peak particle velocity to the
  predicted PPV" y en ES «desde su velocidad pico de partícula».
- T4. **risk.md:1 estilo**: "the variable $Q$ representing maximum
  instantaneous charge (MIC)" es una circunlocución (nació de evitar el «Q as
  a field name» rechazado). Recomendación: "the maximum instantaneous charge
  (MIC) $Q$".
- T5. **model.md:96**: "the analysis sample" traduce «la muestra de ajuste»;
  más exacto "the fitting sample". Menor.
- T6. model.md:29 "Euclidean norm" vs ES «la norma de los tres picos» — el EN
  es más preciso; opcional armonizar ES a «norma euclidiana». Menor.

## Rulings solicitados

1. P1 — normalizar «carga instantánea máxima» (2 ocurrencias ES). Recomendado: sí.
2. P2 — cláusula de definición de $D,Q$ en model.es.md:175. Recomendado: sí.
3. P3 — aceptar la convención de notación documentada (no unificar). Recomendado: aceptar.
4. T1 — unificar a *supplementary* en model.md (2 ocurrencias). Recomendado: sí.
5. T2 — restituir «positive PGA» en scenarios.md:88. Recomendado: sí.
6. T3 — «peak particle velocity» / «velocidad pico de partícula» en el párrafo
   de escalamiento del memo (ambos idiomas). Recomendado: sí.
7. T4 — simplificar la introducción de $Q$ en risk.md:1. Recomendado: sí.
8. T5/T6 — ajustes menores (fitting sample; norma euclidiana). Recomendado:
   T5 sí; T6 opcional.

## Validación prevista tras rulings

`git diff --check`; re-barrido de vetos; paridad de claves de citas y eq-ids
por gemelo; los capítulos editados requieren re-render del Book ES/EN para
publicarse (agenda del propietario); el memo requiere re-render solo si se
aplica T3 (canario ES+EN).
