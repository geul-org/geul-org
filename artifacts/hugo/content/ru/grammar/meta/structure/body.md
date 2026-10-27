---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY — это структурная Meta в 1 WORD, которая завершает HEAD документа и начинает BODY."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Запись, которая завершает HEAD и начинает BODY.

## Раскладка

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length extension TAG]
```

- Codec: Meta `0x0E`, класс структуры (`000`)
- Payload: нет (1 WORD)
- Количество: не более одного на документ

## Интерпретация и валидность

- Если HEAD пуст, опускается. Документ без `BODY` целиком является BODY. Если в HEAD есть Meta или HEAD Edge ([SOURCE](/ru/grammar/edge/source/#источник-всего-документа) всего документа и его QUALIFIER), `BODY` ставится.
- Payload нет. Всего 1 WORD.

## Пример

- `0x180E`
