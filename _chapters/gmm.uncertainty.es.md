### Modelo de incertidumbre {#sec-gmm_uncertainty}

Las GMM son unos de los principales contribuyentes a la incertidumbre epistémica del PSHA, junto con componentes del modelo de fuentes, como la geometría de la falla, las tasas de sismicidad y las distribuciones magnitud-frecuencia. La incertidumbre epistémica, a diferencia de la variabilidad aleatoria, representa conocimiento científico incompleto del verdadero proceso de movimiento del suelo; en principio esta incertidumbre es reducible con datos adicionales y se representa en el PSHA mediante un conjunto discreto de modelos alternativos. Diferentes GMPE se construyen a partir de conjuntos de datos distintos, adoptan formas funcionales distintas y codifican supuestos distintos sobre escalamiento de fuente, dispersión geométrica, atenuación anelástica y amplificación de sitio. En regiones donde los datos observacionales de movimientos fuertes son escasos, las predicciones de las medianas de GMPE candidatas plausibles pueden divergir sustancialmente a través de períodos espectrales relevantes para ingeniería y rangos magnitud-distancia, produciendo una amplia dispersión de curvas de amenaza. La dispersión entre predicciones GMM a tasas anuales de excedencia bajas es frecuentemente el principal contribuyente a la banda de incertidumbre epistémica en la curva de amenaza. Debido a que esta incertidumbre no puede reducirse sin restricciones observacionales adicionales, debe representarse explícitamente en el modelo de amenaza mediante un árbol lógico que muestree el espacio de alternativas de modelo posibles.

En los árboles lógicos de movimiento del suelo usados en esta evaluación, cada árbol se define para un tipo específico de región tectónica (TRT) y comprende un único nivel de ramificación con un conjunto de ramas. Cada rama especifica una GMPE alternativa y se le asigna un peso no negativo $w_k$ tal que se cumple la condición de normalización [@eq-weight-norm]:

$$
\sum_{k=1}^{N} w_k = 1, \qquad w_k \geq 0
$${#eq-weight-norm}

donde $N$ es el número de ramas en el conjunto. Los pesos definen una distribución de probabilidad discreta sobre el espacio de GMPE candidatas. Cuando a todos los $N$ modelos se les asigna igual peso, $w_k = 1/N$ para todo $k$, el árbol lógico representa un estado de máxima incertidumbre de modelo, sin asignar preferencia previa a ninguna GMPE individual respecto de las demás.

El árbol lógico se propaga a través del cálculo del PSHA evaluando la integral de amenaza separadamente para cada rama GMPE y calculando una combinación ponderada de las curvas de amenaza resultantes. La curva media de amenaza es el promedio ponderado [@eq-mean-hazard]:

$$
\bar{\lambda}_I(i^*) = \sum_{k=1}^{N} w_k\, \lambda_I^{(k)}(i^*)
$${#eq-mean-hazard}

donde $\lambda_I^{(k)}(i^*)$ es la tasa media anual de excedencia calculada con la GMPE de la rama $k$-ésima [@OpenQuakeEngine]. La distribución completa sobre ramas permite también calcular curvas de amenaza fractiles en niveles de probabilidad prescritos, que caracterizan la dispersión de estimaciones de amenaza originada por la incertidumbre epistémica de GMM. Este marco es el mecanismo estándar dentro de OpenQuake Engine para capturar la variabilidad de modelo a modelo en la predicción de movimiento del suelo.

#### Mezcla condicional por celda {#sec-gmm_mixture}

Las comparaciones entre GMM requieren una operación distinta de la combinación de curvas de amenaza. Para una celda fija $\mathbf{x}=(M_w,R_{epi},h,T_n,V_{S30})$, cada rama $k$ aporta una distribución lognormal con mediana logarítmica $\mu_k(\mathbf{x})$ y desviación estándar logarítmica total $\sigma_k(\mathbf{x})$. La función de distribución acumulada de la mezcla ponderada es

$$
F_{S_a}(a\mid\mathbf{x}) = \sum_{k=1}^{N} w_k\,
\Phi\!\left[\frac{\ln a-\mu_k(\mathbf{x})}{\sigma_k(\mathbf{x})}\right].
$${#eq-gmm-grid-mixture}

Los cuantiles tabulados se obtienen invirtiendo numéricamente esta función, mientras que la media aritmética de la mezcla se evalúa directamente:

$$
S_a^{(p)}(\mathbf{x})=F_{S_a}^{-1}(p\mid\mathbf{x}),
\quad p\in\{0.05,0.10,0.16,0.50,0.84,0.90,0.95\},
\qquad
\operatorname{E}[S_a\mid\mathbf{x}]
=\sum_{k=1}^{N}w_k\exp\!\left[\mu_k(\mathbf{x})+\frac{\sigma_k^2(\mathbf{x})}{2}\right].
$${#eq-gmm-grid-products}

La separación entre las medianas de rama representa la dispersión epistémica entre modelos y cada $\sigma_k$ conserva la variabilidad aleatoria de su formulación. La banda p5–p95 está delimitada por los percentiles 5 y 95 de la distribución condicional mezclada y reúne ambas contribuciones. Esta mezcla por celda se emplea en las curvas de atenuación, los espectros comparativos y las evaluaciones condicionales de escenario. En el PSHA, cada rama se integra por separado antes de ponderar las curvas de amenaza; los espectros uniformes de amenaza resultantes constituyen la entrada espectral de la estimación probabilística de desplazamientos de Newmark, de modo que la influencia de los GMM se transfiere a esa etapa a través de esos espectros [@VerriKozlowski2026Newmark].

Los cuatro tipos de región tectónica cubiertos en esta evaluación son Corteza Superficial Activa (ASC), Corteza Continental Estable (SCC), Interfaz de Subducción (SIF) y Subducción Intraplaca de Profundidad Intermedia (SIS). A cada TRT se le asigna su propio árbol lógico independiente, reflejando las diferencias físicas en el mecanismo de fuente, trayectoria de propagación de ondas y respuesta de sitio entre ambientes tectónicos corticales, continentales estables y de subducción. Cada árbol lógico se identifica mediante un ID único de árbol lógico y un ID de conjunto de ramas según se especifica en los archivos de entrada NRML de OpenQuake. El contenido del árbol lógico por TRT, los identificadores GMPE, pesos y requisitos de parámetros de la biblioteca de amenaza se detallan en [@sec-gmm_appendix].

Los cuatro árboles lógicos de movimiento del suelo en esta evaluación (ASC, SCC, SIF, SIS) asignan pesos iguales a sus ramas: dentro de cada árbol, todas las ramas comparten el peso $w_k = 1/N$, salvo el ajuste de redondeo requerido cuando $N$ no divide exactamente la unidad. En ningún caso se le asigna a una rama individual mayor peso que a otra sobre la base de juicio experto o métricas de desempeño del modelo. El número de ramas de cada árbol y su peso exacto se detallan en las secciones por tipo de región tectónica.

La ponderación a pesos iguales constituye una respuesta epistémica fundamentada a las condiciones que caracterizan las regiones para las cuales se destina este marco GMM. En regiones donde el catálogo de movimientos fuertes registrados es insuficiente para discriminar estadísticamente entre GMPE alternativas, ya sea porque el conjunto de datos es demasiado pequeño para producir puntuaciones de verosimilitud robustas o porque los registros existentes se agrupan en rangos magnitud-distancia que no muestrean adecuadamente todo el espacio de parámetros relevante para ingeniería, no existe base empírica para asignar pesos sistemáticamente mayores a una familia de modelos sobre otra. Asignar pesos diferenciales en tal contexto introduciría una precisión aparente no justificada por la evidencia disponible, y se correría el riesgo de, al reducir implícitamente el peso de modelos que podrían ser igualmente o más aplicables a la región objetivo, representar erróneamente el verdadero rango de incertidumbre epistémica.

Desde una perspectiva de teoría de la información, la distribución uniforme es la asignación de probabilidad de máxima entropía sobre un conjunto discreto finito bajo un estado de conocimiento previo igual [@Springer2023LT]. Cuando ninguna evidencia distingue entre los modelos candidatos, asignar igual probabilidad a cada uno es la representación más defendible del estado epistémico. La ponderación igual de un conjunto amplio de modelos preserva así todo el rango de predicciones científicamente creíbles en la curva de amenaza ponderada y asegura que la amenaza media y las curvas fractiles resultantes reflejen honestamente el nivel de incertidumbre en la mediana del movimiento del suelo para el ambiente tectónico objetivo.

La razón para ensamblar un conjunto amplio de ramas por régimen, en lugar de reducirlo a un número menor de alternativas con pesos diferenciales, es abarcar el rango más amplio defendible de incertidumbre epistémica en la predicción de la mediana del movimiento del suelo [@NRCSSHAC2012]. Las GMPE competidoras pueden diferir sustancialmente en sus predicciones, tasas de atenuación con la distancia y desviaciones estándar a través de los rangos magnitud-distancia relevantes para un sitio dado; un conjunto de modelos grande y diverso reduce el riesgo de que la curva media de amenaza esté dominada por un conjunto estrecho de modelos que comparten supuestos o datos de entrenamiento comunes. Cada GMPE en el árbol lógico codifica supuestos distintos sobre escalamiento de fuente, dispersión geométrica, atenuación anelástica y amplificación de sitio, cubriendo colectivamente un amplio rango de incertidumbre epistémica.

Esta diversidad en genealogía de modelos se refleja concretamente en la composición de cada árbol. Para el árbol ASC, se combinan modelos calibrados con conjuntos de datos europeos (referencia ESHM20), neozelandeses, taiwaneses y globales NGA-West2, proporcionando cobertura de la diversidad del comportamiento de atenuación cortical activa en todo el mundo. Para el árbol SCC, el conjunto abarca ambientes del este de Norteamérica, cratón europeo y cratón australiano, muestreando la variabilidad regional reconocida en atenuación continental estable [@WeatherillCotton2020]. Para los árboles SIF y SIS, que se basan en modelos calibrados con bases de datos regionales de subducción de Chile, Japón, Taiwán, México, Nueva Zelanda y la compilación global NGA-SUB, el conjunto asegura que todo el rango observable de comportamiento del movimiento del suelo en zonas de subducción esté representado en la distribución de incertidumbre epistémica. Este enfoque amplio y de pesos iguales se alinea con la práctica internacional reconocida para evaluaciones de amenaza sísmica en regiones donde los registros de movimiento del suelo o acelerogramas son insuficientes para calibrar, validar o jerarquizar directamente las GMPE candidatas.
