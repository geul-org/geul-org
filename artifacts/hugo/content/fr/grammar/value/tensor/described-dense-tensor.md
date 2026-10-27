---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR est un format d'Issuer ADHOC qui contient, après un descriptor d'element format, rank et shape, des éléments C-contiguous row-major."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR est une Value de tenseur qui écrit le shape et l'element format dans le descriptor du Payload et stocke un payload C-contiguous row-major. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0600`, famille NUMERIC.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0600
Payload WORD 1er  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload suivant   [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload restant   [dense payload]
```

## Interprétation

- Le rank étant une valeur de 4 bits du descriptor, structurellement on ne peut exprimer que `0..15`. Chaque dimension est un uint32 big-endian non négatif.
- Comme dans les règles de tenseur logique d'ONNX, un shape `[]` de rank 0 est un scalaire à 1 élément, et si l'une des dimensions est 0, le nombre d'éléments est 0. Sinon, le nombre d'éléments est le produit de toutes les dimensions.
- Le payload se lit avec l'element format du descriptor, dans l'ordre C-contiguous row-major. Le nombre d'éléments logiques calculé doit être égal au nombre d'éléments du payload après le descriptor.

## Validité

- Une fois fixés la version et l'element format pris en charge, on restitue les limites du payload avec la largeur de cet élément et l'on vérifie qu'elles correspondent au produit du shape calculé sans overflow.
- Le descriptor, toutes les dimensions et le payload doivent tenir entièrement dans la Length de l'enregistrement, sans remplissage ABI arbitraire.

## Fondement normatif et statut du format

- La règle selon laquelle le shape est une liste de dimensions non négatives et le nombre de valeurs est égal au produit des dimensions, ainsi que le sens du scalaire de rank 0 et de la dimension zéro, suivent l'[ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). L'ordre logique C-contiguous row-major s'aligne sur l'ordre de l'[Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- Le rank de 4 bits, les dimensions uint32, les champs version/element-format, le TAG et la Length de GEUL et le payload en WORD big-endian sont un descriptor propre à GEUL. Ce n'est pas la sérialisation wire ou mémoire du [format IPC de tenseur d'Arrow](https://arrow.apache.org/docs/format/Other.html), d'ONNX TensorProto ni de l'[API C de DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- Le descriptor fait 1 WORD, le shape `2 × rank` WORD, et le reste est le payload.

## Exemple

- Dans un profile de rank 2, les 4 WORD après le descriptor sont les deux dimensions uint32, et tout ce qui suit est le payload row-major. Pour savoir si c'est réellement admis et vérifier le nombre d'éléments, il faut un profile de version et de format fixé.

## Problèmes ouverts

- On n'a pas encore fixé les valeurs du registre de version et d'element-format, ni l'étendue des profiles à prendre en charge parmi les rank `0..15` représentables.
