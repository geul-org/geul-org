---
title: "Value — Decimais"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "Formatos de decimal exato da família DECIMAL (Codec `0x10`~`0x1F`, números de formato `0x2000`~`0x3FFF`): SIGNED e UNSIGNED-DECIMAL e IEEE 754 decimal32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A família DECIMAL são formatos de decimal exato. Ficam nos códigos diretos `0x10`~`0x1F` (3 bits superiores do Codec `001`) e nos números de formato Issuer `0x2000`~`0x3FFF`.

- Os códigos diretos SIGNED-DECIMAL e UNSIGNED-DECIMAL escrevem-se como `C × 10^E` e guardam tal como está o número de dígitos da notação original. `1.20` (`C=120, E=−2`) e `1.2` (`C=12, E=−1`) são registros diferentes. A equivalência de valor e a preservação do quantum são questões em aberto de [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/#questões-em-aberto).
- As codificações DPD e BID de IEEE 754 decimal32/64/128 são formatos do Issuer IEEE (`0x0040`).
