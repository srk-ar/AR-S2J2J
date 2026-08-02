Este capítulo documenta la selección y el ajuste espectral de registros de
movimiento fuerte para su uso en los análisis dinámicos del sitio del proyecto.
El conjunto seleccionado busca representar registros reales compatibles con la
peligrosidad sísmica de control y con el espectro de respuesta objetivo adoptado
para el caso de análisis. Las verificaciones de compatibilidad relevantes
consideran nivel de amplitud, forma espectral, duración, ambiente tectónico, distancia fuente-sitio y
condiciones de sitio.

El espectro objetivo define la demanda espectral que las historias de
aceleración deben reproducir en el rango de períodos usado en el análisis. Por
esta razón, la selección de registros no se limita a igualar una única medida de
intensidad. También evalúa si los movimientos candidatos tienen un contexto
sismológico y un contenido de frecuencias consistentes con la peligrosidad del
proyecto y con la respuesta dinámica esperada del sistema analizado.

Los registros candidatos se obtienen desde bases de datos indexadas de
movimiento fuerte y se filtran mediante criterios sismológicos y de ingeniería
definidos para el proyecto. Estos criterios pueden incluir magnitud de momento,
distancia de ruptura o distancia de Joyner-Boore, régimen tectónico, clase de
sitio o velocidad de onda de corte medida, disponibilidad de componentes,
calidad del registro, rango de frecuencias útil y compatibilidad espectral
preliminar con el movimiento objetivo. Se conservan los metadatos de evento,
estación, componente y proveedor para que cada movimiento seleccionado mantenga
trazabilidad con el registro original.

Las series de aceleración seleccionadas se ajustan al espectro objetivo mediante
el procedimiento de deconvolución modal del proyecto. La metodología sigue
conceptos de descomposición modal empírica [@HuangEtAl1998], mientras que la
implementación activa utiliza Descomposición Modal Variacional (VMD)
[@DragomiretskiyZosso2014]. Cada registro se descompone en componentes modales y
se reconstruye para que la historia de aceleración ajustada satisfaga el
espectro objetivo dentro del rango de períodos y la tolerancia especificados.

El procedimiento corresponde a un ajuste de espectro de respuesta implementado
mediante descomposición modal basada en VMD. Mantiene la trazabilidad de cada
acelerograma original y modifica su contenido espectral de forma controlada. El
ajuste se evalúa contra el espectro objetivo y no debe interpretarse como una
alternativa separada al ajuste espectral.

Los diagnósticos de ajuste se reportan a nivel de registro e incluyen el error
espectral inicial, el error final y la verificación contra la tolerancia
objetivo. A partir de las historias de aceleración ajustadas se regeneran las
series de velocidad y desplazamiento, las medidas de intensidad acumulada, los
espectros de respuesta y las medidas escalares de intensidad reportadas para el
conjunto seleccionado. Estos diagnósticos y productos permiten verificar que los
registros usados en los análisis dinámicos sean consistentes con la demanda
sísmica adoptada para el proyecto.
