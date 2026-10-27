---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 est un format d'Issuer ADHOC fixe de 11 WORD qui contient un quaternion par quatre composantes binary32 dans l'ordre (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 est une Value qui représente un quaternion par quatre composantes IEEE 754 binary32 dans l'ordre `(x, y, z, w)`. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0704`, famille NUMERIC.

## Disposition

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interprétation et validité

- Chaque composante est une suite de bits d'interchange binary32 en ordre big-endian des WORD.
- Le frame, la handedness, la norme unitaire et l'équivalence `q/-q` relèvent du contexte externe et ne font pas partie du sens de ce format.
- Les motifs de bits, y compris le payload des NaN et le zéro signé, sont conservés tels quels, et il n'y a pas de remplissage ABI.
- Le Payload fait exactement 8 WORD. Ce format n'impose ni norme unitaire ni normalisation `q/-q`.

## Fondement normatif et statut du format

- L'ordre `x, y, z, w` est le même que l'ordre des composantes d'un quaternion de la [spécification/registre glTF 2.0](https://registry.khronos.org/glTF/) de Khronos, et chaque composante est un [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- La rotation d'un nœud glTF exige un quaternion unitaire dont W est le scalaire. Ce format étant un quaternion général qui n'impose ni norme unitaire ni sens de rotation, on ne peut pas le tenir pour identique à la rotation glTF tant qu'un profil externe n'ajoute pas cette condition.

## Longueur

- Le total est exactement de 11 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 8 WORD, avec la longueur directe `LLLL=1010`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 8 WORD, on rejette.

## Exemple

- Les composantes `(0.0, 0.0, 0.0, 1.0)` sont une valeur valide qui stocke dans l'ordre les quatre motifs de bits.
