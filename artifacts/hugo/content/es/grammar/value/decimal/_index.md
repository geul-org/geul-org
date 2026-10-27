---
title: "Value — decimal"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "Formatos decimales exactos de la familia DECIMAL (Codec `0x10`~`0x1F`, número de formato `0x2000`~`0x3FFF`): SIGNED·UNSIGNED-DECIMAL e IEEE 754 decimal32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La familia DECIMAL son formatos decimales exactos. Se colocan en los códigos directos `0x10`~`0x1F` (3 bits superiores del Codec `001`) y en los números de formato Issuer `0x2000`~`0x3FFF`.

- Los códigos directos SIGNED-DECIMAL y UNSIGNED-DECIMAL se escriben como `C × 10^E` y contienen tal cual los dígitos de la notación original. `1.20` (`C=120, E=−2`) y `1.2` (`C=12, E=−1`) son registros distintos. La equivalencia de valor y la conservación del quantum son un problema abierto de [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/#problemas-abiertos).
- Las codificaciones DPD y BID de decimal32/64/128 de IEEE 754 son formatos del Issuer IEEE (`0x0040`).
