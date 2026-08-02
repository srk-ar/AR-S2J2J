Los datos fuente son historias medidas de velocidad de partícula, acompañadas por metadatos de evento, estación, componente, muestreo y unidades. La velocidad de partícula $v_c(t)$ describe la evolución temporal del movimiento en la componente $c$; su valor pico, $\mathrm{PPV}_c=\max_t|v_c(t)|$, es una amplitud escalar. Esta distinción permite reservar PPV para el modelamiento de amplitudes y el escalamiento, mientras el procesamiento de señales opera sobre la historia completa $v_c(t)$.

Los registros disponibles se organizan mediante el índice instrumental y conservan su relación con el evento, la estación y las componentes longitudinal, transversal y vertical. En esta etapa no se asignan condiciones de distancia y MIC de diseño, no se escalan amplitudes y no se seleccionan registros mediante medidas de intensidad. El resultado es una población trazable de formas de onda medidas, independiente del modelo predictivo de PPV y PPA.

Para cada componente, la representación canónica contiene la historia de velocidad medida y las historias de aceleración y desplazamiento derivadas de ella, con un eje temporal común y unidades base consistentes. Las medidas pico se calculan directamente de estas historias:

$$
\mathrm{PGA}_c = \max_t |a_c(t)|,\qquad
\mathrm{PGV}_c = \max_t |v_c(t)|,\qquad
\mathrm{PGD}_c = \max_t |d_c(t)| .
$$ {#eq-signal-peak-measures}

Estas cantidades describen amplitudes de demanda y permiten relacionar el registro procesado con el modelo de amplitudes, la generación de escenarios y la selección posterior. En las historias de velocidad de este estudio, PGV y PPV representan la misma operación de máximo absoluto; se emplea PPV al describir la amplitud física predicha y PGV al describir la medida de intensidad calculada sobre una historia temporal.
