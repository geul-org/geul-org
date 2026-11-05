---
title: "IEEE-DECIMAL32-BID"
weight: 1027
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID est une Value qui représente l'interchange encoding IEEE 754 decimal32 BID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


IEEE-DECIMAL32-BID est une Value qui représente l'interchange encoding IEEE 754 decimal32 BID. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, numéro de Codec `0x00002003`, famille DECIMAL. Le bit pattern BID est conservé tel quel et se distingue de DPD.

## Disposition {#레이아웃}

```
TAG WORD          0x09D6  7 WORD au total
Issuer            2 WORD  0x0000000D (IEEE)
Numéro de Codec   2 WORD  0x00002003
Payload           2 WORD (32 bits)  IEEE decimal32 BID Interchange
```

## Interprétation {#해석}

- Les deux WORD du Payload, concaténés à partir du WORD de poids fort, sont lus comme la chaîne de bits d'interchange IEEE 754 decimal32 BID.
- Le bit pattern est conservé ; on ne le réinterprète pas arbitrairement en DPD ou en SIGNED-DECIMAL.
- Les valeurs spéciales et les payloads ne sont pas normalisés arbitrairement.

## Validité et Length {#유효성과-길이}

- Le total est de 7 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 2 WORD ; on utilise la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 2 WORD, on rejette.
- La validité sémantique de la chaîne de bits suit les règles d'interchange IEEE BID.

## Exemple {#예시}

| Structure | Verdict |
|---|---|
| `09D6 0000 000D 0000 2003` + 2 WORD de bits BID | structure de longueur canonique |
| `09D6 0000 000D 0000 2003` + 4 WORD | invalid : largeur de Payload non concordante |
| Numéro de Codec `0x00002000` pour les mêmes 32 bits | format DPD, et non ce type |

## Référence normative {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) : on applique le binary coefficient encoding (BID) du format d'interchange decimal32. On ne convertit pas numériquement vers l'alternative DPD admise par l'IEEE ; on conserve l'encoding de 32 bits choisi, et GEUL n'ajoute que le TAG et le framing en WORD big-endian.
