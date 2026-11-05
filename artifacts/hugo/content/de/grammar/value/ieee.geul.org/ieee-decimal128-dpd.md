---
title: "IEEE-DECIMAL128-DPD"
weight: 1026
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD ist ein Value, der das IEEE-754-decimal128-DPD-Interchange-Encoding darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD ist ein Value, der das IEEE-754-decimal128-DPD-Interchange-Encoding darstellt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, Codec-Nummer `0x00002002`, Familie DECIMAL. Das DPD-Bitmuster bleibt unverändert erhalten und ist von BID zu unterscheiden.

## Layout {#레이아웃}

```
TAG WORD          0x09DC  insgesamt 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec-Nummer      2 WORD  0x00002002
Payload           8 WORD (128 Bit)  IEEE decimal128 DPD Interchange
```

## Interpretation {#해석}

- Acht Payload-WORD werden ab dem höchstwertigen WORD aneinandergereiht und als IEEE-754-decimal128-DPD-Interchange-Bitfolge gelesen.
- Das Bitmuster bleibt erhalten und wird nicht willkürlich als BID oder exact decimal-Format neu interpretiert.
- Spezialwerte oder Payloads werden nicht willkürlich normalisiert.

## Gültigkeit und Länge {#유효성과-길이}

- Die Gesamtlänge ist genau 13 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 8 WORD Payload; verwendet wird die direkte Länge `LLLL=1100`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 8 WORD, wird er abgelehnt.
- Die semantische Gültigkeit der Bitfolge folgt den IEEE-DPD-Interchange-Regeln.

## Beispiel {#예시}

| Struktur | Beurteilung |
|---|---|
| `09DC 0000 000D 0000 2002` + 8 WORD DPD-Bitfolge | regulär |
| Gesamtlänge nicht 13 WORD (`LLLL=1100`) | invalid: Abweichung von der festen Payload-Breite |

## Normgrundlage {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): Angewandt wird das Decimal-Coefficient-Encoding des decimal128-Interchange-Formats. Es wird nicht numerisch in die von IEEE zugelassene BID-Alternative umgewandelt, sondern das gewählte 128-Bit-Encoding bleibt erhalten; GEUL fügt nur den TAG und das Big-Endian-WORD-Framing hinzu.
