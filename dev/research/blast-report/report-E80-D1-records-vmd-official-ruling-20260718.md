# report-E80-D1-records-vmd-official-ruling-20260718

## Section

Blast report / E80-D1 — ruling del usuario sobre el procesamiento oficial VMD
de `records`.

## Report Purpose

Corregir, sin reescribir el ledger E80, la identificación del flujo que debe
documentar el reporte final. La inspección anterior distinguió correctamente
los productos históricos, pero no tenía autoridad para inferir cuál de ellos
era el flujo oficial. El usuario fijó esa autoridad el 2026-07-18.

## Sources Read

- Ruling directo del usuario del 2026-07-18.
- `dev/research/blast-report/report-E80-body-first-summary-crosswalk-20260718.md`,
  conservado como evidencia previa y no modificado.
- `dev/plan/blast-report/active.md`, único SoT mutable de este frente.

Por instrucción del usuario no se inspeccionaron ahora JSON, corridas nuevas ni
productos generados.

## Exact Claims Allowed

- El flujo oficial que debe describir el reporte emplea VMD.
- La reconstrucción oficial retira el modo de baja frecuencia; bajo la
  convención VMD del proyecto, ese modo es IMF1.
- La corrida EEMD pertenece al flujo legado; en esa convención los modos de baja
  frecuencia eran IMF9 e IMF10.
- Es posible que otro agente haya lanzado corridas nuevas con VMD; su existencia
  y estado deben verificarse posteriormente en los JSON y productos, no
  presumirse en Resultados.
- El cuerpo vigente de `records` no representa todavía el flujo oficial porque
  limita VMD a diagnóstico y afirma que no se retiran modos.

## Claims Not Allowed

- Presentar EEMD como flujo oficial vigente.
- Tratar la decisión pendiente del handoff de reexportación sin retiro como
  arquitectura oficial después del ruling del usuario.
- Afirmar que una corrida VMD nueva terminó, fue aceptada o produjo resultados
  antes de revisar sus JSON, sentinels y artefactos.
- Usar el orden de los IMF de EEMD para interpretar el orden de los IMF de VMD.
- Mantener en prosa pública que VMD no modifica la historia.

## Equations Allowed

La formulación pública podrá expresar la reconstrucción VMD mediante

$$
a_c^{\mathrm{VMD}}(t)=
\sum_{k\in\mathcal K_{\mathrm{ret}}}u_{k,c}(t)+r_c(t),
\qquad 1\notin\mathcal K_{\mathrm{ret}},
$$

si la auditoría posterior del contrato oficial confirma que el residuo se
retiene y que esa notación coincide con el producto. La ecuación queda
bloqueada hasta esa verificación; el ruling acredita el retiro de IMF1, no el
tratamiento del residuo ni los restantes parámetros de la descomposición.

## Equations Excluded

- La batería de frecuencia central, ancho de banda y energía modal del cuerpo
  vigente, salvo que esos diagnósticos aparezcan en el producto final y sean
  necesarios para justificar la selección.
- La reconstrucción EEMD histórica como formulación del método oficial.
- Cualquier enumeración de parámetros VMD todavía no verificada.

## Vocabulary Allowed

- VMD; reconstrucción; modo de baja frecuencia; IMF1; modos retenidos; historia
  reconstruida; flujo oficial; corrida legado; verificación pendiente.

## Vocabulary Rejected

- VMD exclusivamente diagnóstica; historia completa sin retiro; EEMD oficial;
  IMF9/IMF10 como modos VMD; modo físico; componente verdadera; corrida
  aceptada sin evidencia.

## Candidate Public Paragraph Or Section

None. El cuerpo se reescribirá para describir VMD y el retiro de IMF1 después
de verificar, en una tanda posterior autorizada, los parámetros restantes y el
estado de la corrida nueva. No se usa la ecuación provisional como texto
público.

## Candidate Translation Terminology

None. El español continúa como master.

## Open Gaps

1. Revisar más adelante los JSON y productos de las corridas nuevas para
   identificar método, parámetros, tratamiento del residuo, fuente, estado y
   frescura.
2. Auditar el código oficial VMD para definir con precisión la reconstrucción y
   los controles que corresponden al reporte profesional.
3. Sustituir en `records.es.md` la formulación diagnóstica sin retiro por el
   método oficial verificado.
4. Parametrizar Resultados con la base VMD fresca y aceptada; no reutilizar la
   corrida EEMD legado.
5. Recién después ejecutar el crosswalk de `records.summary.es.md`.

## Validation

- El ruling queda separado de la evidencia anterior, sin alterar un ledger
  write-once.
- Ninguna afirmación de ejecución se promueve antes de revisar JSON y
  artefactos.
- La prosa final distingue método oficial, producto legado y resultado
  efectivamente verificado.
- Sin render, pipeline, JSON read, SSEL ni edición pública en esta corrección.
