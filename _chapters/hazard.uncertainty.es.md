### Modelo de incertidumbre {#sec-source_uncertainty}

La incertidumbre epistémica se representa mediante los árboles lógicos del modelo regional de fuentes y de los GMM. Cada rama especifica una caracterización alternativa con un peso no negativo, y los pesos de cada conjunto suman uno. OpenQuake evalúa la integral de amenaza para las realizaciones del árbol y forma los estadísticos solicitados mediante ponderación de las curvas resultantes [@OpenQuakeManual2024].

Los parámetros de recurrencia, geometría y magnitud máxima de cada fuente intervienen en la integral a través de las densidades de magnitud y distancia. Los árboles GMM representan por separado los regímenes tectónicos activos y ponderan sus modelos de predicción; la variabilidad aleatoria registro a registro permanece en la desviación estándar de cada GMM.

```{r}
#| echo: false
#| results: asis
SOURCE.BRANCH <- if (is.finite(Hazard.config$ssmBranches)) {
  sprintf(
    "%s %s de modelo fuente",
    Hazard.config$ssmBranches,
    if (Hazard.config$ssmBranches == 1L) "rama" else "ramas"
  )
} else {
  "la ramificación definida en el archivo de entrada"
}
GMM.COUNTS <- GMM.active[, sprintf(
  "**%s** (%s ramas)",
  TRT,
  lengths(models)
)]
OUTPUT.STAT <- if (length(Hazard.config$rockQuantiles)) {
  sprintf(
    "la media y los cuantiles %s",
    paste(Hazard.config$rockQuantiles, collapse = ", ")
  )
} else if (isTRUE(Hazard.config$rockMean)) {
  "la curva media"
} else {
  "los estadísticos solicitados por la configuración"
}
MODEL.LABEL <- if (!is.na(Hazard.config$ssmLabel) && nzchar(Hazard.config$ssmLabel)) {
  sprintf("el modelo **%s** aporta %s", Hazard.config$ssmLabel, SOURCE.BRANCH)
} else {
  "el modelo regional de fuentes aporta la ramificación definida en sus entradas"
}
cat(sprintf(
  paste0(
    "En esta evaluación, %s; los árboles GMM ",
    "comprenden %s. La salida probabilística en roca de referencia ",
    "($V_{S30}=760$ m/s) reporta %s. Los fractiles disponibles para ",
    "$V_{S30}=800$ m/s pertenecen a esa condición de sitio y se ",
    "presentan separadamente de la amenaza media en roca.\n"
  ),
  MODEL.LABEL,
  paste(GMM.COUNTS, collapse = ", "),
  OUTPUT.STAT
))
rm(SOURCE.BRANCH, GMM.COUNTS, OUTPUT.STAT, MODEL.LABEL)
```

El inventario comprende las familias corticales activas de Kotha, Campbell--Bozorgnia, Boore, Chao, Phung, Atkinson, Stafford y Aristeidou [@Kotha2020; @CampbellBozorgnia2014; @BozorgniaCampbell2016; @Stewart2016; @Boore2021Greece; @Chao2020; @Phung2020; @Atkinson2022NZ; @Bradley2022NZ; @Aristeidou2024]; las familias continentales estables NGA-East, ESHM20, Pezeshk, Atkinson--Boore y Somerville [@Goulet2017; @WeatherillCotton2020; @Pezeshk2011; @AtkinsonBoore2006; @AtkinsonBoore2011; @Somerville2009]; y las familias de subducción de Abrahamson, Abrahamson--Gülerce, Kuehn, Parker, Montalva, Si, Atkinson--Macías y Jaimes [@AbrahamsonEtAl2018; @AbrahamsonGulerce2022; @Kuehn2020; @Parker2022; @Montalva2017; @Si2020; @AtkinsonMacias2009; @Jaimes2020].
