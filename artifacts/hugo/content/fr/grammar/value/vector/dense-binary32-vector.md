---
title: "DENSE-BINARY32-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR est une Value de vector à une dimension qui contient à la suite, sans descriptor, des éléments binary32 (format d'Issuer ADHOC 0x0508)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR stocke à la suite, sans descriptor, des motifs de bits d'interchange IEEE 754 binary32.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0508`. Famille NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0508
Payload: [binary32 bits 1er: 2 WORD] ... [binary32 bits Nème: 2 WORD]
```

## Règles d'interprétation

- Les 2 WORD consécutifs forment un élément, lu à partir du WORD de poids fort. Les motifs de bits, y compris le payload des NaN et le zéro signé, sont conservés tels quels.
- Le nombre d'éléments est 1/2 du nombre de WORD du Payload, et il n'y a pas de remplissage ABI.

## Validité

- Le Payload fait au moins 2 WORD et doit être un multiple entier de 2 WORD. Ce format sans descriptor n'admet pas de vector vide.

## Fondement normatif et statut du format

- Le format d'interchange des éléments binary32 suit [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- La suite continue à une dimension sans descriptor, le TAG et la Length de GEUL et la disposition en WORD big-endian de 16 bits sont un format propre à GEUL. [`DLDataType` de DLPack](https://dmlc.github.io/dlpack/latest/c_api.html) supposant le native-endian, ce Payload n'est pas la sérialisation wire de DLPack, d'Arrow ni d'ONNX.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Length](/fr/grammar/record/)).

## Exemple

- Le Payload `3f80 0000 8000 0000` est le binary32 `[1.0, -0]`, un enregistrement de 7 WORD au total.
