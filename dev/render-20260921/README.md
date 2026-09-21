# Render e insumos versionados de AR-S2J2J — 2026-09-21

Se corrigió el árbol local de la rama `dev`, partiendo del commit
`dc26237309d13129b6bba465740841f25ce9349e`. Este recibo documenta la
validación local de la corrección antes de su publicación mediante Git.

## Faltantes confirmados

| Hallazgo | Evidencia y efecto | Corrección |
| --- | --- | --- |
| `.gitignore` excluía todo `data/iter/` | `_tbl/metrics.qmd`, `scripts/tbl/performance.R`, `scripts/tbl/comparison.R` y `_summary/executive.setup.qmd` necesitan snapshots de las iteraciones. El lector de métricas fallaba con `model-product contract is incomplete`. | Excepciones para convergencia, métricas por iteración y residuos iniciales; seis CSV recuperados. |
| Faltaban tres QMD ejecutivos | Los includes de `_index/summary.qmd` y su versión española los requieren. No había ninguna regla de ignore que los excluyera. | Recuperados de `kanameishi/AR-S2J2J.X`, commit `d9cc8093e8c7134ac412d1e43eaaac73f8174acf`, no del último checkpoint de ese repositorio. |
| Los masters incluían capítulos PSHA ajenos al informe Blast | Lectura de `report.en.qmd`, `report.es.qmd`, índices y plan histórico Blast. | Restaurada la secuencia de ocho capítulos: portada, resumen, introducción, registros, modelo, escenarios, confiabilidad y referencias. |
| Sólo existía `qrt.manifest.json` | Contiene los tres productos de este proyecto. | Copiado a `manifest.json`, conservando aliases, perfiles, salidas y destinos declarados. No se ejecutó despliegue. |
| Una instrucción decía que `scripts/gmsp/setup.R` estaba ignorado | `git ls-files` lo incluye y `git check-ignore --no-index` no lo excluye. | Corregida esa afirmación en `scripts/AGENTS.md`. |

Los tres QMD recuperados son `executive.setup.qmd`, `executive.qmd` y
`executive.es.qmd`, bajo `_summary/`. Conservan el texto histórico.

## Qué debe conservar Git

Además de fuentes, configuración, recursos y tablas finales que ya estaban
versionados, el render necesita estos archivos:

```text
data/iter/convergence.csv
data/iter/summary_0/metrics.csv
data/iter/summary_0/residuals_oof.csv
data/iter/summary_1/metrics.csv
data/iter/summary_2/metrics.csv
data/iter/summary_3/metrics.csv
```

Suman 441866 bytes. Proceden de la ejecución aislada de SSEL 0.5.1 en
`/private/tmp/AR-S2J2J-ssel-20260921-chain`: sus 13 productos finales
coinciden byte por byte con los productos actuales. Esa correspondencia
permite recuperar los snapshots sin cambiar la generación ni reentrenar.
El recibo está en [generation.csv](generation.csv).

Siguen excluidos `data/model`, `data/train`, `data/metrics`, `data/response`,
los demás archivos de `data/iter` y los intermedios del pipeline legado.
Los tres productos probados no los requieren. `html/`, `docx/`, `.quarto/`
y los caches son salidas regenerables. No se detectaron otros insumos
ignorados en los directorios de fuentes y recursos usados por estos masters.

`.git/info/exclude` sólo contiene comentarios. No hay `core.excludesfile`
configurado; el ignore global por defecto sólo excluye
`**/.claude/settings.local.json`. Ninguno explica los faltantes del render.

`.gitattributes` asigna `data/**` y `ref/**` a Git LFS. Un clon necesita
sus contenidos materializados: un puntero LFS no es un CSV ni un recurso
utilizable. Cambiar `.gitignore` no descarga esos objetos. La validación
local usó contenidos materializados; no verifica la disponibilidad de cada
objeto en el servidor remoto LFS.

## Validación y uso

Los renders se ejecutaron con el CLI público instalado, NGR CLI 0.3.0-dev,
paquete 0.4.0, en `/private/tmp/AR-S2J2J-close-20260921`:

```sh
ngr render --manifest manifest.json --only ppt --root /private/tmp/AR-S2J2J-close-20260921
ngr render --manifest manifest.json --only report.es,report.en --root /private/tmp/AR-S2J2J-close-20260921
```

Ambos comandos terminaron con código 0 y `[render manifest] complete`.
Se generaron ocho páginas por informe y 16 diapositivas, incluida la portada.
La revisión del HTML verificó las ocho respuestas SSEL, 106 pares OOF por
respuesta, tablas de comparación y navegación Blast. Se inspeccionó también
el informe y la diapositiva de métricas en el navegador. Esa primera revisión
detectó una superposición del título de métricas con el logo, corregida en
la actualización de recursos descrita abajo. Los logs están junto a este documento.

La copia de prueba contenía fuentes y recursos del índice de Git más las
diez altas necesarias: seis CSV, tres QMD y `manifest.json`. No dependía
de caches ni de modelos ignorados. El escenario añadido después para probar
plots no participó en estos renders.

Los archivos integrados coinciden con el candidato aceptado; sus hashes están
en [files.csv](files.csv). El dry-run público sobre la raíz real del proyecto
acepta los tres aliases. No se repitió el entrenamiento ni el render completo
sólo para cambiar de carpeta.

Las salidas aceptadas se copiaron a `html/report.es`, `html/report.en` y
`html/ppt` del proyecto, donde no había salidas anteriores. Se comprobó la
igualdad de los 1567 archivos copiados con los del candidato.

Desde la raíz del proyecto, todos los productos declarados se renderizan con:

```sh
ngr render --manifest manifest.json
```

Para seleccionar uno: `--only report.es`, `--only report.en` o `--only ppt`.
El manifiesto declara dos books HTML y una presentación RevealJS; no declara
DOCX ni decks paramétricos SRS. No usar `ngr pull --from sha` para convertir
este proyecto Blast en un scaffold SHA.

`scripts/runPlots.json` seleccionaba F80 y D50, ausentes en los escenarios
actuales. Se ajustó al contrato existente: F125, p90 y H1/H2/UP, manteniendo
`OVERRIDE: false`. El runner original `Rscript scripts/runPlots.R` pasó con
GMSP 0.8.0 en una copia aislada de `F125.D150.Q200.p90`: seis HTML PSA/TS,
sin errores atrapados, código 0. Sus cuatro insumos JSON/CSV conservaron sus
hashes. Véanse [plots.log](plots.log) y [plots.csv](plots.csv). Los plots de
prueba no se copiaron sobre los productos del proyecto.
La copia temporal del escenario y sus plots se eliminaron después de guardar
los recibos y comprobar que los insumos originales seguían intactos.

## Límite de los escenarios y de la entrega

La mezcla descrita en esta sección fue resuelta posteriormente por la
[regeneración completa de los 36 escenarios](../scenarios-20260921/README.md).
Los tres HTML actuales ya consumen esa nueva familia coherente y auditada.
Los párrafos siguientes conservan la evidencia del diagnóstico inicial.

Cuatro carpetas estaban parcialmente sustituidas por una ejecución
interrumpida de julio: `F125.D150.Q150.p90`, `F125.D200.Q150.p90`,
`F125.D250.Q150.p90` y `F125.D300.Q150.p90`. Sus IMW/sidecars difieren del
agregado conservado y de `data/audit/summary.csv`; las otras 32 coinciden.
La incidencia está documentada en
`dev/SoT/HANDOFF-BLAST-SCENARIO-EXPORT-DEFERRED-20260719.md` y en E127
de `dev/plan/blast-report/active.md`.

Los books y el ppt principal leen los agregados conservados, no las historias
TSW/PSW de esas cuatro carpetas. Esta corrección no regenera escenarios y no
certifica la coherencia de toda la familia para una entrega dinámica. El
texto ejecutivo histórico tampoco constituye una nueva validación de esas
historias. No se publicaron estos renders.

## Actualización de recursos NGR y título — 2026-09-21

Se incorporaron únicamente `lua/footer.lua` y `lua/page-footer.lua` del
base NGR instalado mediante `ngr pull --from ngr --force` con esos dos
paths explícitos. `manifest.json` conserva los tres productos y registra
solamente esos recursos administrados; no se aplicó el scaffold SHA.
El título de métricas se abrevia a «OOF Predictive Performance».

El candidato `/private/tmp/AR-S2J2J-footer-20260921` renderizó los tres
aliases con código 0. Las 17 páginas de contenido muestran
`Pub: 21/09/2026 Rev.a18dfec · DRAFT`; `DRAFT` corresponde a la procedencia
sucia declarada por el base instalado. Los textos de todas sus tablas
coinciden con el render anterior. La revisión visual de la diapositiva OOF
confirmó el título separado del logo, la tabla completa y el sello legible.

Se integraron los cuatro archivos del candidato y sus 1567 archivos de
salida, verificando igualdad por MD5. `ngr status --check` de los dos Lua en
el proyecto devuelve 0 y ambos aparecen `equal`. No se repitió el render
tras esa copia idéntica. Véanse [render-check.csv](render-check.csv),
[resources.csv](resources.csv), [resources-ppt.log](resources-ppt.log) y
[resources-books.log](resources-books.log). `files.csv` conserva el recibo
de la primera corrección; `resources.csv` identifica la revisión posterior.

Esa actualización de recursos no recalculó SSEL ni escenarios. Por orden
posterior del propietario, se regeneraron los 36 escenarios, se aprobaron
sus auditorías y se volvieron a renderizar los tres productos. Los informes
EN/ES ahora incluyen la auditoría y los espectros medianos de la nueva familia.
La generación de señales ya está resuelta; los entrypoints de decks TS/SRS
paramétricos independientes no se añadieron. Véase el
[recibo de regeneración](../scenarios-20260921/README.md).
Esta validación no incluyó un despliegue remoto de los informes.
