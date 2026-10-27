---
title: "RGBA8-UNORM"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM est une Value de pixel qui contient dans un Payload de 2 WORD quatre composantes UNORM8 dans l'ordre R, G, B, A (format d'Issuer KHRONOS 0x0000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM est une Value qui stocke en packed, dans un Payload fixe de 2 WORD, quatre composantes UNORM8 R, G, B, A.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0041` KHRONOS, numéro de format `0x0000`. Famille NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD au total
Issuer            1 WORD  0x0041 (KHRONOS)
Numéro de format  1 WORD  0x0000
Payload WORD 1er: [R: 8 bits de poids fort][G: 8 bits de poids faible]
Payload WORD 2ème: [B: 8 bits de poids fort][A: 8 bits de poids faible]
```

## Règles d'interprétation

- L'ordre des octets sérialisés est `R, G, B, A`, et la valeur de chaque octet de composante `b` est `b / 255`.
- Cela correspond à l'ordre des composantes des octets 0 à 3 et à la correspondance numérique UNORM de `VK_FORMAT_R8G8B8A8_UNORM` de Vulkan.
- Ce n'est pas un format `_SRGB`, donc il n'implique ni sRGB ni un autre espace colorimétrique ou fonction de transfert. L'alpha est lui aussi une valeur numérique UNORM, mais le caractère straight/premultiplied et le sens de compositing relèvent du contexte externe. Il n'y a pas de remplissage ABI.

## Validité

- Tous les motifs de 8 bits sont valides. Le Payload doit faire exactement 2 WORD.

## Fondement normatif et statut du format

- L'ordre des composantes en mémoire et le sens d'UNORM sont alignés sur `VK_FORMAT_R8G8B8A8_UNORM` de la [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) de Khronos et du [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html).
- Le TAG et la Length de GEUL et le cadrage en deux WORD big-endian de 16 bits sont des règles propres à GEUL, et ne définissent pas la sérialisation d'une image Vulkan elle-même.

## Longueur

- Le total est exactement de 5 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 2 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 2 WORD, on rejette.

## Exemple

- Le Payload `ff00 0080` est les octets `R=ff, G=00, B=00, A=80`.
