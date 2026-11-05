---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 est une Value qui représente un quaternion par quatre composantes IEEE 754 binary32, dans l'ordre (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


QUATERNION-BINARY32 est une Value qui représente un quaternion par quatre composantes IEEE 754 binary32, dans l'ordre `(x, y, z, w)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000704`, famille NUMERIC.

## Disposition {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interprétation et validité {#해석과-유효성}

- Chaque composante est constituée des interchange bits binary32, en ordre de WORD big-endian.
- Le frame, la handedness, la unit norm et l'équivalence `q/-q` relèvent du contexte externe et ne font pas partie du sens de ce format.
- Le NaN payload et le bit pattern du signed zero sont conservés ; il n'y a pas de padding ABI.
- Le Payload fait exactement 8 WORD. Ce format n'impose ni unit norm ni normalisation `q/-q`.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- L'ordre `x, y, z, w` est celui des composantes de quaternion de la [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) de Khronos, et chaque composante est un [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- La rotation d'un node glTF exige un unit quaternion dont W est le scalar. Ce format est un quaternion général qui n'impose ni unit norm ni sens de rotation ; on ne peut donc pas l'assimiler à la rotation glTF, à moins qu'un profil externe n'ajoute cette condition.

## Length {#길이}

- Le total est de 13 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 8 WORD ; on utilise la longueur directe `LLLL=1100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 8 WORD, on rejette.

## Exemple {#예시}

- Les composantes `(0.0, 0.0, 0.0, 1.0)` forment une valeur valide qui stocke les quatre bit patterns dans l'ordre.
