---
title: "DENSE-BINARY32-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR stocke à la suite des interchange bit patterns IEEE 754 binary32, sans descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


DENSE-BINARY32-VECTOR stocke à la suite des interchange bit patterns IEEE 754 binary32, sans descriptor.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000508`. Famille NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG d'extension de Length] si 15 WORD ou plus au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000508
Payload: [binary32 bits 1er: 2 WORD] ... [binary32 bits Nème: 2 WORD]
```

## Règles d'interprétation {#해석-규칙}

- Deux WORD consécutifs forment un élément, lus à partir du WORD de poids fort. Le bit pattern, y compris le NaN payload et le signed zero, est conservé tel quel.
- Le nombre d'éléments est 1/2 du nombre de WORD du Payload ; il n'y a pas de padding ABI.

## Validité {#유효성}

- Le Payload fait au moins 2 WORD et est un multiple entier de 2 WORD. Sans descriptor, ce format n'admet pas de vector vide.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- L'interchange format des éléments binary32 suit [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- La suite unidimensionnelle sans descriptor, le TAG et la Length de GEUL et la disposition en WORD big-endian de 16 bits sont un format propre à GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) suppose le native-endian ; ce Payload n'est donc la wire serialization ni de DLPack, ni d'Arrow, ni d'ONNX.

## Length {#길이}

- Le total est le nombre de WORD obtenu en additionnant TAG 1 WORD, TAG d'extension de Length (s'il existe), Issuer 2 WORD, numéro de Codec 2 WORD et Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension est compté dans le total ([Length](../../record.md)).

## Exemple {#예시}

- Le Payload `3F80 0000 8000 0000` est binary32 `[1.0, -0]`, soit un enregistrement de 9 WORD au total.
