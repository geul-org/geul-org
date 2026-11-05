---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 est une Value qui représente un nombre complexe par deux composantes IEEE 754 binary32, dans l'ordre (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


COMPLEX64 est une Value qui représente un nombre complexe par deux composantes IEEE 754 binary32, dans l'ordre `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000700`, famille NUMERIC.

## Disposition {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interprétation et validité {#해석과-유효성}

- Chaque composante est constituée des interchange bits binary32, en ordre de WORD big-endian.
- Le bit pattern, y compris le NaN payload et le signed zero, est conservé tel quel ; il n'y a pas de padding ABI.
- Le Payload fait exactement 4 WORD. Tous les interchange bit patterns des deux composantes binary32 sont conservés.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- Le fait que `complex64` se compose d'une composante réelle de 32 bits et d'une composante imaginaire de 32 bits suit l'[ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), et l'ordre real-first est celui du complex raw-data mapping du [schéma ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) officiel. Le bit pattern de chaque composante suit [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Les raw data d'ONNX sont en little-endian à largeur fixe, mais ce format utilise le framing en WORD big-endian de GEUL ; ce n'est donc pas la wire serialization d'ONNX TensorProto elle-même.

## Length {#길이}

- Le total est de 9 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 4 WORD ; on utilise la longueur directe `LLLL=1000`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 4 WORD, on rejette.

## Exemple {#예시}

- Le Payload `3F80 0000 4000 0000` vaut `1.0 + 2.0i`.
