---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR est une Value de tenseur qui décrit le shape et l'element format dans le descriptor du Payload, puis stocke un payload C-contiguous row-major."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


DESCRIBED-DENSE-TENSOR est une Value de tenseur qui décrit le shape et l'element format dans le descriptor du Payload, puis stocke un payload C-contiguous row-major. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000600`, famille NUMERIC.

## Disposition {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG d'extension de Length] si 15 WORD ou plus au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000600
Payload WORD 1er  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload suivants  [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload reste     [dense payload]
```

## Interprétation {#해석}

- Le rank étant une valeur de 4 bits dans le descriptor, il ne peut structurellement représenter que `0..15`. Chaque dimension est un uint32 big-endian non négatif.
- Comme dans les règles de tensor logique d'ONNX, le shape de rank 0 `[]` est un scalar d'un seul élément, et si l'une des dimensions vaut 0, le nombre d'éléments est 0. Sinon, le nombre d'éléments est le produit de toutes les dimensions.
- Le payload se lit avec l'element format du descriptor, dans l'ordre C-contiguous row-major. Le nombre logique d'éléments calculé doit être égal au nombre d'éléments du payload qui suit le descriptor.

## Validité {#유효성}

- Dès que les version et element format pris en charge sont fixés, on retrouve les limites du payload d'après la largeur de cet élément et l'on vérifie la concordance avec le produit des dimensions du shape, calculé sans overflow.
- Le descriptor, toutes les dimensions et le payload doivent tenir entièrement dans la Length de l'enregistrement ; il n'y a pas de padding ABI arbitraire.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- La règle selon laquelle le shape est une liste de dimensions non négatives et le nombre de valeurs est égal au produit des dimensions, ainsi que le sens du scalar de rank 0 et de la dimension zéro, suivent l'[ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). L'ordre logique C-contiguous row-major s'aligne sur celui de l'[Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- Le rank de 4 bits, les dimensions uint32, les champs version/element-format, le TAG et la Length de GEUL et le payload en WORD big-endian sont un descriptor propre à GEUL. Ce n'est pas la wire ou memory serialization du [format IPC de tenseur d'Arrow](https://arrow.apache.org/docs/format/Other.html), d'ONNX TensorProto ni de l'[API C de DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).

## Length {#길이}

- Le total est le nombre de WORD obtenu en additionnant TAG 1 WORD, TAG d'extension de Length (s'il existe), Issuer 2 WORD, numéro de Codec 2 WORD et Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension est compté dans le total ([Enregistrement et TAG WORD](../../record.md)).
- Le descriptor fait 1 WORD, le shape `2 × rank` WORD, et le reste est le payload.

## Exemple {#예시}

- Pour un profil de rank 2, les 4 WORD après le descriptor sont les deux dimensions uint32, et tout ce qui suit est le payload row-major. Pour savoir si cela est réellement permis et pour vérifier le nombre d'éléments, il faut un profil version/format arrêté.

## Problèmes ouverts {#열린-문제}

- Les valeurs des registres de version et d'element-format, ainsi que l'étendue des profils pris en charge parmi les rank `0..15` représentables, ne sont pas encore fixées.
