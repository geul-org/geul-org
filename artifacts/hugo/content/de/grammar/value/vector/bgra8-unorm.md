---
title: "BGRA8-UNORM"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM ist ein Pixel-Value, der vier UNORM8-Komponenten in der Reihenfolge B, G, R, A in einem Payload von 2 WORD enthält (KHRONOS-Issuer-Format 0x0001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM ist ein Value, der die vier UNORM8-Komponenten B, G, R und A gepackt in einem festen Payload von 2 WORD speichert.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0041` KHRONOS, Formatnummer `0x0001`. Familie NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  insgesamt 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
Formatnummer      1 WORD  0x0001
Payload WORD 1st: [B: obere 8 Bit][G: untere 8 Bit]
Payload WORD 2nd: [R: obere 8 Bit][A: untere 8 Bit]
```

## Interpretationsregeln

- Die Byte-Reihenfolge der Serialisierung ist `B, G, R, A`, und der Wert jedes Komponentenbytes `b` ist `b / 255`.
- Das entspricht der Komponentenreihenfolge der Bytes 0~3 und der UNORM-Zahlenabbildung von Vulkan `VK_FORMAT_B8G8R8A8_UNORM`.
- Da es kein `_SRGB`-Format ist, impliziert es weder sRGB noch einen anderen Farbraum oder eine transfer function. Auch alpha ist ein UNORM-Zahlenwert, aber ob straight oder premultiplied und die Compositing-Bedeutung sind äußerer Kontext. Es gibt kein ABI-Padding.

## Gültigkeit

- Alle 8-Bit-Muster sind gültig. Der Payload muss genau 2 WORD haben.

## Normgrundlage und Formatstatus

- Komponenten-Speicherreihenfolge und UNORM-Bedeutung richten sich nach `VK_FORMAT_B8G8R8A8_UNORM` in der [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) und der [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) von Khronos.
- GEUL-TAG/Length und das Framing aus zwei 16-Bit-Big-Endian-WORD sind GEUL-eigene Regeln und definieren nicht die Serialisierung eines Vulkan-Images selbst.

## Länge

- Insgesamt sind es genau 5 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 2 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 2 WORD, wird abgelehnt.

## Beispiel

- Der Payload `0000 ff80` sind die Bytes `B=00, G=00, R=ff, A=80`.
