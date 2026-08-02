### Criterio probabilístico, inversión y normalización

El criterio probabilístico se define como

$$
k_{\max}(p_e\mid D_a)
=\inf\left\{k_y:\Pr[D_n(k_y)>D_a]\leq p_e\right\}.
$${#eq-kmax-criterion}

donde $p_e$ es la probabilidad objetivo de que $D_n$ exceda $D_a$. Para cada modelo y realización, la relación calculada se proyecta sobre una curva $D_n(k_y)$ no creciente y se invierte en el plano $(\ln D_n,\ln k_y)$; cuando $D_a$ se ubica fuera del soporte calculado, la relación se prolonga en ese plano a partir de los dos puntos del extremo correspondiente.

La inversión se efectúa primero por modelo dentro de cada realización. Los valores de $k_y$ resultantes se combinan después con los pesos de la familia y se resumen entre realizaciones mediante la media aritmética y los fractiles empíricos $q=0.05$, 0.10, 0.16, 0.84, 0.90 y 0.95 [@VerriKozlowski2026Newmark]. Debido a la relación decreciente entre $D_n$ y $k_y$, el fractil asociado al objetivo de excedencia cumple

$$
q=1-p_e.
$${#eq-kmax-fractile}

Así, $q=0.84$ corresponde a $p_e=0.16$. La media aritmética resume el centro de la distribución simulada y no representa una probabilidad objetivo; los fractiles $q$ son los estadísticos asociados al criterio expresado mediante $p_e$.

La evaluación utiliza `r .fmti(NS)` realizaciones para los períodos de retorno `r paste(.fmti(TR.gmdp), collapse = ", ")` años y los desplazamientos admisibles $D_a=$ `r paste(format(Da.gmdp, trim = TRUE, scientific = FALSE), collapse = ", ")` cm. Los valores de $D_a$ que exceden el soporte calculado de una realización se obtienen mediante la prolongación logarítmica definida anteriormente.

El coeficiente normalizado se calcula con la PGA media de la UHS en roca de referencia, evaluada en el menor período disponible para el modelo, sitio y período de retorno correspondientes, con $V_{S30}=V_{\mathrm{ref}}=760$ m/s:

$$
k_h=100\frac{k_{\max}}{\mathrm{PGA}_{\mathrm{rock}}}.
$${#eq-kh-normalization}

$k_{\max}$ se expresa en unidades de $g$ y $k_h$ como porcentaje de la PGA en roca. Estas magnitudes trasladan el criterio de desplazamiento a la acción sísmica empleada en la verificación pseudoestática.
