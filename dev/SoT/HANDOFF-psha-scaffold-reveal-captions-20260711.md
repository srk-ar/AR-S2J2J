# HANDOFF — captions numerados en PPT de `psha/scaffold`

## Objetivo

Corregir en `/Users/averrik/Cloud/github/tools/psha/scaffold/` los captions de figuras y tablas que aparecen como párrafos sin numeración ni estilo en los decks RevealJS. El patrón aceptado es el PPT de `AR-S2J2J.R`: float Quarto numerado, caption legible de 14 px y estilo consistente para figuras, widgets y tablas.

## Diagnóstico cerrado

No es un problema de versión de `qrt` ni de estilos.

- `qrt status` no reporta diferencias en `AR-S2J2J.R` ni en el consumidor representativo `AR-SABJ0.R`.
- `yml/_quarto-revealjs.yml` es idéntico en ambos proyectos.
- `styles/styles.css` es idéntico en ambos proyectos.
- Ambos aplican las reglas `.reveal .quarto-float-caption` y `.reveal ... figcaption` a 14 px.
- El directorio `tools/psha/scaffold/` no contiene `yml/` ni `styles/`; esos componentes llegan al proyecto consumidor mediante `qrt pull`.

La diferencia está en los QMD de productos:

- En el PPT activo de `AR-S2J2J.R`, los 94 chunks con `fig-cap` o `tbl-cap` tienen un `label` correcto: cero faltantes y cero prefijos incorrectos.
- En `psha/scaffold`, de 210 chunks con caption, 116 no tienen `label` y otros 5 usan una etiqueta que no empieza con `tbl-`.
- Un chunk correcto produce, por ejemplo, `<figcaption class="quarto-float-caption ... quarto-float-fig" id="fig-...-caption-...">` y Quarto antepone `Fig. 1:` o `Table 1:`.
- Un chunk sin label produce un `<p>...</p>` ordinario. No recibe numeración ni las reglas CSS de captions.

La documentación oficial de Quarto confirma el contrato: todo elemento referenciable requiere un identificador único y el prefijo define el tipo; las figuras deben usar `fig-` y las tablas `tbl-`.

- https://quarto.org/docs/authoring/cross-references.html
- https://quarto.org/docs/authoring/figures-and-layout.html
- https://quarto.org/docs/reference/formats/presentations/revealjs

## Evidencia HTML

En `AR-S2J2J.R/html/ppt/index.html`, `fig-demand-ppvL` se materializa como `figcaption.quarto-float-caption.quarto-float-fig` y comienza con `Fig. 1:`. Las tablas se materializan con `quarto-float-tbl` y comienzan con `Table 1:`, `Table 2:`, etc.

En `AR-SABJ0.R/html/ppt/index.html`, las curvas UHS generadas desde `_fig/UHS_Vs30.qmd` aparecen como párrafos que comienzan directamente con `Uniform hazard spectra...`; las tablas/curvas no etiquetadas de `kh` aparecen igual. Los objetos ya etiquetados del mismo deck sí generan `figcaption` y numeración. Esto descarta un fallo global de RevealJS o CSS.

## Archivos del scaffold afectados

Falta `label` en:

- `_fig/Dn_IDg.qmd`: 12
- `_fig/Dn_IDn.qmd`: 5
- `_fig/IPSA.qmd`: 24
- `_fig/ITS.qmd`: 24
- `_fig/kh_IDg.qmd`: 12
- `_fig/kmax_IDg.qmd`: 12
- `_fig/RMw2D_Tn.qmd`: 5
- `_fig/UHS_Vs30.qmd`: 6
- `_tbl/AF.qmd`: 1
- `_tbl/kh_IDg.qmd`: 12
- `_tbl/kh.qmd`: 1
- `_tbl/kmax.qmd`: 1
- `_tbl/PSA_Vs30.qmd`: 1, en la rama no HTML

Prefijo incorrecto en `_tbl/AF.qmd`: cinco labels `af5` a `af9`; deben ser labels `tbl-*`.

## Regla de corrección

1. Todo chunk con `fig-cap` debe llevar exactamente un `label: fig-<identidad-semantica>`.
2. Todo chunk con `tbl-cap` debe llevar exactamente un `label: tbl-<identidad-semantica>`.
3. Usar guiones, no underscores, en labels nuevos.
4. La etiqueta debe ser única dentro del QMD completamente expandido, no sólo dentro del archivo parcial.
5. No cambiar captions, gráficos, tablas, scripts R, CSS ni perfiles `qrt` para resolver este bug.

Ejemplo correcto:

```qmd
```{r}
#| label: fig-uhs-vs30-1250
#| fig-cap: !expr CAP |> sprintf(...)
source(file.path(root, "scripts", "fig/UHS.R"))
PLOT
```
```

Para una tabla:

```qmd
```{r}
#| label: tbl-kh-ensemble
#| tbl-cap: !expr CAP |> sprintf(...)
source(file.path(root, "scripts", "tbl/kh.R"))
TBL
```
```

## Repetición dinámica y `NGR::knitBlock`

`NGR::knitBlock(..., labels = "rewrite")` ya resuelve la identidad entre sitios. Expande recursivamente los includes y antepone el `stem` a labels `fig-*` y `tbl-*`. No hay que inventar labels con código R ni cambiar NGR.

Consecuencia: cada caption debe tener primero una etiqueta estática y única dentro del template. Cuando el slide se reproduce por sitio, NGR la transforma, por ejemplo, de `fig-uhs-vs30-1250` a `fig-<stem>-uhs-vs30-1250`.

Atención: `_slides/kh.qmd` y `_slides/kmax.qmd` incluyen varias veces el mismo wrapper de tabla dentro de un solo slide. Agregar el mismo label a `_tbl/kh.qmd` o `_tbl/kmax.qmd` producirá duplicados al expandir el template. No parchear NGR. Separar esos productos en wrappers semánticos con labels distintos —por ejemplo, ensemble, rigid y flexible— o mover los tres chunks al builder con etiquetas distintas. Mantener el cálculo en `scripts/tbl/*.R`.

## Secuencia recomendada

1. Recuperar primero el SoT propio de `psha`; no trabajar desde este handoff como si fuera su `active.md`.
2. Crear una auditoría estática de chunks: caption de figura exige `fig-`; caption de tabla exige `tbl-`; labels duplicados fallan.
3. Corregir primero `_fig/UHS_Vs30.qmd` como canary: seis labels semánticos por Vs30.
4. Sincronizar el canary en un worktree o copia temporal de un consumidor; no sobrescribir un proyecto sucio con `psha pull --force`.
5. Renderizar el deck por `tmux` con `qrt render <deck>.qmd --profile revealjs`; no volcar el log en el chat.
6. Verificar que las seis UHS sean `figcaption.quarto-float-caption.quarto-float-fig`, tengan IDs `fig-*` únicos y muestren `Fig. n:`.
7. Corregir los restantes archivos multichunk con labels únicos.
8. Resolver `kh`/`kmax` mediante productos semánticos separados; no reutilizar tres veces un chunk con el mismo label.
9. Renombrar `af5`...`af9` a `tbl-af-*` después de comprobar que no existan referencias `@af5`...`@af9`.
10. Ejecutar la auditoría estática completa y un render RevealJS representativo.

## Criterios de aceptación

- Cero chunks con `fig-cap` sin `label: fig-*`.
- Cero chunks con `tbl-cap` sin `label: tbl-*`.
- Cero labels duplicados después de la expansión de includes y de `NGR::knitBlock`.
- Todos los captions visibles del fixture están dentro de `.quarto-float-caption`; ninguno aparece como un `<p>` suelto.
- Numeración `Fig. n:` y `Table n:` presente y estable.
- El CSS y el perfil RevealJS permanecen sin cambios salvo que una prueba independiente demuestre otro defecto.
- Books y DOCX continúan renderizando; el chunk no HTML de `_tbl/PSA_Vs30.qmd` también recibe un label válido.

## No hacer

- No volver a ejecutar `qrt pull` esperando que corrija los QMD de `psha/scaffold`.
- No estilizar párrafos genéricos para que parezcan captions.
- No insertar manualmente `Fig. n` o `Table n` dentro de `CAP`.
- No usar JavaScript posrender para numerar.
- No cambiar los scripts productores ni convertir tablas/figuras en imágenes.
- No expandir NGR para resolver dos wrappers reutilizados; corregir primero la identidad editorial de los productos.

## Exact next action

En el repo `psha`, actualizar su `dev/SoT/ACTIVE.md -> active.md`, registrar el canary `_fig/UHS_Vs30.qmd` y ejecutar la auditoría estática antes de editar el scaffold.
