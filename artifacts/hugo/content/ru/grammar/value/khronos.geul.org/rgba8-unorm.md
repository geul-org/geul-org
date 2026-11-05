---
title: "RGBA8-UNORM"
weight: 1038
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM — Value, в котором четыре компоненты UNORM8 — R, G, B, A — упакованы в фиксированный Payload из 2 WORD."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM — Value, в котором четыре компоненты UNORM8 — R, G, B, A — упакованы в фиксированный Payload из 2 WORD.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000E` KHRONOS, номер Codec `0x00000000`. Семейство NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  всего 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
Номер Codec       2 WORD  0x00000000
Payload WORD 1st: [R: старшие 8bit][G: младшие 8bit]
Payload WORD 2nd: [B: старшие 8bit][A: младшие 8bit]
```

## Правила интерпретации {#해석-규칙}

- Порядок байт при сериализации — `R, G, B, A`, значение байта компоненты `b` равно `b / 255`.
- Это соответствует порядку компонент byte 0~3 и числовому отображению UNORM формата Vulkan `VK_FORMAT_R8G8B8A8_UNORM`.
- Это не формат `_SRGB`, поэтому sRGB или иное цветовое пространство и transfer function не подразумеваются. Alpha тоже числовое значение UNORM, но straight или premultiplied и смысл compositing определяются внешним контекстом. ABI-заполнения нет.

## Действительность {#유효성}

- Допустим любой 8-битный pattern. Payload должен составлять ровно 2 WORD.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Порядок компонент в памяти и смысл UNORM согласованы с `VK_FORMAT_R8G8B8A8_UNORM` в Khronos [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) и [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html).
- TAG/Length GEUL и framing в два 16-битных big-endian WORD — собственные правила GEUL; сериализация самого изображения Vulkan не определяется.

## Длина {#길이}

- Общая длина — ровно 7 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 2 WORD; используется прямая длина `LLLL=0110`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Пример {#예시}

- Payload `FF00 0080` — это байты `R=FF, G=00, B=00, A=80`.
