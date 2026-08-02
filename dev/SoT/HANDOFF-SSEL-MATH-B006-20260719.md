# HANDOFF candidato — SSEL MATH-B006, pesos de malla por celda

Estado: **candidato read-only preparado el 2026-07-19 13:26 -03**. Este
archivo no abre por sí mismo autoridad de escritura. Durante su preparación no
se modificó SSEL ni Blast, no se ejecutó R, no se lanzó ninguna prueba y no se
instaló ningún paquete.

## Objetivo acotado

Auditar y, sólo después de abrir un tema SoT de producción en SSEL y recibir
supervisión, corregir la pérdida de alcance de los pesos de ensamble entre las
etapas 2 y 3 de `trainRegressionModel()`.

El defecto mínimo observado es éste:

- en la etapa 2, `R2`, `RMSE` y `Yp` se reinician y calculan dentro de cada
  celda `response × dataset`;
- los ensambles OOF y sus métricas se forman inmediatamente con esos objetos
  de la celda vigente;
- después de finalizar esos bucles, sólo sobreviven en el entorno los objetos
  `R2` y `RMSE` de la última celda procesada;
- la etapa 3 recorre nuevamente las celdas y obtiene las predicciones base de
  la celda vigente, pero forma sus pesos con esos objetos supervivientes, sin
  reconstruir el estado métrico de la celda vigente.

No es una tarea de descubrimiento de métodos. El usuario declara la lista de
métodos y la entrega a SSEL mediante `trainModel()`/`predictModel()` y el
argumento `METHODS`; Blast la fija en sus runners y la pasa a
`modelPipeline()`. No inventar una lista esperada, no hacer fallar una celda
porque no aparezca todo método declarado y no reabrir el bug ya tratado de
nombres mixtos en `oofEnsemble()`.

## Autoridad y límites

Este handoff no autoriza:

- editar `/Users/averrik/Cloud/github/projects/AR-S2J2J.X`;
- ejecutar ni regenerar pipelines, mallas, cadena, escenarios o renders Blast;
- cambiar firmas, API pública, nombres de archivos, formato de artefactos,
  política de selección de datasets o fórmula de ponderación de SSEL;
- rediseñar `trainModel()`, `predictModel()`, `modelPipeline()` o la cadena;
- tocar vignettes, documentación CRAN o los temas concurrentes de SSEL;
- instalar, commitear, publicar o empujar cambios sin el gate explícito del
  propietario.

El topic `dev/plan/documentation-theory/` ya usa el identificador MATH-B006
para documentar la diferencia entre rutas ejecutables y explícitamente carece
de autoridad de producción. No se debe editar código bajo ese topic. El
sucesor debe registrar un tema SoT de producción separado y reconciliarlo con
`dev/SoT/ACTIVE.md` antes de tocar archivos.

## Secuencia obligatoria de recuperación

1. Leer completos:
   - `/Users/averrik/github/garage/harness/HARNESS.md`;
   - `/Users/averrik/github/garage/style/AGENTS.md`;
   - `/Users/averrik/github/garage/style/R.md`;
   - `/Users/averrik/github/garage/style/R-data.table.md`;
   - `/Users/averrik/github/garage/style/PRACTICE.md`.
2. En SSEL, leer primero:
   - `dev/SoT/ACTIVE.md`;
   - `dev/plan/cran-publication/active.md`, al que apunta ACTIVE;
   - las secciones MATH-B006 y D1-R002 de
     `dev/plan/documentation-theory/active.md`, sólo para preservar la
     separación de autoridades y el trabajo concurrente;
   - `dev/plan/oof-method-discovery/active.md`, sólo para comprobar que el bug
     de nombres mixtos es otro tema ya resuelto y no reabrirlo.
3. Leer completos antes de proponer un cambio:
   - `R/trainRegressionModel.R`;
   - `R/trainModel.R`;
   - `R/predictModel.R`;
   - el tramo de `R/model.R` que pasa `methods` a las dos fases;
   - `tests/testthat/test-trainRegressionModel.R`.
4. Leer la evidencia consumidora, sin editarla:
   - `/Users/averrik/Cloud/github/projects/AR-S2J2J.X/dev/plan/blast-report/active.md`,
     sección `E108 Authority Correction And New Evidence` y gate
     `MATH-B006`;
   - `/Users/averrik/Cloud/github/projects/AR-S2J2J.X/scripts/runModel.R`;
   - `/Users/averrik/Cloud/github/projects/AR-S2J2J.X/scripts/runChain.R`;
   - el manifest vigente de Blast usado por esos runners.
5. Registrar en el nuevo SoT el estado exacto de git, los diffs concurrentes,
   el experimento enfocado, los comandos previstos y el gate de instalación.
   No empezar por un parche.

## Estado concurrente que debe preservarse

Al preparar este handoff, SSEL estaba en HEAD
`2d934fe13291ee556d364f472cd35d6aba33fc05` y tenía un worktree ampliamente
modificado por trabajos aceptados o concurrentes. En particular,
`R/trainRegressionModel.R` y
`tests/testthat/test-trainRegressionModel.R` ya tenían cambios no commiteados
relacionados con backend paralelo, manejo de errores y pruebas. El sucesor debe
volver a observar el estado porque puede haber avanzado, atribuir cada diff y
preservarlo. Está prohibido restaurar o reemplazar esos archivos en bloque.

## Trazabilidad exacta del defecto observado

Referencia de líneas correspondiente al archivo visible durante esta
auditoría; volver a resolver las líneas si el archivo cambia:

- `R/trainRegressionModel.R:198-221`: bucle de etapa 2 por respuesta y dataset;
  `R2`, `RMSE` y `Yp` se reinician dentro de la celda.
- `R/trainRegressionModel.R:223-291`: se calculan y almacenan `r2`, `rmse` y
  predicciones OOF por método válido de esa celda.
- `R/trainRegressionModel.R:309-347`: se normalizan los pesos R2 e
  inverso-RMSE y se forma el ensamble OOF antes de abandonar la celda.
- `R/trainRegressionModel.R:391-430`: la etapa 3 inicia otro recorrido por
  respuesta y dataset y obtiene de `DT.metrics` los nombres válidos para el
  `set` vigente.
- `R/trainRegressionModel.R:431-500`: se calculan las predicciones base del
  `set` vigente.
- `R/trainRegressionModel.R:503-538`: `common_methods` y los pesos se obtienen
  de `names(R2)`, `names(RMSE)`, `R2[...]` y `RMSE[...]`; allí no existe una
  asignación que reconstruya esos objetos desde las filas métricas del `set`
  vigente.

`trainModel()` recibe `METHODS` del llamador y lo entrega como `.methods`.
`predictModel()` hace lo mismo durante la fase de predicción. En Blast,
`scripts/runModel.R` y `scripts/runChain.R` declaran explícitamente
`ranger`, `earth`, `gbm`, `gamSpline` y `glm`. Esta lista declarada es el
contrato; el arreglo no debe sustituirla por inferencia de nombres desde el
sistema de archivos.

## Evidencia Blast E108

E108 hizo una reconstrucción read-only a partir de CSV ya existentes, sin
reentrenar:

- en `data/iter/summary_0` a `summary_3`, las filas de malla
  `ensemble.RMSE` de cada respuesta se reproducen, con errores máximos del
  orden de `1e-14`, usando los pesos registrados para `ppvV`;
- no se reproducen con los pesos propios registrados para las otras
  respuestas;
- esa huella es coherente con que `ppvV` haya sido la última celda de etapa 2
  en esas invocaciones, pero el defecto no debe definirse como “hardcoding de
  ppvV”: depende del orden de ejecución y es reutilización de estado de la
  última celda.

La evidencia empírica E108 prueba el caso Blast vigente. El sucesor debe
contrastar el flujo de llamada completo, pero no necesita volver a ejecutar
Blast para demostrar la falla de alcance dentro de SSEL.

## Impacto exacto que debe conservarse en el diagnóstico

| Producto | Estado frente a este defecto |
|---|---|
| Métricas base OOF por método y celda calculadas en etapa 2 | No afectadas por esta reutilización: se calculan dentro de la celda. |
| Filas métricas de ensamble OOF formadas en etapa 2 | No afectadas por esta reutilización: el ensamble se forma antes de pasar a la siguiente celda. |
| Reconstrucción OOF, residuos y cuantiles de la ruta separada `oofEnsemble()` | No implicados por este defecto; E108 los mantiene como evidencia por celda. |
| Predicciones base sobre datos TEST/malla en etapa 3 | Corresponden a los modelos de la celda vigente. |
| Filas `ensemble.R2` y `ensemble.RMSE` sobre TEST/malla en etapa 3 | Afectadas: combinan predicciones de la celda vigente con pesos supervivientes de otra celda. |
| Figuras observado--OOF, métricas OOF y residuos OOF Blast | No afectadas por MATH-B006. |
| `Yo.csv`, curvas `demand.PPV/PPA` y escenarios que consumen el ensamble de malla | No certificables hasta corrección oficial, reinstalación y corrida fresca. |

No ampliar este diagnóstico a otros estimadores sin una traza independiente.
En particular, no mezclarlo con la selección posterior de dataset, la cadena,
los offsets residuales ni el descubrimiento de métodos mixtos.

## Estrategia mínima para el sucesor

1. Reproducir primero el defecto en una prueba enfocada de SSEL, sin usar el
   repositorio Blast como banco mutable.
2. Auditar dos alternativas de implementación sin prescribir de antemano el
   parche:
   - preservar explícitamente el estado métrico de etapa 2 indexado por
     `response × dataset`; o
   - reconstruir para cada celda de etapa 3 el estado de ponderación a partir
     de sus filas válidas en `DT.metrics`.
3. Elegir la modificación local más pequeña que mantenga la API y la semántica
   actuales. Para cada celda, los pesos deben usar sólo métodos que
   simultáneamente:
   - pertenecen a la lista `METHODS` declarada por el usuario;
   - tienen la métrica requerida válida en esa misma celda; y
   - produjeron una predicción válida para esa misma celda.
4. Mantener exactamente las políticas actuales de normalización: R2 para
   `ensemble.R2` e inverso del RMSE para `ensemble.RMSE`. No introducir una
   teoría nueva, umbrales, fallback global, lista esperada ni gate de
   completitud de métodos.
5. Ejecutar primero sólo la prueba enfocada registrada en SoT. Recién después
   del veto del propietario, ejecutar la suite que exija el topic de SSEL y
   preparar una instalación supervisada. La nueva corrida Blast pertenece al
   frente Blast y no a este handoff.

## Prueba de regresión mínima requerida

La prueba debe contener al menos:

- dos respuestas y al menos dos métodos declarados;
- métricas por método deliberadamente distintas entre respuestas, de modo que
  los pesos normalizados de A y B sean inequívocamente diferentes;
- predicciones base elegidas para que reutilizar los pesos de B en A produzca
  un valor distinto y detectable;
- aserciones de que el ensamble de malla de A usa los pesos de A y el de B usa
  los pesos de B;
- cobertura del ensamble de producción `ensemble.RMSE`; si el cambio toca la
  misma ruta R2, una aserción paralela pequeña es apropiada, no una nueva
  batería de pruebas.

El fixture puede aislar la fase de predicción mediante los patrones existentes
del paquete; no hace falta reentrenar una batería real de caret para probar la
identidad de ponderación. La prueba no debe exigir que todos los métodos
declarados sobrevivan: debe demostrar que cada celda pondera sus propios
métodos válidos.

## Criterios de aceptación y devolución

- SoT de producción SSEL creado y enlazado sin desplazar los topics
  concurrentes.
- Diff acotado y revisado con el propietario; ningún archivo Blast modificado.
- API, argumentos y lista declarada de métodos sin cambios.
- Prueba de dos respuestas falla antes y pasa después por la razón correcta.
- Métricas/ensambles OOF permanecen invariantes en la prueba enfocada.
- Cada ensamble de malla se reconstruye con métricas de su propio
  `response × dataset`, independientemente del orden de recorrido.
- Suite e instalación sólo si fueron autorizadas y registradas; informar HEAD,
  versión y ruta instalada si ese gate se completa.
- Devolver al frente Blast un aviso de readiness. Blast debe realizar después
  una corrida nueva de modelo/cadena/postproceso y verificar por CSV los pesos
  por respuesta antes de certificar `Yo.csv`, curvas de demanda o escenarios.

