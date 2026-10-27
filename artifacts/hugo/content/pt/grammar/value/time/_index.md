---
title: "Value — Tempo"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "Formatos de data e hora da família TIME (Codec `0x20`~`0x3F`, números de formato `0x4000`~`0x7FFF`): data gregoriana, timestamps, tempo decorrido, EDTF e data GEDCOM."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A família TIME são formatos de data e hora. Ficam nos códigos diretos `0x20`~`0x3F` e nos números de formato Issuer `0x4000`~`0x7FFF`.

| Precisão | Formato |
|---|---|
| data (calendário gregoriano) | GREGORIAN-DATE |
| ano e mês, incerta, intervalo | EDTF |
| notação original de outro calendário (juliano etc.) | GEDCOM-DATE |
| hora | timestamps POSIX, TAI e GPS |
| tempo decorrido | DURATION-SECONDS, DURATION-NANOSECONDS |

- Uma data que se pode escrever como GREGORIAN-DATE não se escreve como EDTF.
- O timestamp em nanossegundos e os formatos TAI e GPS são formatos sob o Issuer de cada entidade de normalização (IEEE, BIPM, GPS).
