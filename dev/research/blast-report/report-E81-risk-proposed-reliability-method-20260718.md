# report-E81-risk-proposed-reliability-method-20260718

## Section

Blast report / E81 -- metodología propuesta de riesgo y confiabilidad.

## Report Purpose

Promover `risk` como una metodología propuesta completa, basada en la
separación demanda--capacidad del precedente Brasil y adaptada al contrato real
del proyecto: realizaciones temporales por escenario, respuesta de un modelo
dinámico de deformaciones, criterios de desempeño por estado límite y
probabilidad de falla condicionada al escenario. Los resultados numéricos
quedan a la espera del modelo geotécnico.

## Sources Read

- `psha/dev/SoT/HANDOFF-BLAST-PARTIV-TEXTS-SUCCESSOR-20260718.md`.
- `psha/dev/plan/blast-partiv/active.md`, incluido «EL HILO DEL DOCUMENTO» y
  los rulings posteriores.
- `dev/SoT/DRAFT-intro-objetivos-20260718.md` y
  `dev/SoT/chapters-mapb-20260718/risk.es.md`.
- `dev/plan/blast-report/active.md`, E71, E80 y E80-D4.
- Brasil `AR-M2P2B.R/qmd/report/_appendix_pf.qmd` y `_demand.qmd`, sólo como
  guía de arquitectura probabilística.
- `_chapters/risk.es.md`, `_chapters/risk.summary.es.md` y
  `_index/risk.ES.qmd`.

## Ruling

- El capítulo público propone el método; no se limita a describir una interfaz
  futura.
- El escenario se conserva como $s=(D,Q,p)$ y cada realización entrega una
  respuesta $\mathbf R_{s,r}$ del modelo dinámico.
- La demanda geotécnica, capacidad, indicador binario, $p_f$ ponderada y
  $\beta$ se formulan por criterio $\ell$.
- La unión automática de todos los estados límite incluida en el primer
  candidato E80-D4 se rechaza: el proyecto todavía no aprobó una regla conjunta.
- Del precedente Brasil no se trasladan PPV crítico, mecanismo de fractura,
  lognormalidad, independencia demanda--capacidad ni resultados.
- `Resultados` contiene una nota estática que declara la espera de las
  respuestas del modelo dinámico; no contiene cifras ni promesas de desempeño.

## Public Changes

- `_chapters/risk.es.md`: metodología completa en cuatro subsecciones y cuatro
  expresiones portantes.
- `_index/risk.ES.qmd`: agrega `Resultados` después de `Metodología`.
- `_summary/risk.results.es.qmd`: nota de espera del modelamiento geotécnico.
- El resumen ejecutivo permanece abierto para el crosswalk posterior contra el
  cuerpo ya cerrado.

## Claims Excluded

- Valores de presión de poros, deformación, desplazamiento, estabilidad,
  servicio, $p_f$ o $\beta$.
- Equiprobabilidad de una selección determinista.
- Un criterio conjunto de falla no aprobado.
- Riesgo anual, frecuencias de escenario o consecuencias.
- Ejecución, versión o calibración específica de PLAXIS, FLAC o PM4Sand.

## Validation

- Cero acceso o cambio a SSEL, datos, JSON o modelos dinámicos.
- Cero resultados hardcodeados.
- Referencias BibLaTeX existentes: `AngTang1984` y
  `BenjaminCornell1970`.
- Render diferido hasta registrar un experimento específico.

