---
title: "DENSE-U16-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR est une Value de vector à une dimension qui contient à la suite, sans descriptor, des éléments uint16 big-endian (format d'Issuer ADHOC 0x0501)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR est une Value homogène à une dimension qui stocke à la suite, sans descriptor, des éléments uint16 big-endian.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0501`. Famille NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0501
Payload: [uint16 1er: 1 WORD] ... [uint16 Nème: 1 WORD]
```

## Règles d'interprétation

- Chaque WORD se lit comme un entier unsigned de 16 bits indépendant. Le nombre d'éléments est le nombre de WORD du Payload.
- Il n'y a pas de remplissage ABI entre les éléments ni à la fin.

## Validité

- Le Payload fait au moins 1 WORD. Ce format sans descriptor n'admet pas de vector vide.
- La taille du Payload doit être un multiple entier de la largeur d'élément de 1 WORD.

## Fondement normatif et statut du format

- L'interprétation unsigned du dtype entier non signé et sa largeur de 16 bits suivent les dtype industriels du [tensor element type de l'ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) et de [`DLDataType` de DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- La suite continue à une dimension sans descriptor, le TAG et la Length de GEUL et la disposition en WORD big-endian sont un format propre à GEUL. DLPack suppose que le dtype est en native-endian, donc ce Payload n'est pas la sérialisation wire de DLPack ni d'ONNX.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Length](/fr/grammar/record/)).

## Exemple

- Le Payload `0000 ffff` donne les éléments `[0, 65535]`, enregistrement de 5 WORD au total, de longueur directe `LLLL=0100`.
