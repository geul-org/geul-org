---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM -- описательный Edge, который придаёт смысл одному коду сырого значения поля (Codec 0x1D). Имя привязывается через BIND."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM -- описательный Edge, который придаёт смысл одному коду сырого значения поля. Codec `0x1D`.

Вместе с [FIELD](/ru/grammar/edge/field/) это словарь для записи спецификации Codec. Раскладка встроена в декодер ([документ спецификации Codec](/ru/grammar/codec-spec/)).

## Раскладка

```
TAG WORD          0001 0LLL L001 1101
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Поле              запись LOCAL Reference, указывающая на Edge FIELD
Код               сырое значение. Столько же WORD, какова ширина этого FIELD
```

## Интерпретация и допустимость

- Поле должно быть FIELD с сырым значением (ширина `n ≥ 1`). К полю-записи ENUM не прикрепляют. Смысл записи говорит Codec этой записи.
- Код занимает ровно ширину этого FIELD. Границу проверяют по Length записи ENUM.
- В одном поле один и тот же код дважды не объявляют.
- Имя кода привязывают к Edge Id ENUM через [BIND](/ru/grammar/edge/bind/). Любой UTF8-TEXT к DECLARE, FIELD, ENUM и CODEC прикрепляют через BIND, а не через LABEL или другие Edge.
- Необъявленный код -- не ошибка. Просмотрщик показывает его как сырое значение. Закрывать ли допустимые значения, решает спецификация Codec; в нынешнем словаре отметки о закрытии нет.

## Длина

```
всего = 1 + N_len + N_id + N_field + n WORD
```

## Пример (ненормативный)

В поле категории причины (FIELD #4, сырое значение 1 WORD) документа спецификации TOMBSTONE объявляется код `0x0001`. Edge Id 10. Имя привязывается отдельно через BIND. Таблица кодов категорий причин пока не определена, поэтому код -- пример.

- TAG 1 + Edge Id 2 + поле 2 + код 1 = 6 WORD, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

В документе спецификации TRIPLE у поля Rank (FIELD #5) три ENUM (`0`, `1`, `2`), привязанные через BIND к `normal`, `preferred`, `deprecated` ([TRIPLE](/ru/grammar/edge/triple/)).

## Связанные страницы

- [DECLARE](/ru/grammar/edge/declare/), [FIELD](/ru/grammar/edge/field/), [CODEC](/ru/grammar/edge/codec/), [BIND](/ru/grammar/edge/bind/)
- [Документ спецификации Codec](/ru/grammar/codec-spec/)
