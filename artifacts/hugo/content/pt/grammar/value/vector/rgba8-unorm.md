---
title: "RGBA8-UNORM"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM é o Value de pixel que contém quatro componentes UNORM8 na ordem R, G, B, A em 2 WORD de Payload (formato 0x0000 do Issuer KHRONOS)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM é o Value que guarda de forma packed os quatro componentes UNORM8 R, G, B e A em 2 WORD fixas de Payload.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0041` KHRONOS, número de formato `0x0000`. Família NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  total de 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
Número de formato 1 WORD  0x0000
Payload WORD 1st: [R: 8 bits superiores][G: 8 bits inferiores]
Payload WORD 2nd: [B: 8 bits superiores][A: 8 bits inferiores]
```

## Regras de interpretação

- A ordem de bytes serializada é `R, G, B, A`, e o valor de cada byte de componente `b` é `b / 255`.
- Corresponde à ordem dos componentes dos bytes 0 a 3 e ao mapeamento numérico UNORM do `VK_FORMAT_R8G8B8A8_UNORM` do Vulkan.
- Como não é um formato `_SRGB`, não implica sRGB nem outro espaço de cor ou transfer function. O alpha também é um valor UNORM, mas se é straight ou premultiplied e o significado de compositing são contexto externo. Não há ABI padding.

## Validade

- Todos os padrões de 8 bits são válidos. O Payload deve ter exatamente 2 WORD.

## Base normativa e status do formato

- A ordem de memória dos componentes e o significado de UNORM ajustam-se ao `VK_FORMAT_R8G8B8A8_UNORM` do [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) da Khronos e do [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html).
- A TAG/Length do GEUL e o framing de duas WORDs big-endian de 16 bits são regras próprias do GEUL e não definem a serialization da própria imagem Vulkan.

## Comprimento

- O total é exatamente 5 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 2 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 2 WORD, rejeita-se.

## Exemplo

- O Payload `ff00 0080` são os bytes `R=ff, G=00, B=00, A=80`.
