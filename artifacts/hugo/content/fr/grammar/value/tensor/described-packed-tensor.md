---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR est un format d'Issuer ADHOC qui remplit en low-bit-first des éléments sub-WORD après un descriptor de packed format, rank et shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR est une Value de tenseur qui écrit le shape et le packed format dans le descriptor du Payload et stocke en packed des éléments plus petits qu'un WORD. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0601`, famille NUMERIC.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0601
Payload WORD 1er  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload suivant   [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload restant   [packed payload octet stream, low-bit-first]
```

## Interprétation

- Le rank étant une valeur de 4 bits du descriptor, structurellement on ne peut exprimer que `0..15`. Chaque dimension est un uint32 big-endian non négatif. L'ordre logique est C-contiguous row-major.
- Comme dans les règles de tenseur logique d'ONNX, un shape `[]` de rank 0 est un scalaire à 1 élément, et si l'une des dimensions est 0, le nombre d'éléments est 0. Sinon, le nombre d'éléments est le produit de toutes les dimensions.
- Le packed-format fixe l'encodage de l'élément et la largeur en bits, comme int2/int4, FP4/FP6 ou certaines variantes de FP8.
- Si l'on note la suite d'octets du payload `p[0], p[1], ...` et qu'on la voit comme l'entier little-bit-endian `P = Σ(p[j] << (8j))`, l'élément logique `i` de largeur `w` est `(P >> (i × w)) & ((1 << w) - 1)`. Autrement dit, on place le premier élément dans les bits les plus bas.
- Dans les WORD, on charge `p[0]` comme octet de poids fort du premier WORD, `p[1]` comme octet de poids faible, et ainsi de suite. Les bits de queue de poids fort inutilisés du dernier octet utilisé doivent être 0 et, si le nombre d'octets du payload est impair, tout l'octet de poids faible inutilisé du dernier WORD doit être `00`.

## Validité

- En appliquant la largeur en bits du format pris en charge, le produit des dimensions du shape calculé sans overflow doit correspondre au nombre d'éléments du payload.
- Si un seul des bits de queue de poids fort ou du remplissage d'octet après les bits de payload nécessaires est à 1, on rejette. Le descriptor, le shape et le payload doivent tenir entièrement dans la Length de l'enregistrement.

## Fondement normatif et statut du format

- Le sens logique du shape, du scalaire de rank 0 et de la dimension zéro suit l'[ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). La règle qui place les éléments sub-byte à partir des bits les plus bas suit le packing int2/int4 du [schéma ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) officiel et le packing little bit-endian de [`DLDataType` de DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- Le rank de 4 bits, les dimensions uint32, les champs version/packed-format, la manière de regrouper les octets en WORD big-endian et le TAG et la Length de GEUL sont un descriptor propre à GEUL. Ce n'est pas la sérialisation wire ou mémoire d'ONNX, d'[Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) ni de DLPack elle-même.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- Le descriptor fait 1 WORD, le shape `2 × rank` WORD, et le reste est le packed payload.
- Si le nombre d'éléments logiques est `N` et la largeur d'élément `w`, le nombre d'octets du payload est `ceil(N × w / 8)` et le nombre de WORD du payload `ceil(nombre d'octets du payload / 2)`.

## Exemple

- Dans un profile de rank 2, les 4 WORD après le descriptor sont le shape, et ce qui suit est la suite d'octets du payload low-bit-first. La largeur d'élément et le fait que ce soit réellement admis se jugent d'après un profile de format fixé.
- La suite d'octets du payload des éléments de 4 bits `[1, 2, 3]` est `21 03` et le WORD du payload est `2103`. Le premier élément est dans le quartet bas du premier octet, et le quartet haut inutilisé du dernier octet est 0.

## Problèmes ouverts

- On n'a pas encore fixé les valeurs du registre de version et de packed-format, ni l'étendue des profiles à prendre en charge parmi les rank `0..15` représentables.
