---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE -- описательный Edge, содержащий одно высказывание (Predicate, Subject, Object) и его ранг (rank) (Codec 0x0A). Вместо значения в Object можно поставить «неизвестно» (UNKNOWN-VALUE) или «нет» (NO-VALUE)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE -- описательный Edge, содержащий одно высказывание (Predicate, Subject, Object) и его ранг (rank). Codec `0x0A`.

Условия, уточняющие высказывание (время начала и конца, область применения и т. п.), прикрепляют через [QUALIFIER](/ru/grammar/edge/qualifier/), указывающий на Edge Id TRIPLE. Источник (references в Wikidata) прикрепляют через Edge основания [SOURCE](/ru/grammar/edge/source/), указывающий на Edge Id TRIPLE.

## Раскладка

```
TAG WORD          0001 0LLL L000 1010
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Predicate         запись Reference (WIKIDATA-PID и т. п.)
Subject           запись Reference
Object            запись Reference или Value, либо маркер слота 0x0001 UNKNOWN-VALUE, 0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| Код | Название | Смысл |
|---|---|---|
| `0` | normal | По умолчанию |
| `1` | preferred | Текущее, наиболее авторитетное значение |
| `2` | deprecated | Значение, признанное неверным или устаревшим, но оставленное в записи |

- То же, что statement rank в Wikidata. Основное значение (truthy в Wikidata) среди значений с одними Subject и Predicate -- preferred, если он есть, иначе normal.
- Источник, который не ставит rank, использует `0` (normal).
- Остальные коды invalid.

## Интерпретация и допустимость

- Predicate и Subject -- каждая ровно одна полная запись Reference.
- Object -- ровно одна полная запись Reference или Value, либо 1 WORD [маркера слота](/ru/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE), `0x0002` (NO-VALUE). ABSENT (`0x0000`) не принимается. Object не является необязательным полем.
- После чтения Object должен остаться ровно 1 WORD (Rank).
- Документ спецификации geul.org ставит на поле Rank с сырым значением [CODEC](/ru/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) и [ENUM](/ru/grammar/edge/enum/) 0, 1, 2. На поле Object ставятся CODEC `0780` (любой Reference), `0F80` (любой Value), `0001` (UNKNOWN-VALUE), `0002` (NO-VALUE). Predicate и Subject маркеры слота не принимают.
- **Смысл TRIPLE -- совокупность всех QUALIFIER, указывающих на его Edge Id в том же документе.** Перед интерпретацией TRIPLE читающая сторона собирает QUALIFIER. TRIPLE, прочитанный без QUALIFIER, может оказаться высказыванием без уточнений (например, «глава правительства» без временного уточнения).

## Неизвестно и нет

Маркер слота на месте Object -- не значение, а утверждение о высказывании.

| Object | Смысл | Логика |
|---|---|---|
| Значение v | Одно из значений Predicate у Subject равно v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | Значение есть. Какое -- неизвестно (Wikidata `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | Значения нет (Wikidata `novalue`) | `¬∃x. P(s, x)` |
| Нет TRIPLE | Ничего не утверждается (открытый мир) | |

- **Читается внутри уточняющих условий.** Область `∃` и `¬∃` задают QUALIFIER, указывающие на этот TRIPLE. Если QUALIFIER прикреплены, утверждение замыкается только в этой области. «В 1811~1816 годах центрального банка не было» записывается NO-VALUE TRIPLE с QUALIFIER P580 и P582. Это не противоречит TRIPLE значений того же Predicate в другие периоды.
- **Rank применяется так же.** При выборе основного значения (truthy) TRIPLE с UNKNOWN-VALUE и NO-VALUE тоже входят в кандидаты. Если есть preferred, остаётся только preferred.
- **Два UNKNOWN-VALUE не равны.** UNKNOWN-VALUE не равен и не не-равен никакому значению (результат сравнения не определён), и два UNKNOWN-VALUE тоже не считаются одним значением. Каждое вхождение -- независимый квантор существования. Поэтому два побайтно одинаковых TRIPLE с UNKNOWN-VALUE не дубликаты, и их не сливают (детей может быть и двое, и один).
- Если у одних Subject, Predicate и rank одновременно есть NO-VALUE и TRIPLE со значением (или с UNKNOWN-VALUE) без различимых уточняющих условий, это противоречие. Проверяющая сторона предупреждает. Не отвергает (в Wikidata такое состояние тоже бывает).
- Значение, которое не удалось перенести (в первоисточнике оно есть), UNKNOWN-VALUE не записывают.

## Пример (ненормативный)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. TAG -- `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (США) P1304 (центральный банк) NO-VALUE, normal. В 1811~1816 годах центрального банка не было (QUALIFIER P580 и P582 -- в примере [QUALIFIER](/ru/grammar/edge/qualifier/)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. TAG -- `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- «Детей (P40) нет» -- `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Открытые вопросы

- scope (контекст утверждения: мир, точка зрения): определяется, когда появится применение.
- Сокращённая форма, сворачивающая TRIPLE и QUALIFIER в одну запись: после появления объявления повторяющихся полей ([DECLARE](/ru/grammar/edge/declare/), открытые вопросы).

## Связанные страницы

- [Edge](/ru/grammar/edge/), [QUALIFIER](/ru/grammar/edge/qualifier/), [SOURCE](/ru/grammar/edge/source/), [LABEL](/ru/grammar/edge/label/), [ALIAS](/ru/grammar/edge/alias/), [маркер слота](/ru/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/ru/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/)
