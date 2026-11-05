---
title: "BGRA8-UNORM"
weight: 1037
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM é um Value que armazena de forma packed os quatro componentes UNORM8 B, G, R, A em 2 WORD fixos de Payload."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM é um Value que armazena de forma packed os quatro componentes UNORM8 B, G, R, A em 2 WORD fixos de Payload.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000E` KHRONOS, número do Codec `0x00000001`. Família NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total de 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
Número do Codec   2 WORD  0x00000001
Payload WORD 1st: [B: 8bit superiores][G: 8bit inferiores]
Payload WORD 2nd: [R: 8bit superiores][A: 8bit inferiores]
```

## Regras de interpretação {#해석-규칙}

- A ordem dos bytes serializados é `B, G, R, A` e o valor de cada byte de componente `b` é `b / 255`.
- Isto corresponde à ordem dos componentes dos bytes 0~3 e ao mapeamento numérico UNORM do `VK_FORMAT_B8G8R8A8_UNORM` do Vulkan.
- Como não é um formato `_SRGB`, não implica sRGB nem outro espaço de cor ou transfer function. O alpha também é um valor numérico UNORM, mas se é straight/premultiplied e o significado do compositing são contexto externo. Não há ABI padding.

## Validade {#유효성}

- Todos os padrões de 8 bits são válidos. O Payload deve ter exatamente 2 WORD.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- A component memory order e o significado de UNORM seguem o `VK_FORMAT_B8G8R8A8_UNORM` da [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) e do [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) da Khronos.
- A TAG/Length do GEUL e o enquadramento em dois WORD big-endian de 16 bits são regras próprias do GEUL e não definem a serialização da própria imagem Vulkan.

## Comprimento {#길이}

- O total é exatamente 7 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 2 WORD, e usa-se o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 2 WORD, rejeita-se.

## Exemplo {#예시}

- O Payload `0000 FF80` corresponde aos bytes `B=00, G=00, R=FF, A=80`.
