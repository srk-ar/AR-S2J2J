# AR-S2J2J y SSEL 0.5.1

## Objetivo y estado

Verificar los scripts actuales del proyecto con la biblioteca SSEL instalada,
preservando los resultados anteriores. Referencia del proyecto:
`1ba39ab335853216b1dc9bf0572973619242f0a9`. La rama `main` permanece en esa
referencia; esta revisión se prepara en una rama nueva `dev`.

`scripts/runModel.R`, `scripts/runChain.R` y `scripts/runPost.R` completaron
con SSEL 0.5.1, sin modificación de código ni parámetros. No se encontró una
incompatibilidad que requiera adaptar estos scripts. Este commit registra
la comprobación; mantiene intactos los programas y productos anteriores.

## Entorno y entradas

- macOS arm64, R 4.6.1; SSEL 0.5.1 instalado en la biblioteca de usuario.
- CLI SSEL 0.4.0 observado. Esta comprobación ejecuta los scripts originales,
  que llaman la API pública R; no convierte el manifest del proyecto en un
  spec del CLI.
- `scripts/manifest.json`, `data/blastDB.csv` y los constructores originales
  `scripts/runData.R` y `scripts/data/*.R` de esta referencia.
- Dataset `QDS`; respuestas `ppv`, `ppvL`, `ppvT`, `ppvV`, `ppa`, `ppaL`,
  `ppaT`, `ppaV`; métodos `ranger`, `earth`, `gbm`, `gamSpline`, `glm`;
  semilla 42 y ensemble `ensemble.RMSE`, tal como los scripts los declaran.

Se copiaron únicamente los cuatro runners, tres archivos de `scripts/data`,
el manifest y blastDB a dos directorios independientes fuera del proyecto:
`/private/tmp/AR-S2J2J-ssel-20260921-model` y
`/private/tmp/AR-S2J2J-ssel-20260921-chain`. Sus bytes se compararon con los
originales. Se creó `data/domains` vacío como directorio de salida del
constructor; ningún resultado viejo se copió como caché de modelos.

## Comprobación del flujo supervisado

Desde el primer directorio se ejecutaron, con exit 0:

```text
Rscript scripts/runModel.R
Rscript scripts/runPost.R
```

La preparación original produjo 1.448 filas de entrenamiento y 517 filas de
grilla. Los cinco métodos ajustaron las ocho respuestas: 40 archivos de
modelo y 56 filas de métricas, incluidas las dos combinaciones ensemble.
Las ocho respuestas tienen métricas finitas.

`Yo.csv` contiene 12.408 filas (517 × 8 respuestas × 3 niveles). La salida
`predictions.csv` contiene 11.790 filas en total; 3.102 corresponden a la
grilla (517 × 3 niveles × 2 estados de transformación). Las ocho respuestas
de esas filas son finitas y conservan `MIC` y `D`. La transformación continúa
siendo la declarada por el manifest: exponenciación en base 10.

El constructor avisó que 3.886 cocientes sL/sT/sV no finitos se convierten en
NA, como dispone su código actual. No se observaron avisos de métodos
fallidos o respuestas descartadas en este flujo. Esto verifica ejecución y
cobertura; no certifica capacidad predictiva ni interpreta los offsets OOF
como intervalos predictivos.

## Comprobación de la cadena

Desde el segundo directorio se ejecutaron, con exit 0:

```text
Rscript scripts/runChain.R
Rscript scripts/runPost.R
```

Se ejecutaron el ajuste inicial y las tres iteraciones Jacobi declaradas
(`maxIter=3`, `tol=0.01`, `patience=5`, `resume=FALSE`). En cada snapshot de
métricas aparecen las ocho respuestas y los cinco métodos más los dos
ensembles, con RMSE y R² finitos. La entrega final conserva 40 modelos,
56 filas de métricas y 12.408 filas en `Yo.csv`.

El postprocesado produjo 3.738 filas en `predictions.csv`, incluidas las
3.102 filas de la grilla con las ocho respuestas finitas y sus coordenadas
`MIC` y `D`. Esta cifra total difiere del flujo supervisado: no se afirma
igualdad de sus resultados. El propio flujo encadenado declara que reúne
la entrega por respuesta desde dos snapshots, mientras `data/model` y
`data/iter/Y.csv` corresponden a la última iteración.

La cadena emitió un aviso `In pf(nl.chisq/nldf, nldf, rdf): NaNs produced`.
Se conserva como observación: la ejecución terminó, y las comprobaciones
de cobertura y valores finitos anteriores pasaron. No se atribuye a una
función específica ni se presenta esta ejecución como libre de avisos.

## Preservación y reproducción

Los scripts originales escriben rutas `data/*` y pueden limpiar productos
anteriores. Una rama Git por sí sola no preserva productos ignorados. Por eso
la validación se ejecutó fuera de la raíz real. Los 24 archivos originales
de dominios, datasets y salidas presentes, 10.930.195 bytes en total,
mantuvieron tamaño y hash MD5. Los nueve archivos de entrada y scripts
también pasaron la comprobación SHA-256 de `inputs.sha256` al terminar.

No se ejecutaron `runGMSP.R`, `runScenarios.R`, selecciones PLAXIS ni renders
de este proyecto. No se modificaron fuentes, unidades, grillas, políticas de
admisión ni parámetros científicos. Los scripts existentes continúan siendo
los puntos de entrada; no se ha añadido un wrapper alternativo.

Para reproducir sin sustituir productos viejos, copiar a una raíz vacía
exactamente los nueve archivos enumerados en `inputs.sha256`, manteniendo
sus rutas relativas, y crear allí `data/domains`. Ejecutar el par model/post
o chain/post desde esa raíz. Para comparar ambos, usar dos raíces distintas:
la cadena vuelve a generar y limpiar los productos de su propia raíz.

`ssel-model-acceptance.json` y `ssel-chain-acceptance.json` registran la
cobertura comprobada; `ssel-runtime.log` identifica el entorno. Los logs
completos y los hashes de preservación originales están en la evidencia
local de NGR `dev/plan/s2j2j-ssel-20260921/`. Los outputs de prueba permanecen
en las dos raíces temporales indicadas, fuera del repositorio.
