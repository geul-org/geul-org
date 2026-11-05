---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 — Value, представляющее quaternion четырьмя компонентами IEEE 754 binary32 в порядке (x, y, z, w)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 — Value, представляющее quaternion четырьмя компонентами IEEE 754 binary32 в порядке `(x, y, z, w)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000704`, семейство NUMERIC.

## Раскладка {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  всего 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Интерпретация и действительность {#해석과-유효성}

- Каждая компонента — interchange bits binary32 в порядке big-endian WORD.
- Frame, handedness, unit norm и эквивалентность `q/-q` определяются внешним контекстом и в смысл этого формата не входят.
- Сохраняются NaN payload и битовый образ знакового нуля; ABI-заполнения нет.
- Payload составляет ровно 8 WORD. Этот формат не требует ни unit norm, ни нормализации `q/-q`.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Порядок `x, y, z, w` совпадает с порядком компонент quaternion в Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/), а каждая компонента — [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Для node rotation в glTF требуется unit quaternion, где W — scalar. Этот формат — общий quaternion, не требующий ни unit norm, ни смысла поворота, поэтому его нельзя считать равным rotation в glTF, пока внешний profile не добавит это условие.

## Длина {#길이}

- Общая длина — ровно 13 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 8 WORD; используется прямая длина `LLLL=1100`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Пример {#예시}

- Компоненты `(0.0, 0.0, 0.0, 1.0)` — действительное значение, в котором четыре битовых образа сохранены по порядку.
