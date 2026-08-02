# Auditoría del rótulo raíz del sidebar del Book Blast

Fecha: 2026-07-20  
Gate: E135-A7k  
Alcance: diagnóstico de solo lectura; no se modificaron superficies públicas ni se ejecutaron renders.

## Síntoma verificado

Antes de A7i, los dos Books renderizados contenían el mismo fallback global y local:

- `html/report.es/index.html`: `<title>index</title>` y primer elemento del sidebar `index.html`.
- `html/report.en/index.html`: `<title>index</title>` y primer elemento del sidebar `index.html`.

Después de A7i/A7j, `title: "AR-S2J2J.X"` en `report.{es,en}.qmd` corrigió únicamente el título global. La inspección del HTML materializado por R46 verifica simultáneamente:

- `<title>AR-S2J2J.X</title>`;
- primer elemento del sidebar `<span class="chapter-title">index.html</span>`.

Por tanto, el cierre registrado por A7j confundió el título global del documento con el título local del capítulo raíz. No es únicamente una etiqueta visual producida por el navegador: `index.html` sigue materializado en la navegación generada por Quarto.

## Causa

`index.qmd` no declara actualmente `title`. El commit `24cd45c` (`finish blast report publication bundle`) sustituyó este front matter:

```yaml
title: "AR-S2J2J"
subtitle: "Impala BRPM TSF — Integrated Model of Blast-Induced Dynamic Demand"
```

por el front matter de la portada HTML, que sólo conserva `format.html.body-classes: cover-page`.

El identificador sigue existiendo como `params.project_id: "AR-S2J2J"`, y A7i agregó `title: "AR-S2J2J.X"` a `report.es.qmd` y `report.en.qmd`. Ese metadato nombra el Book y el `<title>` del HTML, pero no el capítulo raíz. Quarto no infiere el título de `index.qmd` a partir de `params.project_id` ni del título global del entrypoint; al no encontrar metadato de título en `index.qmd`, utiliza el nombre del archivo y genera `index.html` en el sidebar.

Por tanto, el defecto fue introducido al reemplazar la portada anterior por la portada programática sin preservar el metadato que alimentaba la navegación. No hay evidencia de un fallo de `qrt`.

## Alcance adicional

El `scaffold/index.qmd` actual de PSHA replica la misma omisión de `title`; por tanto, ésta es una regresión arquitectónica que también puede propagarse a proyectos hidratados. El HTML actual de `AR-SAC00.R` confirma otro fallback erróneo en el primer elemento del sidebar, aunque su texto concreto se deriva de contenido del documento en vez de `index.html`.

## Corrección mínima propuesta — no aplicada

Restituir un metadato de título de Book/capítulo raíz sin duplicar la portada visual. La ubicación debe decidirse después de una prueba aislada entre:

1. `book.title` en el manifest/configuración efectiva del Book, o
2. `title` en `index.qmd` con supresión explícita del bloque visual de título si fuese necesario.

El valor autoritativo actualmente observado es `AR-S2J2J` tanto en `params.yml` como en el historial de `index.qmd`. El rótulo escrito por el propietario, `AR-S2J2JX`, no coincide exactamente con esas dos fuentes; no se debe corregir ese valor por inferencia.

## Corrección canónica aplicada (A7m)

La prueba aislada R48 descartó `title: ""`: sin título de capítulo, Quarto conserva el fallback del nombre del archivo. La ruta aprobada utiliza `params.yml` como única fuente:

```yaml
metadata-files:
  - params.yml
title: "{{< meta params.project_id >}}"
```

El contrato fue incorporado en `psha/scaffold/index.qmd` y en el espejo hidratado de Blast. Los literales específicos agregados provisionalmente a `report.es.qmd` y `report.en.qmd` fueron retirados. La validación real ES/EN queda registrada como R54/R55.

## Veredicto

Diagnóstico cerrado: el sidebar muestra `index.html` porque la migración a la portada programática eliminó el `title` de `index.qmd`. Agregar `title` a `report.{es,en}.qmd` sólo corrigió el título global y no corrigió el sidebar. La corrección local todavía no fue aplicada.
