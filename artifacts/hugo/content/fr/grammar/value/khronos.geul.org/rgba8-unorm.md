---
title: "RGBA8-UNORM"
weight: 1038
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM est une Value qui stocke en packed quatre composantes UNORM8, R, G, B et A, dans un Payload fixe de 2 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


RGBA8-UNORM est une Value qui stocke en packed quatre composantes UNORM8, R, G, B et A, dans un Payload fixe de 2 WORD.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000E` KHRONOS, numéro de Codec `0x00000000`. Famille NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD au total
Issuer            2 WORD  0x0000000E (KHRONOS)
Numéro de Codec   2 WORD  0x00000000
Payload WORD 1er: [R: 8 bits hauts][G: 8 bits bas]
Payload WORD 2ème: [B: 8 bits hauts][A: 8 bits bas]
```

## Règles d'interprétation {#해석-규칙}

- L'ordre des octets sérialisés est `R, G, B, A`, et la valeur de l'octet `b` de chaque composante est `b / 255`.
- Cela correspond à l'ordre des composantes des octets 0 à 3 de Vulkan `VK_FORMAT_R8G8B8A8_UNORM` et à son mapping numérique UNORM.
- Ce n'est pas un format `_SRGB` ; il n'implique donc ni sRGB ni aucun autre espace colorimétrique ou transfer function. L'alpha est lui aussi une valeur UNORM, mais le caractère straight/premultiplied et la sémantique de compositing relèvent du contexte externe. Il n'y a pas de padding ABI.

## Validité {#유효성}

- Tous les motifs de 8 bits sont valides. Le Payload doit faire exactement 2 WORD.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- L'ordre mémoire des composantes et le sens d'UNORM s'alignent sur `VK_FORMAT_R8G8B8A8_UNORM` de la [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) et du [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) de Khronos.
- Le TAG et la Length de GEUL et le framing en deux WORD big-endian de 16 bits sont des règles propres à GEUL ; elles ne définissent pas la serialization d'une image Vulkan elle-même.

## Length {#길이}

- Le total est de 7 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 2 WORD ; on utilise la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 2 WORD, on rejette.

## Exemple {#예시}

- Le Payload `FF00 0080` correspond aux octets `R=FF, G=00, B=00, A=80`.
