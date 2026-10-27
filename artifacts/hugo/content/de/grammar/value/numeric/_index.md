---
title: "Value — Zahlen"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "Die grundlegenden Zahlenformate der NUMERIC-Familie (Codec `0x00`~`0x0F`): BOOL, Ganzzahlen, IEEE-754-Gleitkomma, Koordinaten von Erde und Himmelskörpern, QUANTITY mit Einheit und FRACTION, ein Bruch, der seine Schreibweise wahrt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die grundlegenden Zahlenformate der NUMERIC-Familie. Sie liegen bei den direkten Codes `0x00`~`0x0F` (obere 3 Bit des Codec `000`) und den Issuer-Formatnummern `0x0000`~`0x1FFF`.

- Es gibt BOOL, vorzeichenbehaftete und vorzeichenlose Ganzzahlen, IEEE-754-Binär-Gleitkomma, Koordinaten der Erde (WGS 84) und von Himmelskörpern, QUANTITY, das Menge, Einheit und Schranken bündelt, sowie FRACTION, ein Bruch in der Schreibweise des Originals.
- Ganzzahlen werden mit der minimalen WORD-Zahl geschrieben, in die der Wert passt.
- Für die kleinen Skalar-Issuer-Formate (BFLOAT16, FP8, FP4) sind nur Formatnummern vergeben, eine detaillierte Spezifikation gibt es nicht (offene Frage in [Value](/de/grammar/value/#offene-fragen)).
- Vektoren, Tensoren, komplexe Zahlen, gekürzte Brüche (RATIONAL-I64) und Intervalle gehören ebenfalls zur NUMERIC-Familie, sind aber Issuer-Formate und liegen daher in den Gruppen [vector](/de/grammar/value/vector/), [tensor](/de/grammar/value/tensor/) und [etc](/de/grammar/value/etc/).
