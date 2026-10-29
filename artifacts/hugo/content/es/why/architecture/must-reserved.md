---
title: "Por qué debemos dejarlo vacío"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["reservado", "extensibilidad", "TAG WORD", "principio-de-diseño", "IPv4"]
summary: "GEUL deja vacío el 75% del espacio de la TAG WORD de 16 bits que abre cada registro. Las lecciones de IPv4, Unicode y ASCII: el costo de llenar es irreversible, mientras que el de dejar vacío es de tres bits por registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Todo registro GEUL comienza con una sola TAG WORD de 16 bits. Los bits iniciales de la TAG WORD la dividen en regiones. GEUL deja vacío el 75% de este espacio.

```
1xx:  50%    Futuro lejano
01x:  25%    Futuro cercano
001:  12.5%  Estándar
000:  12.5%  Gramática actual (libre / propuesta)
```

Toda la gramática actual vive en la región `000`, dentro del 12.5%. Cuando se lance un estándar oficial, los diseños adoptados se quedarán como están y solo los bits iniciales pasarán a `001`. El 75% restante se deja para generaciones que aún no han nacido.

¿Por qué?

---

## La lección de IPv4

En 1981, quienes diseñaron IPv4 pensaron que 32 bits serían suficientes. 4.300 millones de direcciones. En aquel entonces, había apenas unos cientos de computadoras en el mundo. 4.300 millones parecían eternos.

En 2011, las direcciones IPv4 se agotaron.

30 años. Solo 30 años.

Lo que la humanidad hizo después del agotamiento: NAT, CGNAT, mercados de compraventa de direcciones, doble pila IPv6. Décadas y billones en costos. Todo ello "innecesario si se hubiera dejado espacio vacío desde el principio".

IPv6 adoptó 128 bits. 3,4 × 10^38 direcciones. 6,7 × 10^17 por cada metro cuadrado de la superficie terrestre. ¿Esta vez será suficiente? Probablemente. Pero ni siquiera ellos estaban seguros, por eso eligieron 128 bits.

---

## La lección de Unicode

En 1991, Unicode 1.0 pensó que 16 bits serían suficientes. 65.536 caracteres. Parecía que podrían contener todos los caracteres del mundo.

No bastó. Extensiones de caracteres chinos, emojis, escrituras antiguas, símbolos musicales. Superaron los 16 bits.

El resultado: pares sustitutos de UTF-16. Uno de los hacks más feos en la historia del software. Windows, Java y JavaScript todavía cargan con este legado.

Unicode finalmente se extendió a 21 bits (1.114.112 puntos de código). El uso actual es de aproximadamente el 10%. El resto se dejó vacío. Esta vez aprendieron la lección.

---

## La lección de ASCII

En 1963, ASCII usó 7 bits. 128 caracteres. Solo pensaron en el inglés.

Como resultado, la humanidad vivió 60 años en un infierno de codificaciones. EUC-KR, Shift_JIS, Big5, la serie ISO-8859, CP949. El mismo byte representaba un carácter distinto según el sistema. Caracteres coreanos rotos. Caracteres japoneses rotos. Signos de interrogación en los asuntos de los correos electrónicos.

Si hubieran usado solo 1 bit más. Si hubieran asegurado 8 bits completos y dicho "el resto, para después". La historia habría sido diferente.

---

## La arrogancia del diseñador

Todos estos casos comparten algo en común: **la suposición de que "lo que necesitamos ahora es suficiente".**

¿Eran tontos los diseñadores de IPv4? No. Eran los mejores ingenieros de su época. Simplemente subestimaron el futuro. Todas las generaciones lo hicieron.

"640 KB deberían ser suficientes para cualquiera." Se debate si Bill Gates dijo esto realmente, pero es un hecho que los ingenieros de todas las épocas cayeron en esta trampa.

GEUL intenta evitar esta trampa. El método es simple. **No usarlo.**

---

## A la tercera va la vencida

En España se dice "a la tercera va la vencida". La tercera oportunidad es la definitiva.

```
Primera oportunidad: 001 (estándar)
  Cuando los humanos establezcan estándares.
  Ya sea un organismo internacional, un consorcio industrial o una comunidad.
  Un espacio que se llenará a la velocidad a la que las personas pueden llegar a acuerdos.

Segunda oportunidad: 01 (futuro)
  Después de S1. Cuando surja la superinteligencia.
  Una entidad que estructurará el conocimiento de maneras que los humanos no pueden predecir.
  Podría usar nuestra estructura tal cual,
  o redefinirla de formas que no podemos imaginar.
  Un espacio para esa entidad.

Tercera oportunidad: 1 (futuro lejano)
  No sabemos cuándo será.
  Quizá cuando se alcance K1 y surja una civilización interestelar,
  quizá cuando cambie la forma misma de la conciencia,
  quizá algo que hoy solo podemos imaginar como ciencia ficción.
  Si alguien más allá del Brazo de Orión* lee este bit,
  este espacio es suyo.
```

Reservar el 50% para el futuro lejano significa ceder la mitad de las posibilidades a "lo que desconocemos".

---

## El costo de dejar vacío

¿Cuesta algo dejar espacio vacío?

```
TAG WORD de 16 bits = región de 3 bits + 13 bits

Los 13 bits de la región actual 000:
  Kind    2 bits   Reference · Value · Edge · Meta
  Length  4 bits   1–14 WORD, hasta 2³²−1 WORD si se extiende
  Codec   7 bits   124 códigos directos + 4 formas de Issuer
```

¿No son pocos 13 bits? No. Un formato que no obtiene código directo se escribe como formato de Issuer. Cada entidad que define formatos (Issuer) tiene sus propios números de formato de 16 bits, así que en la práctica no hay límite al número de formatos. El precio son unas pocas WORD de TAG de extensión. Los formatos frecuentes son cortos; los raros, un poco más largos.

El costo de dejar vacío son tres bits de la TAG WORD por registro. Esos tres bits reservan para el futuro seis veces el espacio que se usa hoy.

¿El costo de llenar? IPv4 nos lo mostró. Es irreversible.

---

## Principio de diseño

El quinto principio de diseño de la [gramática](/es/grammar/overview/) GEUL v1:

> **Dejarlo vacío.** La mayor parte del espacio de bits se guarda para el futuro. Los códigos directos no se pueden recuperar, así que solo los reciben formatos de frecuencia comprobada.

La gramática fija este principio como regla. Un decodificador v1 rechaza toda TAG WORD cuyos bits iniciales no sean `000`. El camino para tomar prestado el espacio vacío para usos temporales está cerrado desde el principio.

Esta no es una decisión técnica. Es una decisión ética.

Elegir no usar espacio que podría usarse ahora es una declaración de que la libertad del futuro tiene prioridad sobre la conveniencia del presente. La deuda que la generación que diseñó IPv4 nos dejó, no la dejaremos a la siguiente generación.

---

## El diseño más humilde

```
"Conozco el futuro" -> Usar los 16 bits.
"No conozco el futuro" -> Dejar el 75% vacío.
```

Dejar espacio vacío es humildad. Es el acto de reconocer que no podemos conocer el futuro. Y esa humildad produce el diseño más robusto.

IPv4 fue producto de la confianza. 32 bits son suficientes. No lo fueron.

GEUL es producto de la humildad. No sabemos si el 12.5% que se usa hoy es suficiente. Pero si dejamos el 75% vacío, está bien equivocarse.

---

*Explicar por qué dejarlo vacío requirió tantas palabras. El acto de dejarlo vacío cabe en una sola línea:*

```
if (bit1 == 1): reserved  // 50%. Futuro lejano.
```

*Una sola línea de código protege la mitad del mundo.*

---

<small>

\* Orion's Arm — el brazo espiral de la Vía Láctea al que pertenece nuestro sistema solar. También es el nombre del [Orion's Arm Universe Project](https://www.orionsarm.com/), un proyecto colaborativo de ciencia ficción dura que imagina un futuro más de diez mil años adelante, ambientado en este brazo espiral. Explora temas como la superinteligencia, las civilizaciones interestelares y la transformación de la conciencia con rigor científico, y ha sido construido por cientos de colaboradores desde el año 2000. Lo que GEUL llama "futuro lejano", ellos ya lo están imaginando.

</small>
