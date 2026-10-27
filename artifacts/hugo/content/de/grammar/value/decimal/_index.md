---
title: "Value — Dezimalzahlen"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "Die exakten Dezimalformate der DECIMAL-Familie (Codec `0x10`~`0x1F`, Formatnummern `0x2000`~`0x3FFF`): SIGNED-DECIMAL und UNSIGNED-DECIMAL sowie IEEE 754 decimal32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die DECIMAL-Familie umfasst exakte Dezimalformate. Sie liegen bei den direkten Codes `0x10`~`0x1F` (obere 3 Bit des Codec `001`) und den Issuer-Formatnummern `0x2000`~`0x3FFF`.

- Die direkten Codes SIGNED-DECIMAL und UNSIGNED-DECIMAL werden als `C × 10^E` geschrieben und bewahren die Stellenzahl der ursprünglichen Schreibweise unverändert. `1.20` (`C=120, E=−2`) und `1.2` (`C=12, E=−1`) sind verschiedene Records. Wertgleichheit und Bewahrung des Quantums sind eine offene Frage von [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/#offene-fragen).
- Die DPD- und BID-Kodierungen von IEEE 754 decimal32/64/128 sind Formate des IEEE-Issuers (`0x0040`).
