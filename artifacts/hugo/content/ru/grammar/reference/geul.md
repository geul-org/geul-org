---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL — Reference-декларация, указывающая на объект по ID сущности, который выдаёт geul.org под CC0."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL — Reference-декларация, указывающая на сущность, выдаваемую geul.org под CC0. Это последовательный ID, номер которого не несёт смысла. Идентификатором со смыслом в битах занимается отдельный Codec [GEUL-SIDX](/ru/grammar/reference/geul-sidx/) (`0011`).

## Раскладка

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length extension TAG]
GEUL ID           unsigned big-endian наименьшей ширины
```

- Малые номера назначаются часто используемым сущностям. ID, помещающийся в 1 WORD, занимает в сумме 2 WORD.
- Назначением ID и реестром управляет geul.org. В реестр попадает только то, что получено из источников CC0.
- Variable — анонимная переменная этого вида ([Reference](/ru/grammar/reference/), Variable).

## Пример

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## Открытые вопросы

- Правила назначения GEUL ID и формат публикации реестра.

## Связанные страницы

- [Reference](/ru/grammar/reference/), [GEUL-SIDX](/ru/grammar/reference/geul-sidx/)
