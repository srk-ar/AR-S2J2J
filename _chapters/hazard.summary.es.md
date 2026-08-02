```{r}
#| include: false
source(file.path(root, "scripts", "setup", "summary", "hazard_context.R"))
```

La evaluación probabilística cuantifica la amenaza sísmica mediante la tasa anual con que cada nivel de movimiento del suelo puede excederse en el sitio. Para una fuente $s$, la contribución se obtiene integrando la recurrencia, la distribución de magnitudes, las geometrías de ruptura y la distribución del movimiento del suelo [@Cornell1968; @McGuire2004]:

$$
\lambda_I(i^*)^{(s)}=\nu_0^{(s)}\int_{M_{\min}}^{M_{\max}^{(s)}}\int_D P\!\left[I>i^*\mid m,\mathbf r\right]f_{M,s}(m)f_{\mathbf R\mid M,s}(\mathbf r\mid m)\,\mathrm d\mathbf r\,\mathrm dm.
$$

En esta expresión, $\lambda_I(i^*)^{(s)}$ es la tasa anual de excedencia aportada por la fuente, $\nu_0^{(s)}$ su tasa de actividad por encima de $M_{\min}$, $M_{\max}^{(s)}$ su magnitud máxima, $D$ el dominio de ubicaciones y geometrías admisibles, $m$ la magnitud de momento, $\mathbf r$ el vector de distancias fuente--sitio, $I$ la medida de intensidad, $i^*$ el nivel evaluado y $f_{M,s}$ y $f_{\mathbf R\mid M,s}$ las densidades de magnitud y distancia. La tasa total es la suma de las contribuciones de fuentes independientes modeladas mediante procesos de Poisson.

```{r}
#| echo: false
#| results: asis
BRANCH <- if (is.finite(Hazard.config$ssmBranches)) {
  sprintf(
    "%s %s",
    Hazard.config$ssmBranches,
    if (Hazard.config$ssmBranches == 1L) "rama de modelo fuente" else "ramas de modelo fuente"
  )
} else {
  "la estructura de ramas disponible"
}
if (!is.na(Hazard.config$ssmLabel) && nzchar(Hazard.config$ssmLabel)) {
  LEAD <- if (!is.na(Hazard.config$siteLabel)) {
    sprintf("Para %s, se", Hazard.config$siteLabel)
  } else {
    "Se"
  }
  cat(sprintf(
    paste0(
      "%s adoptó el modelo regional de fuentes **%s**, con %s. ",
      "El cálculo considera magnitudes desde $M_w$ %s, ",
      "fuentes hasta %s km y truncamiento residual en $\\pm%s\\sigma$.\n"
    ),
    LEAD,
    Hazard.config$ssmLabel,
    BRANCH,
    .fmt(Hazard.config$minimumMagnitude, 1),
    .fmti(Hazard.config$maximumDistance),
    .fmt(Hazard.config$truncationLevel, 1)
  ))
  rm(LEAD)
}
rm(BRANCH)
```

La configuración clásica de esta evaluación solicita la curva media en roca de referencia, $V_{S30}=760$ m/s [@OpenQuakeEngine]. Los fractiles disponibles para $V_{S30}=800$ m/s corresponden a esa condición de sitio y no se interpretan como fractiles de la amenaza en roca.

Bajo la hipótesis poissoniana, la tasa anual y las probabilidades exactas de excedencia durante uno y $T$ años se relacionan mediante

$$
P_{1\mathrm{yr}}[I>i^*]=1-e^{-\lambda_I(i^*)},\qquad P_T[I>i^*]=1-e^{-\lambda_I(i^*)T},\qquad T_R=\frac{1}{\lambda_I(i^*)}.
$$

El período de retorno $T_R$ es el intervalo medio asociado a la tasa de excedencia. Las curvas AEP presentan $\lambda_I$ en $1/\text{año}$; las curvas PoE presentan la probabilidad exacta para el intervalo de exposición del cálculo. Ambos se reportan totalizados y por fuente, junto con PGA, aceleraciones espectrales, la UHS media en roca y las condiciones de sitio evaluadas.

La desagregación recupera las combinaciones de magnitud, distancia y residuo que aportan a la excedencia de cada nivel de amenaza [@Bazzurro1999; @Kramer1997]. La desagregación reportada marginaliza el residuo y presenta matrices magnitud--distancia con intervalos de 0.1 $M_w$ y 10 km para PGA, $S_a(0.10\,\mathrm{s})$, $S_a(0.20\,\mathrm{s})$, $S_a(0.50\,\mathrm{s})$ y $S_a(1.00\,\mathrm{s})$. El máximo de cada matriz identifica el escenario modal del período de retorno y de la medida de intensidad correspondientes.
