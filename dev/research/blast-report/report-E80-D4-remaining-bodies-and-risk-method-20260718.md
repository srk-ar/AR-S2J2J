# report-E80-D4-remaining-bodies-and-risk-method-20260718

## Section

Blast report / E80-D4 — cierre body-first de `records`, `scenarios` y
formulación metodológica de `risk`.

## Report Purpose

Determinar qué puede corregirse sin resultados nuevos y formular el capítulo de
riesgo desde el marco demanda--capacidad aprendido del proyecto Brasil, adaptado
al mecanismo real de este proyecto: realizaciones temporales por escenario,
modelo dinámico de deformaciones y clasificación falla/no falla. El texto se
dirige a especialistas y evita el registro de manual, las alternativas de
software como metodología y las configuraciones todavía no ejecutadas.

## Sources Read

- `dev/plan/blast-report/active.md`, E68, E70, E71, E74 y E80.
- `dev/research/blast-report/report-E80-body-first-summary-crosswalk-20260718.md`.
- `dev/research/blast-report/report-E80-D1-records-vmd-official-ruling-20260718.md`.
- `_chapters/records.es.md`, `_chapters/scenarios.es.md` y
  `_chapters/risk.es.md`, con sus resúmenes en sólo lectura.
- `psha/dev/plan/blast-partiv/active.md`, en particular «El hilo del
  documento», los vetos del mapa B' y el ruling de capacidad en ejecución.
- `psha/dev/SoT/HANDOFF-BLAST-PARTIV-TEXTS-SUCCESSOR-20260718.md`.
- Brasil `AR-M2P2B.R/qmd/report/_model.qmd` y `_appendix_pf.qmd`, únicamente
  para la arquitectura demanda--capacidad, $p_f=P[D>C]$, criterio admisible y
  relación $p_f=\Phi(-\beta)$. No se trasladaron su mecanismo de fractura, su
  umbral PPV, sus distribuciones lognormales ni sus cifras.

No se inspeccionaron JSON ni resultados VMD, no se ejecutaron datos, escenarios
o renders y no se accedió a SSEL.

## Paragraph Audit

### Records

- Líneas 1--31: **conservar**. La apertura, la base instrumental, la convención
  de unidades, la regularización temporal y los operadores espectrales
  describen operaciones del estudio.
- Líneas 33--49: **reemplazo obligatorio**. «Diagnóstico modal», las métricas
  modales y «sin retiro selectivo» contradicen el ruling oficial. La afirmación
  autorizada ahora es VMD con retiro de IMF1 como modo de baja frecuencia. El
  número de modos, los parámetros, el tratamiento del residuo y el estado de la
  corrida siguen bloqueados hasta revisar el contrato y los JSON.
- Líneas 51--68: **conservar con corrección terminológica**. Después de VMD,
  «historia medida» debe reemplazarse por «historia procesada» en la explicación
  de la escala.
- Líneas 70--128: **conservar en el cuerpo**. PGA/PGV/PGD, AI, CAV/CAV5,
  duraciones y PSA son definiciones de la metodología completa. No deben
  repetirse automáticamente en el resumen ejecutivo.

Veredicto: el cuerpo está cerrado salvo la reconstrucción VMD. Puede retirarse
ahora el relato falso; los parámetros y resultados VMD continúan gateados.

### Scenarios

- Líneas 1--61: **cerradas**. Condición $D$--$Q$--$p$, interpolación interna,
  escalamiento PPV/PGV y rotación H1/H2/UP forman un método completo. Las
  ecuaciones de escala y rotación son portantes.
- Líneas 63--95: **método cerrado, valor de tolerancia abierto**. Los errores
  vertical y horizontal y la positividad de PGA describen el control correcto.
  El valor $\tau=10^{-3}$ sólo puede quedar como configuración aplicada cuando
  la familia aceptada lo confirme.
- Líneas 97--103: **no cerradas como selección aplicada**. El texto enumera un
  menú ordenado/aleatorio. El informe debe declarar la selección adoptada. Sin
  esa configuración, el capítulo puede cerrar generación, transformación,
  verificación y trazabilidad, pero no resultados de selección.

Veredicto: reemplazar el menú por un párrafo factual de trazabilidad. La
selección aplicada vuelve como un único párrafo parametrizado cuando exista la
familia aceptada.

### Risk

- El cuerpo vigente es una delimitación honesta, pero no desarrolla la
  metodología que el programa ya definió.
- El marco Brasil aporta la separación demanda--capacidad, la probabilidad de
  excedencia y el criterio de admisibilidad. En este proyecto la capacidad no
  es un PPV crítico ni una variable lognormal adoptada: surge de la respuesta
  del modelo dinámico y de los criterios de desempeño.
- Para cada escenario $s=(D,Q,p)$, las realizaciones comparten los objetivos de
  amplitud y conservan la variabilidad temporal y espectral de los registros.
  Cada historia produce un vector de respuestas del modelo receptor y una
  clasificación binaria mediante los estados límite aprobados.
- La colección de clasificaciones sustenta $p_f(s)$ sólo mediante una población
  y una ponderación declaradas. La selección ordenada no se transforma en una
  muestra equiprobable por conveniencia.

Veredicto: `risk` debe reemplazarse por una metodología completa sin resultados.
La única nota de espera corresponde a las respuestas del modelo dinámico, los
criterios aprobados y la estimación resultante.

## Exact Claims Allowed

- El flujo oficial de registros emplea VMD y retira IMF1, modo de baja
  frecuencia en la convención del proyecto.
- El escenario combina objetivos PPV L/T/V con historias procesadas mediante
  escala PPV/PGV y rotación posterior a H1/H2/UP.
- Cada realización se aplicará al mismo modelo receptor de la sección evaluada
  y producirá las respuestas definidas por ese modelo.
- La falla se clasifica por realización mediante criterios de desempeño
  aprobados; la probabilidad de falla se estima por escenario.
- Un escenario satisface el criterio adoptado cuando $p_f(s)\le p_f^*$, o de
  forma equivalente $\beta(s)\ge\beta^*$ con
  $\beta=-\Phi^{-1}(p_f)$ [@AngTang1984; @BenjaminCornell1970].

## Claims Not Allowed

- VMD exclusivamente diagnóstica o historia completa sin retiro modal.
- Parámetros, residuo o aceptación de una corrida VMD no inspeccionada.
- Una selección genérica presentada como selección realizada.
- Un PPV crítico trasladado desde Brasil como capacidad de este depósito.
- Lognormalidad o independencia de demanda y capacidad importadas desde Brasil.
- Valores de presión de poros, deformación, umbrales, $p_f$, $\beta$ o
  clasificación de escenarios antes del modelo dinámico.

## Equations Allowed

- `records`: operadores espectrales, normalización, descriptores y PSA. La
  reconstrucción VMD queda en prosa hasta verificar su contrato.
- `scenarios`: escala PPV/PGV, rotación H1/H2 y errores de consistencia; la
  tolerancia numérica se hidrata desde la configuración aceptada.
- `risk`: operador del modelo receptor, indicador de falla por realización,
  estimador ponderado de $p_f$ y relación entre $p_f$ y $\beta$.

## Equations Excluded

- Frecuencia central, ancho de banda y energía modal sin prueba de que formen
  parte del flujo VMD reportado.
- Fórmulas de alternativas de selección no adoptadas.
- La ecuación cerrada lognormal de Brasil y su PPV crítico.
- Umbrales o combinaciones de estados límite inventados.

## Candidate Public Paragraph Or Section

### Records — sustitución mínima autorizada

> ### Reconstrucción mediante VMD
>
> La aceleración de cada registro y componente se descompone mediante
> descomposición variacional en modos (VMD) [@DragomiretskiyZosso2014]. En la
> convención adoptada para este estudio, IMF1 corresponde al modo de baja
> frecuencia y se excluye de la reconstrucción. Las historias reconstruidas a
> partir del contenido modal retenido constituyen la base procesada utilizada
> en las etapas posteriores.

El bloque elimina las afirmaciones falsas sin inventar $K$, parámetros, residuo
o estado de corrida. El detalle matemático espera la auditoría diferida.

### Scenarios — cierre sin inventar selección

> ### Trazabilidad de las realizaciones
>
> Cada realización conserva la identidad del registro fuente, la condición
> $D$--$Q$--$p$, la banda de procesamiento, los objetivos PPV en L/T/V y las
> historias resultantes en H1/H2/UP. El inventario del escenario relaciona esos
> atributos con las historias temporales, las medidas de intensidad y los
> espectros calculados. Esta trazabilidad vincula la respuesta posterior del
> modelo dinámico con la historia aplicada y con la condición de voladura que
> determinó su amplitud.

El bloque sustituye las líneas 97--103 hasta que una selección aceptada permita
agregar su configuración factual.

### Risk — metodología completa sin resultados

> Para cada escenario $s=(D,Q,p)$, el conjunto de realizaciones conserva los
> objetivos de amplitud definidos por la distancia, la carga y el cuantil
> predictivo, y representa mediante historias diferentes la variabilidad
> temporal y espectral de la demanda. El nivel $p$ pertenece al modelo de
> amplitudes. La evaluación de riesgo se formula sobre la distribución de
> respuestas obtenida para el escenario.
>
> Cada historia triaxial $\mathbf a_{s,r}(t)$ se aplica al modelo dinámico
> bidimensional de la sección crítica, en deformación plana y tensiones
> efectivas. La operación se representa como
> $\mathbf R_{s,r}=\mathcal M[\mathbf a_{s,r}(t);\boldsymbol\theta]$, donde
> $\boldsymbol\theta$ reúne la geometría, el estado inicial, las condiciones de
> borde y drenaje, la asignación de materiales y los parámetros constitutivos,
> y $\mathbf R_{s,r}$ contiene las respuestas calculadas para la realización
> $r$. PLAXIS y FLAC son las plataformas consideradas para el cálculo, y
> PM4Sand la formulación constitutiva prevista para los materiales
> correspondientes.
>
> Los criterios de desempeño se expresan mediante funciones de estado límite
> $g_\ell(\mathbf R_{s,r})$, cada una definida por su variable física, dominio
> espacial y temporal, forma de agregación y umbral. La realización se
> clasifica mediante
> $I_{s,r}=\mathbf 1\{\min_\ell g_\ell(\mathbf R_{s,r})\le0\}$, de modo que
> $I_{s,r}=1$ identifica la ocurrencia de al menos uno de los modos de falla
> aprobados. Las respuestas consideradas comprenden presión de poros,
> deformaciones, desplazamientos y las magnitudes de estabilidad o servicio
> adoptadas para la sección.
>
> La probabilidad condicional de falla del escenario es
> $p_f(s)=P(I_s=1\mid s)$. Para el conjunto analizado se estima mediante
> $\widehat p_f(s)=\sum_{r=1}^{N_s}w_{s,r}I_{s,r}$, con
> $w_{s,r}\ge0$ y $\sum_r w_{s,r}=1$. Los pesos representan la población y el
> diseño de muestreo adoptados para el análisis; una selección determinista por
> intensidad se conserva como conjunto condicionado y no se interpreta como
> muestra equiprobable.
>
> El criterio de aceptación se expresa como
> $\widehat p_f(s)\le p_f^*$. Su índice de confiabilidad equivalente es
> $\beta(s)=-\Phi^{-1}[\widehat p_f(s)]$, y la condición anterior corresponde a
> $\beta(s)\ge\beta^*=-\Phi^{-1}(p_f^*)$
> [@AngTang1984; @BenjaminCornell1970]. Esta formulación permite comparar las
> combinaciones de distancia y carga bajo un mismo nivel de desempeño sin
> sustituir la respuesta dinámica por un umbral de PPV.
>
> El modelo dinámico de deformaciones se encuentra en ejecución. Los resultados
> de $\mathbf R_{s,r}$, los estados límite aprobados, la población y los pesos
> utilizados, y los valores de $\widehat p_f$ y $\beta$ por escenario se
> incorporarán al informe al finalizar esa etapa.

## Candidate Translation Terminology

None. El español continúa como texto master.

## Open Gaps

1. Auditar el contrato y los JSON VMD para completar la reconstrucción y sus
   resultados.
2. Confirmar la tolerancia con la familia de escenarios aceptada.
3. Insertar la configuración factual de selección cuando exista la selección
   aceptada.
4. Para `risk`, recibir del branch dinámico: modelo receptor y versión,
   criterios de desempeño, población de realizaciones, pesos y resultados por
   escenario.
5. Auditar los resúmenes sólo después de aprobar estos cuerpos.

## Validation

- Cero JSON, ejecución de datos, render o acceso a SSEL.
- La metodología de riesgo conserva del precedente Brasil únicamente la
  arquitectura probabilística general; el mecanismo resistente es propio de
  este proyecto.
- La incertidumbre pendiente permanece como gate del SoT y la nota pública se
  limita a resultados realmente en espera.
- Las ecuaciones portantes quedan en el cuerpo; las definiciones de descriptores
  no ascienden automáticamente al resumen ejecutivo.
