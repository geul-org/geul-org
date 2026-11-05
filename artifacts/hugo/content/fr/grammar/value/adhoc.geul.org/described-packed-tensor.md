---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR est une Value de tenseur qui décrit le shape et le packed format dans le descriptor du Payload, puis stocke en packed des éléments plus petits qu'un WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


DESCRIBED-PACKED-TENSOR est une Value de tenseur qui décrit le shape et le packed format dans le descriptor du Payload, puis stocke en packed des éléments plus petits qu'un WORD. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000601`, famille NUMERIC.

## Disposition {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG d'extension de Length] si 15 WORD ou plus au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000601
Payload WORD 1er  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload suivants  [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload reste     [packed payload octet stream, low-bit-first]
```

## Interprétation {#해석}

- Le rank étant une valeur de 4 bits dans le descriptor, il ne peut structurellement représenter que `0..15`. Chaque dimension est un uint32 big-endian non négatif. L'ordre logique est C-contiguous row-major.
- Comme dans les règles de tensor logique d'ONNX, le shape de rank 0 `[]` est un scalar d'un seul élément, et si l'une des dimensions vaut 0, le nombre d'éléments est 0. Sinon, le nombre d'éléments est le produit de toutes les dimensions.
- Le packed-format fixe l'encodage de l'élément et sa largeur en bits, comme int2/int4, FP4/FP6 ou certains variants de FP8.
- Soit `p[0], p[1], ...` la séquence d'octets du payload ; en la considérant comme l'entier little-bit-endian `P = Σ(p[j] << (8j))`, l'élément logique `i` de largeur `w` vaut `(P >> (i × w)) & ((1 << w) - 1)`. Autrement dit, on place le premier élément dans les bits les plus bas.
- Dans les WORD, `p[0]` occupe l'octet de poids fort du premier WORD, `p[1]` l'octet de poids faible, et ainsi de suite. Les tail bits hauts inutilisés du dernier octet utilisé doivent valoir 0 ; si le nombre d'octets du payload est impair, tout l'octet de poids faible inutilisé du dernier WORD doit valoir `00`.

## Validité {#유효성}

- En appliquant la largeur en bits du format pris en charge, le produit des dimensions du shape, calculé sans overflow, doit correspondre au nombre d'éléments du payload.
- Si un seul des high tail bits ou des bits de padding d'octet situés après les bits de payload nécessaires vaut 1, on rejette. Le descriptor, le shape et le payload doivent tenir entièrement dans la Length de l'enregistrement.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- Le sens logique du shape, du scalar de rank 0 et de la dimension zéro suit l'[ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). La règle consistant à placer les éléments sub-byte à partir des bits bas suit le packing int2/int4 du [schéma ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) officiel et le packing little bit-endian de [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Le rank de 4 bits, les dimensions uint32, les champs version/packed-format, la manière de regrouper les octets en WORD big-endian et le TAG et la Length de GEUL sont un descriptor propre à GEUL. Ce n'est pas la wire ou memory serialization d'ONNX, d'[Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) ni de DLPack elle-même.

## Length {#길이}

- Le total est le nombre de WORD obtenu en additionnant TAG 1 WORD, TAG d'extension de Length (s'il existe), Issuer 2 WORD, numéro de Codec 2 WORD et Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension est compté dans le total ([Enregistrement et TAG WORD](../../record.md)).
- Le descriptor fait 1 WORD, le shape `2 × rank` WORD, et le reste est le packed payload.
- Si le nombre logique d'éléments est `N` et la largeur d'élément `w`, le nombre d'octets du payload est `ceil(N × w / 8)` et le nombre de WORD du payload est `ceil(nombre d'octets du payload / 2)`.

## Exemple {#예시}

- Pour un profil de rank 2, les 4 WORD après le descriptor forment le shape, suivi de la séquence d'octets du payload low-bit-first. La largeur d'élément et le caractère réellement permis se jugent d'après le profil de format arrêté.
- Pour les éléments de 4 bits `[1, 2, 3]`, la séquence d'octets du payload est `21 03` et le WORD du payload est `2103`. Le premier élément se trouve dans le nibble bas du premier octet, et le nibble haut inutilisé du dernier octet vaut 0.

## Problèmes ouverts {#열린-문제}

- Les valeurs des registres de version et de packed-format, ainsi que l'étendue des profils pris en charge parmi les rank `0..15` représentables, ne sont pas encore fixées.
