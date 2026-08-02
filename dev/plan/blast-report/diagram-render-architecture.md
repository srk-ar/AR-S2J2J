# Arquitectura de render para diagramas metodológicos

## Decisión propuesta

Los diagramas metodológicos se escribirán de forma declarativa en archivos Mermaid independientes con extensión `.mmd` y se renderizarán mediante Quarto. No se generarán archivos DOT, no se escribirá un programa por figura y no se incorporará Python. R sólo se utilizará si en el futuro un diagrama debe construirse a partir de datos; no se necesita para componer diagramas editoriales.

La instalación local de Quarto 1.9.35 ya contiene una versión de Mermaid que admite cadenas Markdown con ajuste automático, el parámetro global `wrappingWidth` y las formas expandidas incorporadas desde Mermaid 11.3. Entre ellas se encuentran el documento con borde ondulado, documentos múltiples, proceso, subproceso, decisión, entrada o salida, almacén de datos, base de datos, display y operación manual. Esta capacidad se comprobó directamente en el paquete Mermaid distribuido con la instalación local.

Quarto admite archivos `.mmd` independientes mediante la opción `file` de una celda Mermaid. La figura puede editarse con vista previa en VS Code, Positron o RStudio y Quarto selecciona el formato de salida según el destino: Mermaid nativo en HTML y una imagen generada para PDF, DOCX y otros formatos sin JavaScript. La documentación oficial describe tanto la inclusión de archivos como la configuración temática y las variables CSS compartidas: [diagramas en Quarto](https://quarto.org/docs/authoring/diagrams.html), [formas y cadenas Markdown de Mermaid](https://mermaid.js.org/syntax/flowchart.html).

## Fuentes y responsabilidades

Los documentos `flow-master.md` y `flow-detail-a.md` contienen el texto metodológico revisado. Durante la revisión científica siguen siendo la fuente editorial. No contienen geometría, símbolos, colores, anchos, saltos de línea ni instrucciones de render.

Cuando se reanude el diseño, cada figura tendrá un único archivo `.mmd`. El texto aprobado se transferirá a cadenas Markdown de Mermaid y ese archivo pasará a ser la fuente de la figura renderizada. Mermaid ajustará los párrafos automáticamente; se prohíben `<br>`, saltos editoriales insertados para controlar el ancho y dimensiones fijadas por nodo.

Cada archivo `.mmd` declarará únicamente cuatro elementos: nodos, relaciones, clases semánticas y agrupaciones. No contendrá paletas completas ni estilos particulares por nodo. Una hoja SCSS común definirá tipografía, colores, espaciado, contornos y conectores para todos los proyectos. La ubicación definitiva de esa hoja debe resolverse en `garage/style` para evitar copias divergentes.

No habrá un script por figura ni un bloque de código por nodo. Los 187 bloques futuros serán declaraciones de contenido y relación que reutilizan la misma gramática y el mismo tema. Si más adelante se necesita generar diagramas desde inventarios tabulares, se diseñará un único constructor en R para todo el conjunto; esa necesidad no existe todavía y no debe anticiparse.

## Gramática de símbolos

La forma representa la función del elemento. El color representa la familia metodológica. No se utilizará una misma forma genérica para métodos, datos, modelos, documentos y revisiones.

| Función | Forma Mermaid | Uso permitido |
|---|---|---|
| Transformación metodológica | `rect` | Cálculo, modelamiento, filtrado, escalamiento, rotación o caracterización que transforma una entrada. |
| Subproceso desarrollado en otra figura | `fr-rect` | Etapa que posee un flujo interno documentado por separado. No se usa sólo para decorar un proceso. |
| Decisión o puerta de aceptación | `diamond` | Bifurcación real basada en una condición. La selección numérica de un óptimo no se dibuja como decisión si no abre ramas. |
| Entrada o salida transitoria | `lean-r` o `lean-l` | Datos que cruzan el límite de una etapa o figura sin representar almacenamiento persistente. |
| Conjunto de datos persistente | `datastore` | Tablas, índices, series temporales, predicciones, métricas o estados de modelo almacenados. |
| Base de datos o repositorio | `cyl` | Colección persistente consultada por varias etapas. No se usa para un único archivo. |
| Documento o auditoría | `doc` | Informe, auditoría, manifiesto o documento individual con borde inferior ondulado. |
| Paquete de documentos | `docs` | Inventario compuesto, conjunto de gráficos o paquete de entregables documentales. |
| Visualización para revisión | `display` | Gráfico o panel destinado a inspección; no representa el archivo que lo contiene. |
| Operación manual | `trap-t` | Revisión, aceptación o selección efectuada por una persona. |
| Inicio, término o conector | `circle`, `dbl-circ`, `f-circ` | Sólo cuando el límite o la continuidad del flujo necesiten ser explícitos. |
| Nota o límite de interpretación | `brace` | Advertencia breve, supuesto o exclusión metodológica. No contiene teoría ni ecuaciones. |

Las formas `note`, `card`, `tab`, `folder`, `box3d` y los paralelogramos utilizados como documentos quedan excluidos. No tienen una correspondencia adecuada con los productos científicos de estos flujos.

## Asignación inicial para el detalle de modelamiento

Las cinco etapas metodológicas son transformaciones y, por tanto, utilizan `rect`. Si el mapa maestro apunta a este flujo detallado como una unidad, el nodo que lo representa en el mapa maestro puede utilizar `fr-rect`.

La base de observaciones y los datos de análisis son conjuntos persistentes y utilizan `datastore`. La evidencia fuera de muestra es una auditoría y utiliza `doc`. El modelo seleccionado es un estado persistente del modelamiento y utiliza `datastore`, con una clase de color específica para modelos; no es una tarea ni un documento. Las predicciones físicas son datos persistentes y utilizan `datastore`. Las PPV longitudinal, transversal y vertical que pasan al escalamiento son una salida transitoria de la figura y utilizan `lean-r`.

Esta asignación elimina la categoría indiferenciada “producto técnico”. Cada salida se clasifica por lo que es y por la forma en que será consumida.

## Colores, tipografía y conectores

Las formas codifican función; los colores no deben repetir esa codificación. La paleta distinguirá familias metodológicas: modelamiento de amplitudes, procesamiento de registros, escalamiento y rotación, control de consistencia y selección o caracterización. Los artefactos usarán una saturación menor que los procesos de su misma familia.

La tipografía será sans serif y compartida con el informe. El título de nodo será breve y seminegrita; el cuerpo será un párrafo profesional en un cuerpo menor. Los estilos disponibles actualmente fueron concebidos para rótulos breves en mayúsculas y no son adecuados para prosa. Antes de componer una figura deberá programarse una capa tipográfica que distinga título, párrafo y metadatos, controle el ancho de lectura y mantenga jerarquía sin aumentar el tamaño de los nodos. Mermaid resolverá el ajuste mediante cadenas Markdown y esa capa definirá un `wrappingWidth` común por clase de figura. No habrá tamaños por nodo ni saltos manuales.

Los conectores serán finos y uniformes. Una línea continua representa una dependencia necesaria; una línea discontinua representa revisión, referencia u operación opcional. El grosor no codifica importancia. Las etiquetas de flecha sólo se usarán cuando el producto transferido no pueda deducirse de los nodos.

## Numeración

La numeración visible no formará parte de los nodos detallados. El orden se expresa mediante la topología del flujo y los títulos conservan estabilidad cuando se inserta una etapa. Si el índice metodológico requiere números, se generarán en el documento que enumera las etapas o se asignarán después de cerrar definitivamente la secuencia; no se escribirán dentro de cada bloque durante el desarrollo.

## Plan de adopción

1. Crear fuera de las figuras del informe una galería mínima con los símbolos aprobados, un párrafo real y el tema compartido. Esta prueba valida legibilidad, ajuste de texto y salida HTML, PNG y PDF.
2. Revisar y aprobar la gramática visual de la galería. No migrar figuras durante esta revisión.
3. Componer únicamente el detalle de modelamiento en un archivo `.mmd`, utilizando el texto cerrado y la asignación semántica anterior.
4. Validar contenido, proporciones, tipografía, conectores y formatos de salida. No integrar aún en books, PPT, captions o capítulos.
5. Componer el mapa maestro con la misma gramática y sin duplicar estilos.
6. Tras aprobar ambas figuras, trasladar el tema común a `garage/style` y documentar su uso para otros proyectos.
7. Migrar las figuras restantes una por una. No se hará conversión por lotes hasta que dos figuras de distinta complejidad hayan validado la arquitectura.

## Decisiones cerradas y pendientes

Quedan cerradas la separación entre contenido y estilo, la eliminación de DOT y Python por figura, el uso de ajuste automático, la semántica de símbolos y la prohibición de saltos editoriales. Quedan pendientes la aprobación de Mermaid como motor definitivo, la paleta exacta, el valor global de `wrappingWidth` y la ubicación final del tema compartido. Ninguna de esas decisiones pendientes requiere modificar los textos metodológicos.
