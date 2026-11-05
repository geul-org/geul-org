---
title: "IEEE-DECIMAL64-DPD"
weight: 1030
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-DPD est une Value qui représente l'interchange encoding IEEE 754 decimal64 DPD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


IEEE-DECIMAL64-DPD est une Value qui représente l'interchange encoding IEEE 754 decimal64 DPD. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, numéro de Codec `0x00002001`, famille DECIMAL. Le bit pattern DPD est conservé tel quel et se distingue de BID.

## Disposition {#레이아웃}

```
TAG WORD          0x09D8  9 WORD au total
Issuer            2 WORD  0x0000000D (IEEE)
Numéro de Codec   2 WORD  0x00002001
Payload           4 WORD (64 bits)  IEEE decimal64 DPD Interchange
```

## Interprétation {#해석}

- Les quatre WORD du Payload, concaténés à partir du WORD de poids fort, sont lus comme la chaîne de bits d'interchange IEEE 754 decimal64 DPD.
- Le bit pattern est conservé ; on ne le réinterprète pas arbitrairement en BID ou en un format exact decimal.
- Les valeurs spéciales et les payloads ne sont pas normalisés arbitrairement.

## Validité et Length {#유효성과-길이}

- Le total est de 9 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 4 WORD ; on utilise la longueur directe `LLLL=1000`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 4 WORD, on rejette.
- La validité sémantique de la chaîne de bits suit les règles d'interchange IEEE DPD.

## Exemple {#예시}

| Structure | Verdict |
|---|---|
| `09D8 0000 000D 0000 2001` + 4 WORD de bits DPD | structure de longueur canonique |
| `09D8 0000 000D 0000 2001` + 2 WORD | invalid : largeur de Payload non concordante |
| Numéro de Codec `0x00002004` pour les mêmes 64 bits | format BID, et non ce type |

## Référence normative {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) : on applique le decimal coefficient encoding (DPD) du format d'interchange decimal64. On ne convertit pas numériquement vers l'alternative BID admise par l'IEEE ; on conserve l'encoding de 64 bits choisi, et GEUL n'ajoute que le TAG et le framing en WORD big-endian.
