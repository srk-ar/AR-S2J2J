
## Fuentes regionales (SSM)

El modelo de fuentes sísmicas (SSM) define la distribución espacial, la geometría y las tasas de ocurrencia de terremotos de todas las fuentes sismogénicas consideradas capaces de contribuir a la amenaza del movimiento del suelo en un sitio. En la integral de amenaza ([@eq-hazard-integral]), el SSM proporciona las distribuciones magnitud-frecuencia $f_{M,s}(m)$, las distribuciones espaciales $f_{\mathbf{R}|M,s}(\mathbf{r}|m)$, las tasas de ocurrencia $\nu_0^{(s)}$ y la magnitud máxima $M_{\max}^{(s)}$ para cada fuente $s$ [@Cornell1968; @SSHAC1997]. La incertidumbre epistémica en estos parámetros se captura mediante el árbol lógico del modelo de fuentes descrito en [@sec-ssm].

Este apéndice documenta el SSM de África del Norte y Occidental adoptado en esta evaluación, incluidos el inventario de fuentes, la estructura del árbol lógico, los parámetros de recurrencia, los tipos de distribución magnitud-frecuencia, las relaciones de escalamiento magnitud-área, la caracterización de magnitud máxima y la arquitectura de profundidad sismogénica. El modelo se implementa en OpenQuake Engine mediante archivos XML de modelo de fuentes referenciados por el árbol lógico.

### Inventario de fuentes

El modelo de fuentes sísmicas XAF comprende 255 fuentes sísmicas de dos tipos: 115 fuentes de falla simple (`simpleFaultSource`) y 140 fuentes multipunto (`multiPointSource`). Estas fuentes se clasifican bajo dos tipos de región tectónica: Corteza Superficial Activa (ASC, 150 fuentes) y Corteza Continental Estable (SCC, 105 fuentes). Dentro del grupo de fuentes de falla, 69 fuentes son ASC y 46 son SCC; dentro del grupo de fuentes multipunto, 81 son ASC y 59 son SCC. El modelo está codificado en archivos de árbol lógico con cinco conjuntos de ramas que producen $2 \times 3 \times 3 \times 3 \times 3 = 162$ ramas finales [@Poggi2020].

El dominio del modelo se extiende aproximadamente desde $19.5^\circ$W hasta $52.9^\circ$E en longitud y desde $28.7^\circ$S hasta $38.5^\circ$N en latitud, cubriendo África del Norte, África Occidental y partes de África subsahariana. La magnitud mínima de terremoto ($M_{\min}$) adoptada para cálculos de amenaza es 4.0 Mw para fuentes multipunto (con rango de 4.0 a 4.5 Mw según el grupo de fuentes) y 6.05 Mw para fuentes de falla simple [@Poggi2020].

Las 255 fuentes provienen del modelo probabilístico de amenaza sísmica de África del Norte desarrollado por Poggi et al. [@Poggi2020], ensamblado bajo el programa GEM Global Seismic Hazard Map. La geometría y la cinemática de las fuentes de falla se derivan de la GEM North Africa Active Fault Database (NAAFD) compilada por Styron y Poggi [@Styron2018]. La caracterización de fuentes sísmicas sigue el marco clásico de PSHA delineado por Cornell [@Cornell1968] y formalizado bajo directrices SSHAC [@SSHAC1997]; las fuentes se delimitan a partir de evidencia geológica, geofísica y sismológica, con geometría y parametrización definidas en archivos XML de modelo de fuentes de OpenQuake y codificadas en el árbol lógico.

### Estructura del árbol lógico

El árbol lógico del modelo de fuentes codifica la incertidumbre epistémica definiendo realizaciones alternativas del SSM. Cada conjunto de ramas aborda una fuente específica de incertidumbre; las ramas dentro de cada conjunto tienen asignados pesos que reflejan la credibilidad relativa de cada alternativa. El árbol lógico primario contiene cinco conjuntos de ramas que producen $2 \times 3 \times 3 \times 3 \times 3 = 162$ ramas finales [@Poggi2020].

El conjunto de ramas 1 gobierna la selección del modelo de fuentes y se aplica a todas las fuentes. Comprende dos ramas: `naf_faults` (peso 0.50), que incorpora `FaultSources.xml`, `GridMultiSources_C_L50_BG.xml` y los archivos colapsados de fuentes multipunto WAF y SSA; y `naf_smooth` (peso 0.50), que reemplaza las fuentes de falla explícitas por una representación puramente de sismicidad suavizada usando `GridMultiSources_C.xml` junto con los mismos archivos regionales colapsados [@Poggi2020].

Los conjuntos de ramas 2 y 3 se aplican a las fuentes del grupo de África Occidental (WAF) `MPS-1` a MPS-6. El conjunto de ramas 2 (`mmax_waf`, tipo `maxMagGRRelative`) aplica perturbaciones de magnitud máxima de $+0.2$, $0.0$ y $-0.2$ Mw con pesos 0.25, 0.50 y 0.25 respectivamente. El conjunto de ramas 3 (`bval_waf`, tipo `bGRRelative`) aplica perturbaciones del valor $b$ de $+0.05$, $0.0$ y $-0.05$ con la misma distribución de pesos [@Poggi2020].

Los conjuntos de ramas 4 y 5 se aplican a las fuentes de sismicidad suavizada de África del Norte (NAF) SC_1 a SC_54. El conjunto de ramas 4 (`naf_b`, tipo `bGRRelative`) aplica perturbaciones del valor $b$ de $+0.05$, $0.0$ y $-0.05$ con pesos 0.25, 0.50 y 0.25. El conjunto de ramas 5 (`naf_m`, tipo `maxMagGRRelative`) aplica perturbaciones de $M_{\max}$ de $+0.2$, $0.0$ y $-0.2$ Mw con los mismos pesos. La estructura de perturbación para el grupo NAF es estructuralmente idéntica a la del grupo WAF [@Poggi2020].

La tabla siguiente resume la estructura completa del árbol lógico de `ssmLT_XAF.xml`.

```{r}
#| include: true
#| label: tbl-ssm-xaf-lt
#| tbl-cap: "Logic-tree structure of ssmLT_XAF.xml."

DT <- data.table::data.table(
  `Branch set` = c(1, 2, 3, 4, 5),
  `ID` = c("sourceModel", "mmax_waf", "bval_waf", "naf_b", "naf_m"),
  `Type` = c("Source model selection", "maxMagGRRelative", "bGRRelative", "bGRRelative", "maxMagGRRelative"),
  `Applies to` = c("All sources", "`MPS-1` to MPS-6", "`MPS-1` to MPS-6", "SC_1 to SC_54", "SC_1 to SC_54"),
  `Branches (perturbation / weight)` = c(
    "`naf_faults` (- / 0.50); `naf_smooth` (- / 0.50)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)"
  )
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

### Parámetros de recurrencia de terremotos

Los parámetros de recurrencia de terremotos cuantifican la tasa esperada y la distribución de tamaños de terremotos futuros en cada fuente sísmica. La recurrencia se describe mediante una distribución magnitud-frecuencia (MFD) cuyo tipo y parámetros se especifican por fuente en el modelo. Los tres grupos de fuentes en el modelo XAF corresponden a tres tipos distintos de MFD, cada uno con un enfoque de parametrización diferente [@Poggi2020].

```{r}
#| include: true
#| label: tbl-ssm-xaf-recurrence
#| tbl-cap: "Earthquake recurrence parameters by source group."

DT <- data.table::data.table(
  `Source group` = c("Simple fault sources", "MPS/SC (truncated GR)", "BG (arbitrary MFD)"),
  `MFD type` = c("incrementalMFD", "truncGutenbergRichterMFD", "arbitraryMFD"),
  `a-value range` = c("-", "3.13-5.45", "-"),
  `b-value range` = c("-", "0.93-1.16", "-"),
  `Mmin (Mw)` = c("6.05", "4.0-4.5", "-"),
  `Mmax range (Mw)` = c("6.05-7.75", "5.25-9.00", "5.25-9.00"),
  `n` = c(115, 86, 54)
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

Para fuentes de falla, las tasas de actividad se codifican como tasas discretas de ocurrencia incremental por intervalo de magnitud de 0.1 Mw, comenzando en $M_{\min} = 6.05$ Mw; no se definen valores paramétricos $a$ o $b$. Las magnitudes máximas varían de 6.05 a 7.75 Mw en las 115 fuentes de falla [@Poggi2020].

Para las 86 fuentes multipunto con MFD Gutenberg-Richter truncadas, las tasas de terremotos se parametrizan mediante un valor $a$ (rango 3.13 a 5.45) y un valor $b$ (rango 0.93 a 1.16) sujetos a límites explícitos $M_{\min}$ y $M_{\max}$. La incertidumbre epistémica en el valor $b$ se captura mediante los conjuntos de ramas 3 y 4 del árbol lógico, aplicando perturbaciones relativas de $\pm 0.05$ a los grupos de fuentes WAF (grupo MPS) y NAF (grupo SC), respectivamente [@Poggi2020].

Para las 54 fuentes de fondo con MFD arbitrarias, las tasas de ocurrencia se especifican en puntos arbitrarios de magnitud, proporcionando una representación no paramétrica de la sismicidad que no supone una relación Gutenberg-Richter. No se definen valores $a$ o $b$ para estas fuentes [@Poggi2020].

### Tipos de distribución magnitud-frecuencia

Tres tipos de distribución magnitud-frecuencia están presentes en el modelo de fuentes sísmicas XAF, cada uno asociado con un grupo de fuentes distinto y un método de especificación de tasas diferente [@Poggi2020].

La MFD Gutenberg-Richter truncada (`multiMFD:truncGutenbergRichterMFD`) se aplica a 86 fuentes multipunto, que comprenden las fuentes de sismicidad suavizada NAF SC_1 a SC_54 y las fuentes WAF `MPS-1` a MPS-6. Las tasas de terremotos se parametrizan mediante un coeficiente de tasa de actividad (valor $a$) y un parámetro de pendiente (valor $b$) dentro de límites explícitos $M_{\min}$ y $M_{\max}$; dentro de esos límites, la relación sigue la forma estándar Gutenberg-Richter. El valor $a$ varía de 3.13 a 5.45 y el valor $b$ de 0.93 a 1.16 en las 86 fuentes [@Poggi2020].

La MFD incremental (`incrementalMFD`) se aplica a las 115 fuentes de falla simple. Las tasas de ocurrencia se especifican como valores discretos por intervalo de magnitud de 0.1 Mw, comenzando en $M_{\min} = 6.05$ Mw; los valores $a$ y $b$ no se definen para fuentes que usan este tipo de MFD. Esta formulación codifica directamente la tasa anual esperada en cada nivel de magnitud, permitiendo formas no paramétricas consistentes con tasas de actividad estimadas a partir de geometría de falla y datos de tasa de deslizamiento [@Poggi2020].

La MFD arbitraria (`multiMFD:arbitraryMFD`) se aplica a 54 fuentes multipunto de fondo (BG_1 a BG_54). Las tasas de ocurrencia se especifican en puntos de magnitud arbitrarios y no uniformemente espaciados sin un modelo paramétrico subyacente, proporcionando una representación no paramétrica de la sismicidad de fondo distribuida que no supone una relación Gutenberg-Richter [@Poggi2020].

### Relaciones de escalamiento magnitud-área

Dos relaciones de escalamiento magnitud-área se aplican en el modelo de fuentes, asignadas por tipo de fuente. Las 115 fuentes de falla simple usan la relación `Leonard2014_Interplate` [@Leonard2014] con una razón de aspecto de ruptura de 2.0. Las 140 fuentes multipunto usan la relación `WC1994` [@WellsCoppersmith1994], también con una razón de aspecto de ruptura de 2.0. Estas relaciones convierten el área de ruptura en magnitud de momento y OpenQuake las usa para determinar dimensiones de ruptura durante el cálculo de amenaza.

### Datos de tasa de deslizamiento y balance de momento

Las tasas de actividad para fuentes de falla con datos de tasa de deslizamiento disponibles pueden derivarse del balance de momento sísmico:

$$\dot{M}_0 = \mu\, A\, S$$

donde $\mu$ es el módulo de corte, $A$ es el área de falla y $S$ es la tasa de deslizamiento a largo plazo. Esta relación conecta estimaciones geodésicas o geológicas de tasa de deslizamiento con la tasa de liberación de momento sísmico usada en la construcción de MFD.

Las estimaciones de tasa de deslizamiento de la GEM North Africa Active Fault Database (NAAFD) [@Styron2018] están documentadas para 15 de las 115 fuentes de falla. Los valores documentados abarcan tasas de deslizamiento neto, tasas paralelas al rumbo, tasas verticales y tasas de acortamiento, con magnitudes típicamente en el rango 0.01 a 2.5 mm/año. Sin embargo, estos datos de tasa de deslizamiento no están codificados en los archivos XML del modelo de fuentes de OpenQuake; los registros de auditoría del modelo de fuentes indican que ninguna fuente de falla tiene datos de tasa de deslizamiento en la representación XML. Por lo tanto, las tasas MFD incrementales para fuentes de falla se especificaron independientemente de las restricciones de tasa de deslizamiento de NAAFD en la etapa de implementación de OpenQuake [@Poggi2020].

### Magnitud máxima

La magnitud máxima ($M_{\max}$) define el límite superior de la distribución magnitud-frecuencia para cada fuente y es un parámetro crítico que controla la cola de la curva de amenaza. La incertidumbre epistémica en $M_{\max}$ se captura mediante ramas de árbol lógico en los casos en que así se especifica [@Poggi2020].

Para fuentes de falla simple, los valores base de $M_{\max}$ varían de 6.05 a 7.75 Mw. Debido a que la MFD incremental codifica directamente tasas de ocurrencia por intervalo de magnitud, $M_{\max}$ queda definida implícitamente por el intervalo de mayor magnitud para cada fuente; los límites epistémicos bajo y alto son iguales al valor base, indicando que no existe incertidumbre adicional de $M_{\max}$ más allá de la selección del modelo de fuentes capturada en el conjunto de ramas 1. La falla de Arzew (FL_119, ASC) tiene asignado el valor $M_{\max}$ más grande del grupo de fallas, 7.75 Mw [@Poggi2020].

Para fuentes multipunto, los valores base de $M_{\max}$ varían de 5.25 a 9.00 Mw. La incertidumbre epistémica se aplica mediante ramas de árbol lógico `maxMagGRRelative` a dos subgrupos: las seis fuentes WAF `MPS-1` a MPS-6 (conjunto de ramas 2, ID `mmax_waf`) reciben perturbaciones de $+0.2$, $0.0$ y $-0.2$ Mw con pesos 0.25, 0.50 y 0.25; las fuentes de sismicidad suavizada NAF SC_1 a SC_54 (conjunto de ramas 5, ID `naf_m`) reciben una estructura de perturbación idéntica. Las fuentes del subgrupo SSA colapsado tienen asignados valores base, bajos y altos de $M_{\max}$ idénticos, indicando que la incertidumbre epistémica de $M_{\max}$ para esas fuentes se colapsó previamente dentro de los parámetros de fuente antes de la compilación del modelo [@Poggi2020].

### Parámetros de profundidad sismogénica

Los parámetros de profundidad sismogénica definen la extensión vertical dentro de la cual se generan rupturas de terremotos. Las profundidades sismogénicas superior e inferior delimitan la zona de ruptura; las distribuciones de profundidad hipocentral, cuando se especifican, controlan la ubicación en profundidad de las rupturas de fuentes puntuales [@Poggi2020].

```{r}
#| include: true
#| label: tbl-ssm-xaf-depth
#| tbl-cap: "Seismogenic depth parameters by source type."

DT <- data.table::data.table(
  `Source type` = c("Simple fault sources", "Multi-point sources (WAF)", "Multi-point sources (SSA)"),
  `z_upper (km)` = c("0.0", "0.0", "0.0"),
  `z_lower (km)` = c("1.7-25.0", "45.0", "40.0"),
  `Hypocentral depth distribution` = c(
    "Not specified (rupture geometry from fault model)",
    "5 km (0.267), 15 km (0.267), 25 km (0.333), 35 km (0.133)",
    "Depth-weighted discrete distribution; mean 18.0-19.5 km"
  )
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

Las fuentes de falla simple comparten una profundidad sismogénica superior de 0.0 km; su profundidad sismogénica inferior varía de 1.7 km para estructuras muy someras a 25.0 km para fallas de escala cortical. A las fuentes multipunto se les asigna una base sismogénica más profunda: las fuentes WAF colapsadas se extienden hasta 45.0 km y las fuentes SSA colapsadas hasta 40.0 km, reflejando la distribución de profundidad más amplia de la sismicidad de fondo suavizada en el dominio del modelo [@Poggi2020].

Para las fuentes multipunto WAF (`MPS-1` a MPS-6), las distribuciones de profundidad hipocentral se definen explícitamente con una profundidad hipocentral media de 18.3 km, basada en una distribución discreta de cuatro niveles: 5 km (peso 0.267), 15 km (peso 0.267), 25 km (peso 0.333) y 35 km (peso 0.133). Las fuentes SSA colapsadas tienen asignadas profundidades hipocentrales medias comparables de aproximadamente 18.0 a 19.5 km según el subgrupo de fuentes [@Poggi2020].