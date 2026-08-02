# Status — productos Blast todavía no versionados

Fecha: 2026-07-20

Este archivo registra únicamente el inventario pendiente de decisión Git. No
autoriza regenerar, borrar, restaurar, stagear ni publicar datos.

## Publicación ya cerrada

- rama: `main`;
- `HEAD == origin/main == 38119b393727d0387667e3c7564ee7beb0f3856e`;
- bundle principal: `24cd45c`;
- estilos/footer canónicos: `38119b3`;
- no existen fuentes públicas pendientes bajo `_index`, `_chapters`,
  `_summary`, `_fig`, `_tbl`, `_slides`, `scripts/fig`, `scripts/tbl`, `yml`,
  `styles` o `lua`.

Los cuatro archivos activos de estilo/footer coinciden byte a byte con el
scaffold local de `qrt` en `1e5f506`:

```text
b75ccb088c5747263232d4b3da3399b9cc515f63668d93fa074f948239c8e02d  styles/theme.scss
b8836698de2dd45a0a9b97555f44d4d5fff662715cbb880bdc661dee925c8cd2  lua/page-footer.lua
4a8220fbc9101bf62d1acd756fb3cc8dd3355d1155fe1dc980c9e33ea7e04edb  yml/_quarto-book.yml
33926c2d55f13b6931d768103f2696b5b27bfe1830c0edf7d7af696b6a1e1dcc  yml/_quarto-html.yml
```

Los tres renders son posteriores a esos archivos y sus sentinels son cero:

- Book ES: `html/report.es/index.html`, 15:07:44;
- Book EN: `html/report.en/index.html`, 15:09:38;
- RevealJS: `html/ppt/index.html`, 15:11:07.

No se requiere un nuevo render por la hidratación de estilos.

## Único conjunto candidato a un commit de datos

Existen 50 rutas formales pequeñas modificadas o eliminadas. Antes de cualquier
stage se debe demostrar qué corrida las produjo, si constituyen el producto
oficial vigente y cuál es su contrato LFS:

- 38 rutas bajo `data/audit`: 36 auditorías de escenario modificadas,
  `summary.csv` modificado y `compare.csv` eliminado;
- `data/domains/units.json`;
- 6 rutas bajo `data/export`;
- 5 rutas bajo `data/summary`.

Este conjunto no está aprobado para commit. El gate siguiente es un ruling de
procedencia y producto oficial, ruta por ruta, seguido por stage mediante una
allow-list explícita. Está prohibido usar `git add .` o `git add -A`.

## Exclusiones obligatorias

No mezclar con el eventual commit anterior:

- `data/records/scenarios`: 3.2 GB, 36 directorios y 145 archivos; incluye 16
  archivos tracked modificados en cuatro escenarios, 32 directorios nuevos
  con 128 archivos y un `IMW.csv` agregado;
- `data/archive`: 437 MB y 416 archivos;
- `data/gmsp/F125.Qo.Do.vmd`: 751 MB y 8 archivos;
- `figure`: 6 PNG generados, 296 KB;
- `html`: 76 MB y 1565 archivos generados e ignorados;
- `docx`: 2 archivos generados e ignorados;
- 11 eliminaciones ajenas bajo `dev/BorrarTodaEstaMierda`.

No existe autorización para regenerar VMD o escenarios. Las once eliminaciones
ajenas no se restauran ni se publican desde este frente.

## Dependencia SSEL

Los defectos de descubrimiento mixto de métodos y MATH-B006 están corregidos,
probados e instalados en SSEL. El trabajo downstream que todavía corresponde a
Blast es decidir si se ejecutará una corrida fresca de modelo, cadena y
postproceso para certificar los productos de malla afectados históricamente por
MATH-B006. Esa decisión precede cualquier commit de las 50 rutas formales.

Live Runs: none.
