---
title: "Value — tiempo"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "Formatos de fecha y hora de la familia TIME (Codec `0x20`~`0x3F`, número de formato `0x4000`~`0x7FFF`): fechas del calendario gregoriano, marcas de tiempo, tiempo transcurrido, EDTF y fechas GEDCOM."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La familia TIME son formatos de fecha y hora. Se colocan en los códigos directos `0x20`~`0x3F` y en los números de formato Issuer `0x4000`~`0x7FFF`.

| Precisión | Formato |
|---|---|
| Fecha (calendario gregoriano) | GREGORIAN-DATE |
| Año·mes, incierta, intervalo | EDTF |
| Notación original de otros calendarios (juliano, etc.) | GEDCOM-DATE |
| Hora | Marcas de tiempo POSIX·TAI·GPS |
| Tiempo transcurrido | DURATION-SECONDS, DURATION-NANOSECONDS |

- Una fecha que se pueda escribir con GREGORIAN-DATE no se escribe con EDTF.
- Las marcas de tiempo en nanosegundos y los formatos TAI·GPS son formatos bajo el Issuer del organismo de normalización correspondiente (IEEE, BIPM, GPS).
