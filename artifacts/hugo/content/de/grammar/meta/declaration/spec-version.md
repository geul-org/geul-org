---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION ist ein Definitions-Meta, das die vom Dokument befolgte GEUL-Spezifikationsausgabe als einzelne Ganzzahl deklariert. GEUL v1 ist 0x0001."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Deklariert die GEUL-Spezifikationsausgabe, der das Dokument folgt. Dieser Wert bestimmt, wie die übrigen Records zu lesen sind.

## Layout

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[Length-Erweiterungs-TAG]
Payload           Spezifikationsausgabe. v1 = 0x0001
```

- Codec: Meta `0x10`, Definitionsklasse (`001`)
- Payload: Rohwert (unsigned Ganzzahl in der kürzesten Breite)
- Anzahl: höchstens eins

## Interpretation und Gültigkeit

- Er stützt sich nicht auf Value-Codes. Damit Decoder jeder Ausgabe ihn lesen können, steht nur die Ganzzahl, ohne eingebetteten Value.
- Bei einer unbekannten Ausgabe lehnt der Decoder ab oder warnt.
- Fehlt er, liest der Decoder mit der Ausgabe, die er kennt. Veröffentlichte Dokumente geben ihn an.

## Beispiel

- `0x1890 0x0001`: GEUL v1

## Offene Fragen

- Zuordnung zur Version des Codebook-Dokuments ([Spezifikationsdokument](/de/grammar/codec-spec/)).
