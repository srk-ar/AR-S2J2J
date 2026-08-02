La metodología propuesta para el análisis de riesgos relaciona la demanda sísmica inducida por las voladuras con la capacidad de la sección crítica del depósito. Cada escenario $s=(D,Q,p)$ reúne realizaciones triaxiales con los objetivos de amplitud definidos por la distancia fuente–receptor $D$, la carga instantánea máxima $Q$ y el nivel predictivo $p$. Las realizaciones de un mismo escenario comparten esos objetivos y conservan la variabilidad de forma temporal y contenido espectral de los registros. Las predicciones PPV longitudinal, transversal y vertical establecen la escala de la excitación; PPA permanece como respuesta complementaria del modelo de amplitudes. La distribución de respuestas del modelo dinámico establece el desempeño geotécnico condicionado al escenario.

En esta formulación, cada historia $\mathbf a_{s,r}(t)$ se aplica al mismo modelo dinámico bidimensional de la sección evaluada, formulado en deformación plana y tensiones efectivas. Para la realización $r$, la operación se representa como

$$
\mathbf R_{s,r}=\mathcal M\!\left[\mathbf a_{s,r}(t);\boldsymbol\theta\right],
$$ {#eq-risk-response}

donde $\boldsymbol\theta$ reúne la geometría, el estado inicial, las condiciones de borde y drenaje, la asignación de materiales y los parámetros constitutivos, y $\mathbf R_{s,r}$ contiene las respuestas calculadas. La configuración numérica, las leyes constitutivas y los parámetros de cada material quedan definidos por el modelo dinámico de la sección. Las respuestas de interés comprenden presión de poros, deformaciones, desplazamientos y las magnitudes de estabilidad o servicio adoptadas para la sección.

Cada criterio de desempeño $\ell$ define una medida de demanda geotécnica $\mathcal D_{\ell,s,r}=h_\ell(\mathbf R_{s,r})$ y una capacidad admisible $\mathcal C_\ell$. La función $h_\ell$ fija la variable física, el dominio espacial y temporal y la forma de agregación de la respuesta, con la convención de que una demanda mayor representa una condición más desfavorable. El margen y el indicador binario de falla se expresan como

$$
g_{\ell,s,r}=\mathcal C_\ell-\mathcal D_{\ell,s,r},
\qquad
I_{\ell,s,r}=\mathbf 1\!\left(g_{\ell,s,r}\le 0\right).
$$ {#eq-risk-limit-state}

Así, $I_{\ell,s,r}=1$ identifica la excedencia del estado límite $\ell$ para una realización específica. Cada indicador queda asociado exclusivamente a su criterio de desempeño. Los criterios se evalúan por separado; cualquier clasificación conjunta se incorpora mediante una regla establecida por el modelo geotécnico de capacidad.

Para el criterio $\ell$, la probabilidad condicional de falla del escenario y su estimador sobre las $N_s$ realizaciones analizadas son

$$
p_{f,\ell}(s)
=P\!\left[\mathcal D_{\ell,s}\ge\mathcal C_\ell\mid s\right],
\qquad
\widehat p_{f,\ell}(s)
=\sum_{r=1}^{N_s}w_{s,r}I_{\ell,s,r},
\qquad
\sum_{r=1}^{N_s}w_{s,r}=1.
$$ {#eq-risk-pf}

Los pesos $w_{s,r}$ representan la población y el diseño de selección de las historias. Para una población representativa y equiprobable, $w_{s,r}=1/N_s$ y el estimador coincide con la fracción de realizaciones fallidas. Una selección determinista por intensidad conserva su condición de conjunto seleccionado y requiere una ponderación explícita para sustentar la interpretación probabilística.

El índice de confiabilidad equivalente se define a partir de la probabilidad de falla [@AngTang1984; @BenjaminCornell1970]:

$$
\beta_{\ell}(s)=-\Phi^{-1}\!\left[p_{f,\ell}(s)\right],
\qquad
p_{f,\ell}(s)\le p_{f,\ell}^{\mathrm{adm}}
\;\Longleftrightarrow\;
\beta_{\ell}(s)\ge
\beta_{\ell}^{\mathrm{adm}}
=-\Phi^{-1}\!\left(p_{f,\ell}^{\mathrm{adm}}\right),
$$ {#eq-risk-beta}

donde $p_{f,\ell}^{\mathrm{adm}}$ es la probabilidad admisible para el criterio. Para la población finita representada por las realizaciones, el índice estimado se obtiene como $\widehat\beta_\ell(s)=-\Phi^{-1}[\widehat p_{f,\ell}(s)]$, y la admisibilidad se evalúa de forma equivalente mediante $\widehat p_{f,\ell}(s)\le p_{f,\ell}^{\mathrm{adm}}$ o $\widehat\beta_\ell(s)\ge\beta_\ell^{\mathrm{adm}}$. Esta formulación conserva la separación entre demanda y capacidad del marco de confiabilidad y la adapta a respuestas dinámicas por realización. Los niveles admisibles y la clasificación conjunta de los criterios serán establecidos por el modelo geotécnico de capacidad en etapas futuras del estudio.
