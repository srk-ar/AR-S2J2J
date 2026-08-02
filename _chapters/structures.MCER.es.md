### Espectros MCER y espectros elásticos de diseño {#sec-mcer}

La demanda sísmica de las estructuras convencionales se establece de acuerdo con ASCE/SEI 7-22 a partir de los espectros de amenaza y respuesta de sitio desarrollados en la Parte I. La Sección 11.4.7 remite a los procedimientos específicos del sitio de las Secciones 21.1 y 21.2; cuando se aplican esos procedimientos, el espectro de diseño y sus parámetros se determinan conforme a las Secciones 21.3 y 21.4 [@ASCE722, secs. 11.4.7, 21.1--21.4].

En el procedimiento normativo, las ordenadas MCER corresponden a la dirección de máxima respuesta horizontal con 5% de amortiguamiento crítico y se asocian a una probabilidad de colapso de 1% en 50 años. Las ordenadas probabilísticas se obtienen conforme a la Sección 21.2.1: para cada período estructural y condición de sitio $V_{S30}$, la ordenada resulta de la integración iterativa de la curva de amenaza específica del sitio con la fragilidad lognormal de colapso prescrita por la norma —10% de probabilidad de colapso en la ordenada y desviación logarítmica 0.6— hasta alcanzar una probabilidad de colapso de 1% en 50 años [@ASCE722, sec. 21.2.1]. El procedimiento de riesgo objetivo que la norma adopta proviene de Luco *et al.* [-@Luco2007].

El escalado direccional de la norma es condicional: se aplica únicamente cuando las aceleraciones espectrales predichas por los modelos de movimiento del suelo no representan la respuesta máxima en el plano horizontal, con factores de 1.2 para $T\leq0.2$ s, 1.25 para $T=1.0$ s y 1.3 para $T\geq10$ s cuando los modelos predicen la media geométrica o una métrica similar de las dos componentes horizontales [@ASCE722, sec. 21.2]. Los espectros de este informe conservan la medida horizontal suministrada por los modelos de movimiento del suelo, sin factor direccional adicional.

De acuerdo con la Sección 21.3, las aceleraciones espectrales elásticas de diseño se obtienen a partir de las ordenadas MCER mediante

$$
S_a(T)=\frac{2}{3}S_{aM}(T).
$${#eq-structures-design-spectrum}

Para procedimientos específicos del sitio, los parámetros de aceleración de diseño se calculan como [@ASCE722, sec. 21.4]

$$
\begin{aligned}
S_{DS}
  &=0.9\max_{T\in[0.2,5]\,\mathrm{s}}S_a(T),\\
S_{D1}
  &=\max\!\left[
      0.9\max_{T\in[1,T^*]\,\mathrm{s}}\bigl(T\,S_a(T)\bigr),
      S_a(1\,\mathrm{s})
    \right],\\
T^*
  &=\begin{cases}
      2\,\mathrm{s}, & \bar v_S>442\,\mathrm{m/s},\\
      5\,\mathrm{s}, & \bar v_S\leq442\,\mathrm{m/s}.
    \end{cases}
\end{aligned}
$${#eq-structures-design-parameters}

Los parámetros MCER correspondientes se recuperan de los valores de diseño mediante

$$
S_{MS}=1.5S_{DS},\qquad S_{M1}=1.5S_{D1}.
$${#eq-structures-mcer-parameters}

El capítulo conserva los espectros MCER específicos del sitio para las condiciones de $V_{S30}$ evaluadas, con una ordenada por cada período de las curvas de amenaza; los resultados reportan la PGA MCER y las ordenadas espectrales máximas por condición de sitio.

La Sección 21.2.2 acota inferiormente el espectro MCER mediante los valores tabulados de la Tabla 21.2-1, definidos por clase de sitio entre $T=0$ y 10 s e incluyendo la PGA, y admite una excepción: cuando el espectro probabilístico se mantiene por debajo de esos valores en todos los períodos, los movimientos determinísticos no se calculan [@ASCE722, sec. 21.2.2]. La verificación de ese límite consiste en comparar el espectro probabilístico con los valores tabulados en cada condición de sitio evaluada. El piso del 80% de la Sección 21.2.3 se ancla a la base de datos geoespacial de diseño sísmico del USGS y su aplicación se limita a la cobertura de esa base [@ASCE722, sec. 21.2.3].
