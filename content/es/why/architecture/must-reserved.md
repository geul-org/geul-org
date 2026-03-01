---
title: "Por qué debemos dejarlo vacío"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["reservado", "extensibilidad", "64-bit", "principio-de-diseño", "IPv4"]
summary: "GEUL deja vacío el 75% de su espacio de 64 bits. Las lecciones de IPv4, Unicode y ASCII nos enseñan: el costo de llenar es irreversible, pero el costo de dejar vacío es cero."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

64 bits contienen 18.446.744.073.709.551.616 direcciones. 18,4 trillones. GEUL deja vacío el 75% de ellas.

```
bit1 = 1:    50%    futuro lejano
bit1-2 = 01: 25%    futuro cercano
bit1-3 = 001: 12,5% estándar
bit1-4 = 0001: 6,25% propuesta actual
```

El espacio actualmente en uso es el 6,25%. Del 93,75% restante, el 12,5% se usará cuando se establezcan los estándares, y el 75% se reserva para generaciones que aún no han nacido.

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

¿Tiene algún costo dejar vacío?

```
75% reservado de 64 bits = 48 bits sin usar.
Los 16 bits restantes (6,25%) = 1.152.921.504.606.846.976 direcciones.

11,5 trillones.
10 millones de veces el total de Wikidata (108 millones).
Suficiente para contener todos los datos existentes y mucho más.
```

Dejarlo vacío no significa quedarse corto. El 6,25% es suficiente para las necesidades actuales. El costo de dejarlo vacío es 0.

¿El costo de llenarlo? IPv4 lo demostró. Es irreversible.

---

## Principio de diseño

El artículo 1 de los principios de diseño de GEUL Grammar v0.11:

> **Extensibilidad a largo plazo:** Los bits reservados no se reasignan a usos temporales. Se preserva el espacio para que las generaciones futuras puedan utilizarlo.

Esta no es una decisión técnica, sino una decisión ética.

Dejar sin usar un espacio que podría usarse ahora es una declaración de que la libertad del futuro importa más que la conveniencia del presente. La deuda que la generación que diseñó IPv4 nos dejó, nosotros no se la dejaremos a la siguiente generación.

---

## El diseño más humilde

```
"Conozco el futuro" → Uso los 64 bits completos.
"No conozco el futuro" → Dejo vacío el 75%.
```

Dejar vacío es humildad. Es reconocer que quienes estamos aquí ahora no podemos conocer el futuro. Y esa humildad produce el diseño más robusto.

IPv4 fue producto de la confianza. 32 bits son suficientes. No lo fueron.

GEUL es producto de la humildad. No sabemos si el 6,25% de 64 bits será suficiente. Pero si dejamos vacío el 75%, no pasa nada si nos equivocamos.

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
