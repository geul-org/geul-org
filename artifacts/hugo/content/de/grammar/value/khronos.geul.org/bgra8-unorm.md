---
title: "BGRA8-UNORM"
weight: 1037
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM ist ein Value, der die vier UNORM8-Komponenten B, G, R, A gepackt in einem festen Payload von 2 WORD ablegt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM ist ein Value, der die vier UNORM8-Komponenten B, G, R, A gepackt in einem festen Payload von 2 WORD ablegt.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000E` KHRONOS, Codec-Nummer `0x00000001`. Familie NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  insgesamt 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
Codec-Nummer      2 WORD  0x00000001
Payload WORD 1st: [B: obere 8bit][G: untere 8bit]
Payload WORD 2nd: [R: obere 8bit][A: untere 8bit]
```

## Interpretationsregeln {#해석-규칙}

- Die serialisierte Byte-Reihenfolge ist `B, G, R, A`, und der Wert jedes Komponenten-Bytes `b` ist `b / 255`.
- Das entspricht der Komponentenreihenfolge der Bytes 0 bis 3 und dem UNORM-Zahlen-Mapping von Vulkan `VK_FORMAT_B8G8R8A8_UNORM`.
- Da es kein `_SRGB`-Format ist, wird weder sRGB noch ein anderer Farbraum bzw. eine Transfer Function impliziert. Auch Alpha ist ein UNORM-Zahlenwert, doch ob es straight oder premultiplied ist und die Compositing-Bedeutung sind externer Kontext. Es gibt kein ABI-Padding.

## Gültigkeit {#유효성}

- Alle 8-Bit-Muster sind gültig. Der Payload muss genau 2 WORD umfassen.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Komponenten-Speicherreihenfolge und UNORM-Bedeutung richten sich nach `VK_FORMAT_B8G8R8A8_UNORM` in der [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) und der [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) von Khronos.
- GEUL-TAG/Length und das Framing in zwei 16-Bit-Big-Endian-WORD sind GEUL-eigene Regeln und definieren nicht die Serialisierung eines Vulkan-Images selbst.

## Länge {#길이}

- Die Gesamtlänge ist genau 7 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 2 WORD Payload; verwendet wird die direkte Länge `LLLL=0110`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 2 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Der Payload `0000 FF80` enthält die Bytes `B=00, G=00, R=FF, A=80`.
