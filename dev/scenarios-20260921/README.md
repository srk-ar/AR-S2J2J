# Regeneración completa de los 36 escenarios — 2026-09-21

Integrada en el árbol local de AR-S2J2J, rama `dev`, por instrucción del
propietario: «no. regenera los 36 escenarios y actualiza el informe».
La familia completa sustituye la generación mezclada de julio. Este recibo
documenta la validación local previa al commit y push; no registra un deploy.

## Contrato y resultado

- Población fuente: `F125.Qo.Do.vmd`, 86 registros.
- Distancias: 150, 200, 250, 300, 350 y 400 m.
- Cargas MIC: 150, 200, 250, 300, 350 y 400 kg; probabilidad 0.90.
- Predicciones SSEL actuales; no se reentrenó el modelo.
- D50=false, D100=false, nTheta=36; espectros al 5 % de amortiguamiento.
- 36 escenarios, 3096 realizaciones y 9288 historias componentes en total
  entre H1, H2 y UP.
- GMSP 0.8.0; NGR paquete 0.4.0, CLI 0.3.0-dev.

`data/records/scenarios/` contiene los 36 conjuntos JSON/IMW/TSW/PSW y
el IMW agregado. `data/audit/` contiene las 36 auditorías y su resumen.
Los 36 escenarios pasan la auditoría nativa con la tolerancia contractual
0.001: PPV vertical, conservación de la norma horizontal al rotar y PGA
positiva. Cada partición IMW coincide exactamente con el agregado; sus
targets corresponden a las predicciones actuales con la precisión del JSON
producido por el runner.

## Informe actualizado

Los tres aliases de `manifest.json` renderizaron con código 0:

- `report.es`: ocho páginas HTML en español.
- `report.en`: ocho páginas HTML en inglés.
- `ppt`: presentación RevealJS de 16 diapositivas.

Ambos informes incorporan la tabla de auditoría y 18 gráficos de espectros
medianos: tres componentes por seis cargas, con seis distancias en cada
gráfico. Se reutilizaron los bloques existentes `audit` y `scenarios.PSA`.
Las tablas de los tres productos muestran los 36 targets actuales y 86
realizaciones por escenario. La inspección visual del capítulo de escenarios
confirmó tablas, tabs, curvas, leyendas y unidades legibles.

Las 17 páginas de contenido conservan el sello NGR. El marcador `DRAFT`
corresponde al build local del base instalado. El manifiesto sigue declarando
estos tres productos; esta entrega no añade entrypoints de decks TS/SRS
paramétricos independientes.

Desde la raíz del proyecto:

```sh
ngr render --manifest manifest.json
```

## Ejecución y evidencia

La generación y el render se hicieron en una copia aislada. El primer caso
terminó secuencialmente; se interrumpió ese proceso para continuar los otros
35 con el paralelismo nativo, `PARALLEL=true` y `OVERRIDE=false`. Los hashes
del primer caso se conservaron. El JSON original del proyecto no cambió.

`runScenarios.R`, `runAudit.R` y el render público terminaron con código 0.
La generación paralela emitió una advertencia de exportación duplicada de
variables; la auditoría posterior aprobó los 36 casos. El log de render no
contiene errores ni advertencias.

| Recibo | Contenido |
| --- | --- |
| [scenario-inputs.csv](scenario-inputs.csv) | Identidad de los 1097 insumos del candidato; 1095 conservaron sus hashes, salvo los dos QMD de resultados editados. |
| [targets-36.csv](targets-36.csv) | Predicciones actuales usadas para los 36 casos. |
| [targets-comparison.csv](targets-comparison.csv) | Diferencias respecto de los targets de la generación anterior. |
| [scenario-check.csv](scenario-check.csv) | Población, targets, agregado y auditoría de cada caso. |
| [scenarios-render-check.csv](scenarios-render-check.csv) | Targets publicados y cantidad de espectros en cada producto. |
| [scenarios-files.csv](scenarios-files.csv) | Los 1751 archivos integrados: 182 productos científicos, dos QMD y 1567 salidas HTML, verificados por MD5. |
| [scenario-baseline.csv](scenario-baseline.csv) | Identidad exacta de los 182 productos anteriores. |
| [scenario-baseline-lfs.csv](scenario-baseline-lfs.csv) | Objetos LFS locales del baseline, verificados contra los archivos originales. |

Logs: [generación](scenarios-parallel.log), [auditoría](scenarios-audit.log)
y [render](scenarios-render.log). El baseline científico anterior permanece
en el commit `dc26237309d13129b6bba465740841f25ce9349e` y sus objetos LFS
locales; no se creó otro respaldo de varios GB en `dev/`.

La integración copió exactamente el candidato aceptado y comprobó igualdad
de todos sus hashes. No se repitieron cálculo, auditoría ni render tras una
copia idéntica. La copia temporal se eliminó tras verificar la integración
y guardar estos recibos: 2846 archivos, 3861981105 bytes. El servidor local
de QA también quedó detenido.

## Despliegue con NGR

Se consultó el skill instalado `ngr` (release `46828e0ff9f8`) y se cotejó
con `ngr deploy --help`. Ambos admiten `manifest.json` V2. Este proyecto
declara los aliases `report.es`, `report.en` y `ppt`, asociados a los slugs
`ars2j2j-es`, `ars2j2j-en` y `ars2j2j-ppt`, respectivamente.

El 21 de septiembre no existía el registro local `.netlify/sites.env`.
`ngr deploy --manifest manifest.json --dry-run` falló con los tres aliases
sin registrar; `ngr deploy init --manifest manifest.json --dry-run` validó
el plan de registro. Ese plan no consulta Netlify ni acredita que los sitios
existan. No se creó ningún sitio ni se subieron archivos.

Para registrar los sitios ya existentes y publicar una nueva vista previa,
desde la raíz del proyecto:

```sh
ngr deploy init --manifest manifest.json
ngr deploy --manifest manifest.json --dry-run
ngr deploy --manifest manifest.json
```

Para sólo el informe español, añadir `--only report.es` a las tres formas.
El último comando crea un deploy de vista previa; `--prod` publica en
producción. No crea sitios ni vuelve a renderizar. Si el registro encuentra
un sitio inexistente, hace falta resolver su identidad y autorizar su
creación antes de usar `--create`. El dominio configurado en el manifest
no se vincula por ejecutar esos comandos.
