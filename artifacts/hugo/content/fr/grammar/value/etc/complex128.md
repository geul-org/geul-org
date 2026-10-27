---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 est un format d'Issuer ADHOC fixe de 11 WORD qui contient un nombre complexe par deux composantes binary64, partie réelle et partie imaginaire."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 est une Value qui représente un nombre complexe par deux composantes IEEE 754 binary64 dans l'ordre `(real, imag)`. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0701`, famille NUMERIC.

## Disposition

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interprétation et validité

- Chaque composante est une suite de bits d'interchange binary64 en ordre big-endian des WORD.
- Les motifs de bits, y compris le payload des NaN et le zéro signé, sont conservés tels quels, et il n'y a pas de remplissage ABI.
- Le Payload fait exactement 8 WORD. Tous les motifs de bits d'interchange des deux composantes binary64 sont conservés.

## Fondement normatif et statut du format

- Le fait que `complex128` se compose d'une composante réelle de 64 bits et d'une composante imaginaire de 64 bits suit l'[ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), et l'ordre real en premier est le même que le complex raw-data mapping du [schéma ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) officiel. Le motif de bits de chaque composante suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Les raw data d'ONNX sont en little-endian de largeur fixe, mais ce format emploie le cadrage en WORD big-endian de GEUL : ce n'est donc pas la sérialisation wire d'ONNX TensorProto elle-même.

## Longueur

- Le total est exactement de 11 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 8 WORD, avec la longueur directe `LLLL=1010`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 8 WORD, on rejette.

## Exemple

- Si les deux binary64 du Payload sont `1.0, -0.0`, c'est la valeur de partie réelle 1.0 et de partie imaginaire -0.0.
