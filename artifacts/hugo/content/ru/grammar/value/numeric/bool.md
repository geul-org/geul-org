---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL — Value фиксированной длины 2 WORD, хранящий логические значения false и true."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL — Value, представляющий логические значения false и true. Прямой код Value `0x00`, семейство NUMERIC. Это тип, отличный от SIGNED-INTEGER и UNSIGNED-INTEGER, которые хранят числа 0 и 1.

## Раскладка

```
TAG WORD          0x0880 (0000 1000 1000 0000)  всего 2 WORD
Payload           1 WORD  Boolean Code
```

## Интерпретация и допустимость

- Payload `0000` — false, `0001` — true.
- padding и descriptor нет.
- Payload — строго `0000` или `0001`. Любое другое 16-битное значение отвергается как invalid.
- Любое другое представление Length отвергается как invalid.

## Длина

- Общая длина — ровно 2 WORD (TAG 1 WORD и Payload 1 WORD), используется прямая длина `LLLL=0001`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 1 WORD, запись отвергается.

## Примеры

| Вся запись (TAG + Payload) | Payload | Вердикт |
|---|---|---|
| `0880 0000` | `0000` | false, канонично |
| `0880 0001` | `0001` | true, канонично |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG с Length не `0001` + `0000` или `0001` | `0000` или `0001` | invalid |

## Статус формата

- Это представление, объединяющее 16-битные code word `0000`/`0001` с TAG GEUL, — собственный scalar profile GEUL.
- Само логическое значение универсально, но единого отраслевого стандарта, соответствующего этому представлению в 1 WORD, мы не заявляем.
