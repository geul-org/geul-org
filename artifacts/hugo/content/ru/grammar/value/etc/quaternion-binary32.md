---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 — формат Issuer ADHOC фиксированной длины 11 WORD для кватерниона из четырёх компонентов binary32 в порядке (x, y, z, w)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 — Value, представляющий кватернион четырьмя компонентами IEEE 754 binary32 в порядке `(x, y, z, w)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0704`, семейство NUMERIC.

## Раскладка

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  всего 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Интерпретация и допустимость

- Каждый компонент — interchange-биты binary32 в порядке big-endian WORD.
- Frame, handedness, unit norm и эквивалентность `q/-q` относятся к внешнему контексту и в смысл этого формата не входят.
- Битовые шаблоны NaN payload и signed zero сохраняются; ABI padding нет.
- Payload содержит ровно 8 WORD. Формат не требует ни unit norm, ни нормализации `q/-q`.

## Стандартная основа и статус формата

- Порядок `x, y, z, w` совпадает с порядком компонентов кватерниона в Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/); каждый компонент — [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Вращение узла (node rotation) в glTF требует unit quaternion, где W — скаляр. Этот формат — обобщённый кватернион, не навязывающий ни unit norm, ни смысл вращения, поэтому без дополнительного внешнего profile, добавляющего это условие, его нельзя считать равным вращению glTF.

## Длина

- Всего ровно 11 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 8 WORD; используется прямая длина `LLLL=1010`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, запись отвергается.

## Пример

- Компоненты `(0.0, 0.0, 0.0, 1.0)` — допустимое значение, в котором четыре битовых шаблона сохранены по порядку.
