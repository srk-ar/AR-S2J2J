
## Fuentes regionales (SSM)

El modelo de fuentes sísmicas (SSM) define la distribución espacial, la geometría y las tasas de ocurrencia de terremotos de todas las fuentes sismogénicas consideradas capaces de contribuir a la amenaza del movimiento del suelo en un sitio. En la integral de amenaza ([@eq-hazard-integral]), el SSM proporciona las distribuciones magnitud-frecuencia $f_{M,s}(m)$, las distribuciones espaciales $f_{\mathbf{R}|M,s}(\mathbf{r}|m)$, las tasas de ocurrencia $\nu_0^{(s)}$ y la magnitud máxima $M_{\max}^{(s)}$ para cada fuente $s$ [@Cornell1968; @SSHAC1997]. La incertidumbre epistémica en estos parámetros se captura mediante el árbol lógico del modelo de fuentes descrito en [@sec-ssm].

Este apéndice documenta el SSM del subcontinente indio adoptado en esta evaluación, incluidos el inventario de fuentes, la estructura del árbol lógico, los parámetros de recurrencia, los tipos de distribución magnitud-frecuencia, las relaciones de escalamiento magnitud-área, la caracterización de magnitud máxima y la arquitectura de profundidad sismogénica. El modelo se implementa en OpenQuake Engine mediante archivos XML de modelo de fuentes referenciados por el árbol lógico.

### Inventario de fuentes

El modelo IND se basa en el modelo probabilístico de amenaza sísmica para el subcontinente indio desarrollado por Nath y Thingbaijam [@NathThingbaijam2012], posteriormente actualizado y traducido al formato OpenQuake en colaboración con Natural Resources Canada (versión v2012.2.0), según se documenta en el informe del modelo GEM [@GemInd2012]. El dominio del modelo se extiende aproximadamente desde $60.0^\circ$E hasta $100.8^\circ$E en longitud y desde $2.0^\circ$N hasta $40.0^\circ$N en latitud, cubriendo India, Bangladesh, Bután, Nepal, Pakistán, Myanmar y regiones circundantes del subcontinente indio. La magnitud mínima de terremoto ($M_{\min}$) adoptada para los cálculos de amenaza es 4.5 Mw en todas las áreas fuente; las dos mallas de sismicidad suavizada emplean umbrales $M_{\min}$ de 4.5 Mw y 5.5 Mw respectivamente.

El SSM IND comprende 443,197 fuentes sísmicas de dos tipos: 108 áreas fuente (`areaSource`) y 443,089 fuentes puntuales (`pointSource`). Estas fuentes abarcan cuatro tipos de región tectónica (TRT); la tabla siguiente proporciona el censo completo por TRT y tipo de fuente.

```{r}
#| include: true
#| label: tbl-ssm-ind-inventory
#| tbl-cap: "Source inventory by tectonic region type."

DT <- data.table::data.table(
  `Description` = c("Subduction Intraslab", "Subduction Interface", "Stable Continental Crust", "Active Shallow Crust", "Total"),
  `TRT` = c("SIS", "SIF", "SCC", "ASC", ""),
  `Area sources` = c("35", "27", "17", "29", "108"),
  `Point sources` = c("139,942", "123,748", "94,433", "84,966", "443,089"),
  `Total` = c("139,977", "123,775", "94,450", "84,995", "443,197")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

El SSM se define mediante archivos XML de árbol lógico. El árbol lógico primario referencia tres archivos XML de modelo de fuentes y produce 27 ramas finales a partir del producto cartesiano de tres conjuntos de ramas ($3 \times 3 \times 3 = 27$). La estructura de conjuntos de ramas se describe en detalle en la sección Estructura del árbol lógico que sigue.

La caracterización de fuentes sísmicas sigue el marco clásico de PSHA delineado por Cornell [@Cornell1968] y formalizado bajo las directrices SSHAC [@SSHAC1997]. Las fuentes se delimitan a partir de evidencia geológica, geofísica y sismológica, con geometría y parametrización definidas en archivos XML de modelo de fuentes de OpenQuake. La implementación está disponible públicamente en el repositorio `nackerley/indian-subcontinent-psha` de GitHub [@NackerleyRepo].

### Estructura del árbol lógico

El árbol lógico del modelo de fuentes codifica incertidumbre epistémica mediante tres conjuntos de ramas, produciendo colectivamente $3 \times 3 \times 3 = 27$ ramas finales. Cada conjunto de ramas aborda un tipo distinto de incertidumbre epistémica; las ramas dentro de cada conjunto tienen asignados pesos que reflejan la credibilidad relativa de cada alternativa [@GemInd2012].

El conjunto de ramas 1 aborda la selección del modelo de fuentes, ofreciendo tres modelos de fuentes alternativos que representan la sismicidad regional. La rama `b1m1` selecciona el modelo de áreas fuente de 108 zonas; las ramas `b1m2` y `b1m3` seleccionan mallas de fuentes puntuales espacialmente suavizadas con umbrales $M_{\min}$ de 4.5 Mw y 5.5 Mw respectivamente.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs1
#| tbl-cap: "Branch set 1: source-model selection."

DT <- data.table::data.table(
  `Branch` = c("b1m1", "b1m2", "b1m3"),
  `Model file` = c("nt2012_areal_source_model_v1.xml", "nt2012_smoothed_source_model_v1_mmin4.5.xml", "nt2012_smoothed_source_model_v1_mmin5.5.xml"),
  `Weight` = c("0.40", "0.27", "0.33")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

El conjunto de ramas 2 aplica perturbaciones relativas simultáneas a la $M_{\max}$ base de todas las fuentes. Las ramas laterales simétricas ($\pm 0.3$ Mw) tienen asignado un peso de 0.32 cada una; la rama central sin perturbación tiene asignado el peso mayor de 0.36, reflejando mayor credibilidad atribuida a la estimación nominal del parámetro.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs2
#| tbl-cap: "Branch set 2: maximum magnitude perturbation."

DT <- data.table::data.table(
  `Branch` = c("b2m1", "b2m2", "b2m3"),
  `Perturbation (Mw)` = c("-0.3", "0.0", "+0.3"),
  `Weight` = c("0.32", "0.36", "0.32")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

El conjunto de ramas 3 aplica perturbaciones relativas simultáneas al valor $b$ de Gutenberg-Richter de todas las fuentes, con la misma estructura de pesos simétrica que el conjunto de ramas 2.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs3
#| tbl-cap: "Branch set 3: b-value perturbation."

DT <- data.table::data.table(
  `Branch` = c("b3m1", "b3m2", "b3m3"),
  `Perturbation` = c("-0.1", "0.0", "+0.1"),
  `Weight` = c("0.32", "0.36", "0.32")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

Los pesos combinados dentro de cada conjunto de ramas suman la unidad: las ramas de modelo de fuentes suman $0.40 + 0.27 + 0.33 = 1.00$; ambos conjuntos de ramas de perturbación suman $0.32 + 0.36 + 0.32 = 1.00$.

### Parámetros de recurrencia de terremotos

Las 108 áreas fuente emplean la MFD Gutenberg-Richter truncada (`truncGutenbergRichterMFD`), parametrizada por un valor $a$ y un valor $b$ con límites explícitos $M_{\min}$ y $M_{\max}$. La magnitud mínima es 4.5 Mw para áreas fuente en entornos de Corteza Superficial Activa, Corteza Continental Estable e Interfaz de Subducción; las fuentes de Subducción Intraplaca de Profundidad Intermedia abarcan un rango de valores $M_{\min}$ de 4.5 a 7.5 Mw que refleja la profundidad variable de las zonas profundas de la placa subducida. La incertidumbre epistémica en el valor $b$ se captura mediante el conjunto de ramas 3 del árbol lógico, que aplica perturbaciones relativas simultáneas de $-0.1$, $0.0$ y $+0.1$ (pesos 0.32, 0.36, 0.32); el tratamiento de la incertidumbre de $M_{\max}$ se aborda en la sección Magnitud máxima siguiente. Las dos mallas de fuentes puntuales de sismicidad suavizada heredan la misma parametrización Gutenberg-Richter de las zonas areales de origen, distribuida sobre una malla espacial regular; los nodos individuales de la malla tienen asignados valores $a$ redistribuidos espacialmente derivados de las tasas de las zonas de origen, y no de estadísticas de catálogo ajustadas de forma independiente [@NathThingbaijam2012].

@tbl-ssm-ind-recurrence resume los parámetros de recurrencia para las 108 áreas fuente agrupadas por tipo de región tectónica. Los valores $M_{\max}$ son estimaciones base (centrales) antes de la aplicación de la perturbación de árbol lógico de $M_{\max}$.

```{r}
#| include: true
#| label: tbl-ssm-ind-recurrence
#| tbl-cap: "Earthquake recurrence parameters by tectonic region type (108 area sources, base values)."

DT <- data.table::data.table(
  `Tectonic region` = c("Active Shallow Crust (ASC)", "Stable Continental Crust (SCC)", "Subduction Interface (SIF)", "Subduction Intraslab (SIS)"),
  `MFD type` = c("truncGR", "truncGR", "truncGR", "truncGR"),
  `a-value range` = c("2.73-7.08", "1.58-4.84", "3.12-5.40", "3.22-7.33"),
  `b-value range` = c("0.72-1.37", "0.63-1.19", "0.72-1.24", "0.80-1.57"),
  `Mmin (Mw)` = c("4.5", "4.5", "4.5", "4.5-7.5"),
  `Mmax range (Mw)` = c("7.0-8.8", "6.0-8.2", "6.5-9.4", "6.5-8.6"),
  `n` = c("29", "17", "27", "35")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

### Tipos de distribución magnitud-frecuencia

El modelo de fuentes IND emplea un único tipo de MFD para las 108 áreas fuente y todas las mallas de fuentes puntuales de sismicidad suavizada: la distribución Gutenberg-Richter truncada (`truncGutenbergRichterMFD`). Bajo esta parametrización, las tasas de ocurrencia de terremotos se expresan como una función log-lineal de la magnitud, acotada en $M_{\min}$ y $M_{\max}$, y gobernada por el valor $a$ (intercepto de tasa de actividad total en la magnitud de referencia) y el valor $b$ (pendiente de la relación frecuencia-magnitud). Los tipos de distribución `incrementalMFD`, `arbitraryMFD` y `multiMFD` no están presentes en este modelo; las formulaciones de MFD características o híbridas también están ausentes.

### Relaciones de escalamiento magnitud-área

Se aplican tres relaciones de escalamiento magnitud-área en diferentes ambientes tectónicos para relacionar la magnitud de momento con dimensiones de ruptura. La relación de Wells y Coppersmith (1994) (`WC1994`) [@WellsCoppersmith1994] se aplica a 46 áreas fuente en entornos de Corteza Superficial Activa y Corteza Continental Estable. La relación intraplaca de Strasser et al. (2010) (`StrasserIntraslab`) [@Strasser2010] se aplica a 35 áreas fuente en entornos de Subducción Intraplaca de Profundidad Intermedia. La relación de interfaz de Strasser et al. (2010) (`StrasserInterface`) [@Strasser2010] se aplica a 27 áreas fuente en entornos de Interfaz de Subducción. La suma $46 + 35 + 27 = 108$ representa todas las áreas fuente. Todas las áreas fuente adoptan una razón de aspecto de ruptura de 2.0.

### Datos de tasa de deslizamiento y balance de momento

Las tasas de actividad para fuentes de falla con datos de tasa de deslizamiento disponibles se derivan en principio del balance de momento sísmico, donde la tasa de momento sísmico $\dot{M}_0$ se relaciona con el módulo de corte $\mu$, el área de falla $A$ y la tasa de deslizamiento a largo plazo $S$:

$$\dot{M}_0 = \mu\, A\, S$$

El modelo de fuentes IND no contiene fuentes de falla. El inventario completo de fuentes consiste exclusivamente en 108 zonas sismogénicas areales y 443,089 fuentes puntuales espacialmente distribuidas en dos mallas de sismicidad suavizada; no existen archivos XML de fuentes de falla, y no se especifican datos de tasa de deslizamiento para ninguna fuente. En consecuencia, el número de fuentes con datos de tasa de deslizamiento es cero, y no resulta aplicable ningún rango de tasa de deslizamiento dentro de este modelo. Los parámetros de recurrencia para todas las áreas fuente se derivan de estadísticas de catálogo sismológico mediante ajuste Gutenberg-Richter, según se documenta en la implementación del modelo de fuentes [@NathThingbaijam2012; @GemInd2012].

### Magnitud máxima

La magnitud máxima ($M_{\max}$) define el límite superior de la MFD para cada fuente y es un parámetro crítico que controla la cola de la curva de amenaza. Para las 108 áreas fuente, los valores base de $M_{\max}$ varían de 6.0 a 9.4 Mw en los cuatro tipos de región tectónica, reflejando ambientes que abarcan desde corteza continental estable hasta entornos de megathrust de subducción. Los valores base más altos de $M_{\max}$ corresponden a zonas de Interfaz de Subducción, como los sistemas Sumatra e Himalaya-Main Frontal Thrust, donde se considera posible la ocurrencia de grandes terremotos que superan $M$ 8.5. Los valores $M_{\max}$ se asignan por zona a partir del estudio de caracterización sismotectónica de Nath y Thingbaijam [@NathThingbaijam2012] y se establecen como parámetros explícitos dentro de la especificación `truncGutenbergRichterMFD`.

La incertidumbre epistémica en $M_{\max}$ se captura mediante el conjunto de ramas 2 del árbol lógico (`maxMagGRRelative`), que aplica perturbaciones simultáneas de $\Delta = -0.3$, $0.0$ y $+0.3$ Mw a todas las fuentes (pesos 0.32, 0.36, 0.32). Para las mallas de fuentes puntuales de sismicidad suavizada, $M_{\max}$ se hereda de la parametrización de la zona areal de origen; los valores $M_{\max}$ de fuentes puntuales no están restringidos de manera independiente y siguen el mismo esquema global de perturbación.

@tbl-ssm-ind-mmax resume los rangos base de $M_{\max}$ por tipo de región tectónica junto con los límites epistémicos derivados.

```{r}
#| include: true
#| label: tbl-ssm-ind-mmax
#| tbl-cap: "Maximum magnitude characterisation by tectonic region type (base and epistemic bounds, area sources)."

DT <- data.table::data.table(
  `Tectonic region` = c("ASC", "SCC", "SIF", "SIS"),
  `Base Mmax (Mw)` = c("7.0-8.8", "6.0-8.2", "6.5-9.4", "6.5-8.6"),
  `Low (delta -0.3, Mw)` = c("6.7-8.5", "5.7-7.9", "6.2-9.1", "6.2-8.3"),
  `High (delta +0.3, Mw)` = c("7.3-9.1", "6.3-8.5", "6.8-9.7", "6.8-8.9"),
  `Derivation method` = c("truncGutenbergRichterMFD", "truncGutenbergRichterMFD", "truncGutenbergRichterMFD", "truncGutenbergRichterMFD")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

### Parámetros de profundidad sismogénica

El modelo de profundidad sismogénica en el SSM IND refleja una estructura multicapa consistente con el ambiente tectónico asignado a cada zona fuente. Las fuentes de Corteza Superficial Activa (ASC) se limitan a los primeros 25 km, con profundidad sismogénica superior $z_{\text{upper}}$ = 0 km, profundidad sismogénica inferior $z_{\text{lower}}$ = 25 km y profundidad hipocentral media de 15 km. Las fuentes de Corteza Continental Estable (SCC) abarcan $z_{\text{upper}}$ = 0-25 km y $z_{\text{lower}}$ = 25-70 km, con profundidades hipocentrales medias de 15-25 km. Las fuentes de Interfaz de Subducción (SIF) presentan $z_{\text{upper}}$ = 0-70 km y $z_{\text{lower}}$ = 25-180 km, con profundidades hipocentrales medias de 15-70 km. Las fuentes de Subducción Intraplaca de Profundidad Intermedia (SIS) ocupan la zona más profunda, con $z_{\text{upper}}$ = 25-180 km, $z_{\text{lower}}$ = 70-300 km y profundidades hipocentrales medias de 25-180 km. Las distribuciones de profundidad hipocentral se especifican como distribuciones de valor único con probabilidad 1.0 para todas las áreas fuente; es decir, se asigna determinísticamente una única profundidad hipocentral representativa a cada zona.

```{r}
#| include: true
#| label: tbl-ssm-ind-depth
#| tbl-cap: "Seismogenic depth parameters by tectonic region type (area sources)."

DT <- data.table::data.table(
  `Tectonic region` = c("Active Shallow Crust (ASC)", "Stable Continental Crust (SCC)", "Subduction Interface (SIF)", "Subduction Intraslab (SIS)"),
  `z_upper (km)` = c("0", "0-25", "0-70", "25-180"),
  `z_lower (km)` = c("25", "25-70", "25-180", "70-300"),
  `Mean hypocentral depth (km)` = c("15", "15-25", "15-70", "25-180")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

La estructura de profundidad refleja una arquitectura de tres capas: las fuentes corticales superficiales (ASC y la capa superior SCC) se limitan a los primeros 25 km; las zonas de profundidad intermedia (SCC inferior y las porciones superiores de las envolventes de subducción) se extienden hasta 70 km; y las zonas profundas de subducción intraplaca alcanzan 300 km de profundidad. Los amplios rangos de profundidad para SIF y SIS reflejan la variabilidad global de geometrías de subducción incluidas en el dominio del modelo, desde zonas someras de contacto de interfaz hasta rupturas profundas dentro de la placa subducida.