---
title: "DENSE-I16-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR est une Value unidimensionnelle homogène qui stocke à la suite des éléments int16 big-endian, sans descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


DENSE-I16-VECTOR est une Value unidimensionnelle homogène qui stocke à la suite des éléments int16 big-endian, sans descriptor.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000500`. Famille NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG d'extension de Length] si 15 WORD ou plus au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000500
Payload: [int16 1er: 1 WORD] ... [int16 Nème: 1 WORD]
```

## Règles d'interprétation {#해석-규칙}

- Chaque WORD est lu comme un entier en complément à deux de 16 bits indépendant. Le nombre d'éléments est le nombre de WORD du Payload.
- Il n'y a pas de padding ABI entre les éléments ni à la fin.

## Validité {#유효성}

- Le Payload doit faire au moins 1 WORD. Sans descriptor, ce format n'admet pas de vector vide.
- La taille du Payload doit être un multiple entier de la largeur d'élément, 1 WORD.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- La signedness du dtype d'entier signed et sa largeur de 16 bits s'alignent sur les dtypes industriels de l'[element type de tensor de l'ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) et de [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- L'interprétation en complément à deux, la suite unidimensionnelle sans descriptor, le TAG et la Length de GEUL et la disposition en WORD big-endian sont un format propre à GEUL. DLPack suppose un dtype native-endian ; ce Payload n'est donc la wire serialization ni de DLPack, ni d'ONNX.

## Length {#길이}

- Le total est le nombre de WORD obtenu en additionnant TAG 1 WORD, TAG d'extension de Length (s'il existe), Issuer 2 WORD, numéro de Codec 2 WORD et Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension est compté dans le total ([Length](../../record.md)).

## Exemple {#예시}

- Le Payload `FFFF 0002` correspond aux éléments `[-1, 2]`, soit un enregistrement de 7 WORD au total avec la longueur directe `LLLL=0110`.
