---
title: "DENSE-U32-VECTOR"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U32-VECTOR est une Value de vector à une dimension qui contient à la suite, sans descriptor, des éléments uint32 big-endian (format d'Issuer ADHOC 0x0503)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U32-VECTOR est une Value homogène à une dimension qui stocke à la suite, sans descriptor, des éléments uint32 big-endian.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0503`. Famille NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0503
Payload: [uint32 1er: 2 WORD] ... [uint32 Nème: 2 WORD]
```

## Règles d'interprétation

- Les 2 WORD consécutifs, combinés à partir du WORD de poids fort, se lisent comme un entier unsigned de 32 bits.
- Le nombre d'éléments est 1/2 du nombre de WORD du Payload, et il n'y a pas de remplissage ABI.

## Validité

- Le Payload fait au moins 2 WORD et doit être un multiple entier de 2 WORD. Ce format sans descriptor n'admet pas de vector vide.

## Fondement normatif et statut du format

- L'interprétation unsigned du dtype entier non signé et sa largeur de 32 bits suivent les dtype industriels du [tensor element type de l'ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) et de [`DLDataType` de DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- La suite continue à une dimension sans descriptor, le TAG et la Length de GEUL et la disposition en WORD big-endian sont un format propre à GEUL. DLPack suppose que le dtype est en native-endian, donc ce Payload n'est pas la sérialisation wire de DLPack ni d'ONNX.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Length](/fr/grammar/record/)).

## Exemple

- Le Payload `0000 0000 ffff ffff` donne les éléments `[0, 4294967295]`, enregistrement de 7 WORD au total.
