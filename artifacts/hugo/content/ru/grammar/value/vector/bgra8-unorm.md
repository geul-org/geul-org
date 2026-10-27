---
title: "BGRA8-UNORM"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM — пиксельный Value: четыре компонента UNORM8 в порядке B, G, R, A в Payload из 2 WORD (формат Issuer KHRONOS 0x0001)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM — Value, который упаковывает четыре компонента UNORM8 (B, G, R, A) в фиксированный Payload из 2 WORD.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0041` KHRONOS, номер формата `0x0001`. Семейство NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  всего 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
Номер формата     1 WORD  0x0001
Payload WORD 1st: [B: старшие 8 бит][G: младшие 8 бит]
Payload WORD 2nd: [R: старшие 8 бит][A: младшие 8 бит]
```

## Правила интерпретации

- Порядок байтов при сериализации — `B, G, R, A`; значение каждого байта компонента `b` равно `b / 255`.
- Это соответствует порядку компонентов по байтам 0–3 и числовому отображению UNORM у Vulkan `VK_FORMAT_B8G8R8A8_UNORM`.
- Формат не `_SRGB`, поэтому он не подразумевает ни sRGB, ни другое цветовое пространство или transfer function. Alpha тоже числовой UNORM, но straight или premultiplied и семантика compositing относятся к внешнему контексту. ABI padding нет.

## Допустимость

- Допустим любой 8-битный шаблон. Payload содержит ровно 2 WORD.

## Стандартная основа и статус формата

- Порядок компонентов в памяти и смысл UNORM соответствуют `VK_FORMAT_B8G8R8A8_UNORM` из Khronos [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) и [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html).
- GEUL TAG/Length и framing из двух 16-битных big-endian WORD — собственные правила GEUL; сериализация самого изображения Vulkan не определяется.

## Длина

- Всего ровно 5 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 2 WORD; используется прямая длина `LLLL=0100`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 2 WORD, запись отвергается.

## Пример

- Payload `0000 ff80` — байты `B=00, G=00, R=ff, A=80`.
