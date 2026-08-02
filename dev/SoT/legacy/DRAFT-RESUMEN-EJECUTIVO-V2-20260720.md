# DRAFT — Resumen ejecutivo v2 (reinicio desde cero)

Fecha: 2026-07-20. Frente E135-A7e. Estado: borrador a lectura del
propietario; ningún archivo público editado.

## Por qué v2 es distinto

Las tres rondas anteriores fracasaron por voz, no por contenido: describían
sistemas («la base conserva…», «el modelo estima…») en lugar de contar
acciones completadas y hallazgos. v2 se escribe como un ingeniero le informa
a otro: qué se hizo, qué dio, qué significa, qué falta — en pasado, con los
números como ancla, sin siglas de proceso (OOF, VMD, H1/H2 quedan en los
capítulos). La motivación viene de las secciones Antecedentes y Objetivos que
preceden al cuerpo (estructura A7c del memo, que se conserva).

Números del borrador: verificados contra `data/summary/metrics.csv`,
`data/summary/residuals_oof.csv`, `data/gmsp/F125.Qo.Do.vmd/{META,IMW}.csv` y
`data/audit/summary.csv`. En la implementación se hidratan; el borrador los
muestra redondeados para lectura.

## Cuerpo propuesto («## Resumen», tras Antecedentes y Objetivos)

Se procesaron y verificaron 86 registros triaxiales de vibración medidos
durante las voladuras del sitio, equivalentes a 258 historias de componente
con aceleración, velocidad y desplazamiento coherentes. Para 68 registros el
contratista informó la distancia y la carga de la voladura; ese subconjunto
cubre distancias de 232 a 1 220 m y cargas de 119 a 299 kg, y delimita las
condiciones de operación observadas.

Con esas observaciones —complementadas fuera del rango monitoreado por la
base de amplitudes compilada por el autor en distintos proyectos (fuente
S11D)— se ajustó un modelo de aprendizaje estadístico que predice la
velocidad y la aceleración pico de partícula, por componente y resultante,
para cualquier combinación de distancia y carga dentro del dominio observado.
El desempeño se midió únicamente sobre observaciones excluidas de cada
ajuste: R² de 0.84–0.90 para PPV y de 0.68–0.74 para PPA sobre 106 pares por
respuesta, con errores en unidades físicas de 15–23 mm/s y 0.5–0.8 g por
componente. El acoplamiento entre respuestas mejoró todas las predicciones
respecto del modelo sin acoplar, y los residuos de esa verificación
definieron los niveles de predicción p50, p90 y p95.

Con los objetivos p90 se calibró la suite de demanda: 36 escenarios que
cubren la malla de 150 a 400 m y de 150 a 400 kg, cada uno con las 86
historias medidas escaladas a los objetivos PPV de su condición y rotadas a
las direcciones de análisis. La suite reúne 3 096 realizaciones triaxiales de
aceleración, velocidad y desplazamiento, con sus espectros de respuesta y
medidas de intensidad, y queda lista para el modelo dinámico de deformaciones
y el análisis de licuación.

La evaluación de confiabilidad está formulada: la probabilidad de falla de
cada criterio de desempeño, condicionada al escenario, se estimará comparando
las demandas calculadas con las capacidades admisibles. Su cuantificación
requiere las respuestas del modelo de deformaciones y las capacidades y
criterios del modelo geotécnico; hasta contar con esos insumos, el estudio no
reporta probabilidades de falla ni conclusiones de aceptabilidad.

## Notas de implementación (tras el veredicto)

- Los cuatro párrafos reemplazan los movimientos de `_summary/*.summary.*` y
  el lead; los bloques hidratados de números por frente se integran o se
  retiran según cómo queden las repeticiones (los valores clave ya viven en
  el cuerpo).
- PPV/PPA quedan ligados en Antecedentes (texto master); el cuerpo usa las
  siglas sin re-expandir.
- EN se espeja tras la aprobación ES, con el ledger.
- Las tablas del memo (frente Stage II) siguen a los párrafos 2 y 3 con sus
  lead-ins.
