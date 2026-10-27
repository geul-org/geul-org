---
title: "Value — numérico"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "Formatos numéricos básicos de la familia NUMERIC (Codec `0x00`~`0x0F`): BOOL, enteros, punto flotante IEEE 754, coordenadas de la Tierra y de cuerpos celestes, QUANTITY con unidad y FRACTION, una fracción que conserva su notación."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Son los formatos numéricos básicos de la familia NUMERIC. Se colocan en los códigos directos `0x00`~`0x0F` (3 bits superiores del Codec `000`) y en los números de formato Issuer `0x0000`~`0x1FFF`.

- Hay BOOL, enteros con y sin signo, punto flotante binary de IEEE 754, coordenadas de la Tierra (WGS 84) y de cuerpos celestes, QUANTITY, que une cantidad, unidad y límites, y FRACTION, una fracción tal como está escrita.
- Los enteros se escriben con los WORD mínimos en que quepa el valor.
- Los formatos Issuer de escalares pequeños (BFLOAT16, FP8, FP4) solo tienen asignado el número de formato y carecen de especificación detallada (problema abierto de [Value](/es/grammar/value/#problemas-abiertos)).
- Los vectores, tensores, complejos, fracciones irreducibles (RATIONAL-I64) e intervalos también son de la familia NUMERIC, pero como son formatos Issuer se colocan en los conjuntos [vector](/es/grammar/value/vector/), [tensor](/es/grammar/value/tensor/) y [etc](/es/grammar/value/etc/).
