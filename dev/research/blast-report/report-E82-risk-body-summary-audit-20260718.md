# report-E82-risk-body-summary-audit-20260718

## Section

Blast report / E82 — auditoría final del cuerpo y resumen ejecutivo de `risk`.

## Report Purpose

Verificar la metodología E81 criterio por criterio contra el SoT de Blast y el
precedente Brasil, corregir únicamente las discrepancias técnicas y reemplazar
el antiguo resumen de interfaz por una síntesis ejecutiva autónoma. Los
resultados permanecen como nota de espera del modelo dinámico de deformaciones.

## Sources Read

- `dev/SoT/ACTIVE.md` y `dev/plan/blast-report/active.md`, E71, E74, E80-D4 y
  E81.
- `dev/research/blast-report/report-E80-D4-remaining-bodies-and-risk-method-20260718.md`.
- `dev/research/blast-report/report-E81-risk-proposed-reliability-method-20260718.md`.
- `dev/SoT/DRAFT-intro-objetivos-20260718.md` y
  `dev/SoT/chapters-mapb-20260718/risk.es.md`.
- `_chapters/risk.es.md`, `_chapters/risk.summary.es.md`,
  `_summary/risk.results.es.qmd` y `_index/risk.ES.qmd`.
- Precedente Brasil `AR-M2P2B.R/qmd/report/_model.qmd`, `_demand.qmd` y
  `_appendix_pf.qmd`, mediante lectura completa de los pasajes
  demanda--capacidad y confiabilidad.
- `garage/style/summary.md` y `garage/style/technical-writing.md`.

## Body Audit By Criterion

1. **Escenario y demanda de entrada — corrección necesaria.** El escenario
   $s=(D,Q,p)$ y la variabilidad temporal/espectral están correctamente
   definidos. La frase «PPV y PPA establecen la escala» contradice los capítulos
   de modelo y escenarios: únicamente los objetivos PPV L/T/V fijan los
   factores de escala; PPA permanece como respuesta complementaria del modelo
   de amplitudes.
2. **Modelo dinámico — conservar.** Cada historia triaxial produce
   $\mathbf R_{s,r}=\mathcal M[\mathbf a_{s,r};\boldsymbol\theta]$. Geometría,
   estado inicial, condiciones de borde/drenaje, materiales y parámetros
   constitutivos pertenecen a $\boldsymbol\theta$. La mención de PLAXIS, FLAC y
   PM4Sand describe el programa considerado y no acredita una plataforma,
   versión, calibración o ejecución específica.
3. **Estado límite — conservar con cierre afirmativo.** Cada criterio
   $\ell$ dispone de su propia demanda $\mathcal D_{\ell,s,r}$, capacidad
   $\mathcal C_\ell$, margen $g_{\ell,s,r}$ e indicador
   $I_{\ell,s,r}$. Los indicadores permanecen separados. La prosa debe afirmar
   que cualquier clasificación conjunta procede exclusivamente de una regla
   aprobada por el modelo geotécnico de capacidad.
4. **Probabilidad condicional — conservar.** La estimación
   $\widehat p_{f,\ell}(s)=\sum_r w_{s,r}I_{\ell,s,r}$ es específica del
   criterio. La equiprobabilidad sólo corresponde a una población
   representativa y equiprobable; una selección determinista requiere pesos
   declarados.
5. **Admisibilidad — conservar.** El criterio se expresa por separado como
   $p_{f,\ell}(s)\le p_{f,\ell}^{\mathrm{adm}}$ o, equivalentemente,
   $\beta_\ell(s)\ge\beta_\ell^{\mathrm{adm}}$. El cuerpo no asigna umbrales ni
   combina criterios.
6. **Resultados — nota de espera.** El modelo dinámico está en ejecución. La
   nota debe identificar como pendientes las respuestas, demandas/capacidades,
   indicadores, población/pesos y estimaciones por criterio y escenario, sin
   prometer cifras ni presentar listas por negación.

## Crosswalk Of Existing Executive Summary

1. **Párrafo 1 — reemplazar.** Describe una interfaz posterior, mientras E81 ya
   formula una metodología de confiabilidad condicionada. Se conserva la
   trazabilidad $D$--$Q$--$p$ y la distinción entre nivel predictivo de amplitud
   y probabilidad de falla.
2. **Párrafo 2 — condensar.** La plataforma y la configuración completa de
   $\boldsymbol\theta$ pertenecen al cuerpo. El resumen sólo requiere el modelo
   dinámico bidimensional en tensiones efectivas y el vector de respuestas por
   realización.
3. **Párrafo 3 — reemplazar por formulación portante.** Las respuestas físicas
   se convierten en demanda y capacidad por criterio; el indicador binario debe
   conservar el subíndice $\ell$ y no admitir una unión implícita.
4. **Párrafo 4 — reemplazar.** La probabilidad condicional ponderada y el
   criterio equivalente en $\beta$ forman el núcleo ejecutivo. Riesgo anual,
   frecuencias y consecuencias quedan fuera porque E81 no los calcula.
5. **Estado de resultados — conservar como nota separada y compacta.** El
   resumen identifica la ausencia de resultados cuantitativos mediante el
   estado del modelo dinámico; el detalle de productos pendientes permanece en
   `Resultados`.

## Exact Claims Allowed

- Cada escenario $s=(D,Q,p)$ reúne historias triaxiales con objetivos PPV L/T/V
  comunes y variabilidad temporal y espectral entre realizaciones.
- $p$ identifica el nivel predictivo de amplitud del escenario.
- Cada historia se aplica al mismo modelo dinámico bidimensional en deformación
  plana y tensiones efectivas y produce un vector $\mathbf R_{s,r}$.
- Cada criterio $\ell$ define demanda, capacidad e indicador de excedencia
  propios.
- Los criterios se evalúan separadamente hasta que el modelo geotécnico de
  capacidad establezca una regla conjunta.
- La probabilidad condicional se estima por criterio y escenario mediante una
  suma ponderada de indicadores.
- $\beta_\ell(s)=-\Phi^{-1}[p_{f,\ell}(s)]$ expresa el índice equivalente de
  confiabilidad por criterio.
- El modelo dinámico de deformaciones y sus resultados cuantitativos están
  pendientes.

## Claims Not Allowed

- PPA como variable que fija el factor de escala de las historias.
- Unión, mínimo o máximo automático entre indicadores de criterios distintos.
- PPV crítico, mecanismo de fractura, lognormalidad o independencia
  demanda--capacidad trasladados desde Brasil.
- Equiprobabilidad inferida de una selección determinista.
- Plataforma, versión, calibración, criterios, capacidades, pesos, resultados o
  umbrales presentados como ejecutados o aprobados sin evidencia.
- Riesgo anual, frecuencias de escenario, consecuencias o clasificación global
  de escenarios.

## Equations Allowed

- En el cuerpo: operador del modelo dinámico; demanda, capacidad e indicador
  por criterio; probabilidad condicional y estimador ponderado; relación entre
  $p_f$, $\beta$ y admisibilidad.
- En el resumen: indicador por criterio en notación inline y una única
  expresión conjunta para el estimador ponderado y el índice de confiabilidad.

## Equations Excluded

- Unión automática $\min_\ell g_\ell$ o un indicador sin subíndice de criterio.
- Cierre lognormal de Brasil y su ecuación de PPV crítico.
- Derivación de la normal estándar, funciones de agregación $h_\ell$ y detalles
  de $\boldsymbol\theta$ en el resumen.

## Vocabulary Allowed

- escenario; realización triaxial; nivel predictivo de amplitud; modelo
  dinámico de deformaciones; deformación plana; tensiones efectivas; respuesta;
  criterio de desempeño; demanda geotécnica; capacidad admisible; estado
  límite; indicador por criterio; probabilidad condicional de falla; peso;
  población; índice equivalente de confiabilidad; admisibilidad.

## Vocabulary Rejected

- PPV crítico; falla global; unión de modos; cualquiera de los modos; muestra
  equiprobable por selección; riesgo anual; resultado aceptado; modelo
  ejecutado; se demostrará; se validará; véase Metodología.

## Candidate Public Paragraph Or Section

### Correcciones del cuerpo

El análisis de riesgos relaciona la demanda sísmica inducida por las voladuras con la capacidad de la sección crítica del depósito. Cada escenario $s=(D,Q,p)$ reúne realizaciones triaxiales con los objetivos de amplitud definidos por la distancia fuente–receptor $D$, la carga instantánea máxima $Q$ y el nivel predictivo $p$. Las realizaciones de un mismo escenario comparten esos objetivos y conservan la variabilidad de forma temporal y contenido espectral de los registros. Las predicciones PPV longitudinal, transversal y vertical establecen la escala de la excitación; PPA permanece como respuesta complementaria del modelo de amplitudes. La distribución de respuestas del modelo dinámico establece el desempeño geotécnico condicionado al escenario.

Así, $I_{\ell,s,r}=1$ identifica la excedencia del estado límite $\ell$ para una realización específica. Cada indicador queda asociado exclusivamente a su criterio de desempeño. Los criterios se evalúan por separado; cualquier clasificación conjunta se incorpora mediante una regla establecida por el modelo geotécnico de capacidad.

### Resumen ejecutivo

El análisis cuantifica la confiabilidad de la sección crítica del depósito condicionada a cada escenario de voladura $s=(D,Q,p)$. Las realizaciones de un escenario comparten los objetivos PPV longitudinal, transversal y vertical definidos por la distancia fuente–receptor $D$, la carga instantánea máxima $Q$ y el nivel predictivo de amplitud $p$, y conservan la variabilidad temporal y espectral de los registros. El símbolo $p$ identifica el nivel de amplitud; la probabilidad de falla se obtiene de las respuestas dinámicas de las realizaciones.

Cada historia triaxial se aplica al mismo modelo dinámico bidimensional de la sección, formulado en deformación plana y tensiones efectivas. Para cada realización $r$, el modelo produce el vector de respuestas $\mathbf R_{s,r}$. Cada criterio de desempeño $\ell$ transforma esas respuestas en una demanda geotécnica $\mathcal D_{\ell,s,r}$ y la compara con su capacidad admisible $\mathcal C_\ell$ mediante $I_{\ell,s,r}=\mathbf 1(\mathcal D_{\ell,s,r}\ge\mathcal C_\ell)$. Los indicadores se mantienen separados por criterio; cualquier clasificación conjunta corresponde al modelo geotécnico de capacidad.

La probabilidad condicional de falla se estima por criterio y escenario a partir de los indicadores ponderados, y su índice equivalente de confiabilidad se expresa como [@AngTang1984; @BenjaminCornell1970]

$$
\widehat p_{f,\ell}(s)=\sum_{r=1}^{N_s}w_{s,r}I_{\ell,s,r},
\qquad
\sum_{r=1}^{N_s}w_{s,r}=1,
\qquad
\beta_\ell(s)=-\Phi^{-1}\!\left[p_{f,\ell}(s)\right].
$$

Aquí $N_s$ es el número de realizaciones analizadas, $w_{s,r}$ representa el peso de la realización $r$ en la población del escenario y $\Phi^{-1}$ es la función cuantil normal estándar. La admisibilidad se evalúa para cada criterio mediante $p_{f,\ell}(s)\le p_{f,\ell}^{\mathrm{adm}}$, de forma equivalente a $\beta_\ell(s)\ge\beta_\ell^{\mathrm{adm}}$. Una población representativa y equiprobable admite $w_{s,r}=1/N_s$; una selección determinista requiere la ponderación definida para esa población.

El modelo dinámico de deformaciones se encuentra en ejecución. Los resultados pendientes comprenden, para cada criterio y escenario, las respuestas calculadas, las demandas y capacidades aprobadas, la clasificación de cada realización, la población y sus pesos, y las estimaciones de $\widehat p_{f,\ell}$ y $\beta_\ell$.

### Nota de resultados

El modelo dinámico de deformaciones se encuentra en ejecución. Los resultados cuantitativos pendientes comprenden, para cada criterio $\ell$ y escenario $s$, las respuestas $\mathbf R_{s,r}$, las demandas $\mathcal D_{\ell,s,r}$, las capacidades $\mathcal C_\ell$, los indicadores por realización, la población y sus pesos, y las estimaciones de $\widehat p_{f,\ell}(s)$ y $\beta_\ell(s)$.

## Candidate Translation Terminology

None. El español permanece como texto master.

## Open Gaps

1. Respuestas del modelo dinámico de deformaciones.
2. Criterios de desempeño, capacidades admisibles y cualquier regla conjunta
   aprobada por el modelo geotécnico.
3. Población de realizaciones y pesos por escenario.
4. Resultados por criterio y escenario, incluido $\widehat p_{f,\ell}$ y
   $\beta_\ell$.
5. Render registrado y lectura integral del capítulo ensamblado después de
   incorporar resultados reales.

## Validation

- Cada indicador, probabilidad y criterio de admisibilidad conserva el
  subíndice $\ell$.
- Cero unión automática de criterios.
- Cero PPV crítico, fractura, lognormalidad, independencia demanda--capacidad o
  cifras transferidas desde Brasil.
- La ecuación ejecutiva define todos sus símbolos y no reproduce la derivación
  del cuerpo.
- Cero datos, JSON, SSEL o render.
