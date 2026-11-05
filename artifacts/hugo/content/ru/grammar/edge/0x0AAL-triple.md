---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE — Edge-высказывание, содержащее одно предложение (Predicate, Subject, Object) и его ранг (rank)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `TRIPLE` (BIND документа спецификации `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| Документ спецификации | `0x00000000/codecs/0x00000AA0/` (цель DECLARE `0AA0`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 10 |
| Kind | Edge · семейство: высказывание, группа: предложение |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Предложение в порядке Predicate, Subject, Object и rank. Object — значение либо маркер UNKNOWN-VALUE·NO-VALUE. Смысл — это совокупность всех QUALIFIER, указывающих на его Edge Id |
| Сторона Hugo | `edge/triple.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id у Edge не объявляется через FIELD.

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference) |  |
| 2 | `subject` | #3 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference) |  |
| 3 | `object` | #4 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference), `060F` весь раздел 3 (шаблон, Value), `080F` весь раздел 4 (шаблон, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |
| 4 | `rank` | #5 | простое значение 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE — Edge-высказывание, содержащее одно предложение (Predicate, Subject, Object) и его ранг (rank). Codec `0x0AAL`.

Условия, уточняющие предложение (момент начала и окончания, область применения и т. п.), прикрепляются через [QUALIFIER](0x0ABL-qualifier.md), указывающий на Edge Id TRIPLE. Происхождение (references в Wikidata) прикрепляется через Edge основания [SOURCE](0x0C0L-source.md), указывающий на Edge Id TRIPLE.

## Раскладка {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length, расширяющий TAG]
Edge Id           запись LOCAL Reference
Predicate         запись Reference (WIKIDATA-PID и т. п.)
Subject           запись Reference
Object            запись Reference или Value, либо маркер места 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| Код | Имя | Смысл |
|---|---|---|
| `0` | normal | по умолчанию |
| `1` | preferred | текущее значение, наиболее авторитетное значение |
| `2` | deprecated | значение, признанное ошибочным или устаревшим, но оставленное как запись |

- Совпадает с рангом утверждения (statement rank) Wikidata. Представительное значение (truthy в Wikidata) среди записей с одним Subject и Predicate — preferred, если он есть, иначе normal.
- Для источников, не ставящих rank, используется `0` (normal).
- Остальные коды invalid.

## Интерпретация и действительность {#해석과-유효성}

- Predicate и Subject — ровно одна полная запись Reference.
- Object — ровно одна полная запись Reference или Value либо 1 WORD [маркера места](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) или `0x0020` (NO-VALUE). ABSENT (`0x0000`) не принимается. Object не является необязательным полем.
- После чтения Object должен остаться ровно 1 WORD (Rank).
- В документах спецификации geul.org для поля простого значения Rank заданы [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) и [ENUM](0x0BDL-enum.md) 0·1·2. Для поля Object заданы CODEC `000F`·`020F`·`040F` (любая Reference), `060F`·`080F` (любое Value), `0010` (UNKNOWN-VALUE), `0020` (NO-VALUE). Для полей Predicate и Subject заданы CODEC `000F`·`020F`·`040F` (любая Reference). Это шаблоны, поэтому маркеры места не принимаются.
- **Смысл TRIPLE — это совокупность всех QUALIFIER, указывающих на его Edge Id в том же документе.** Перед интерпретацией TRIPLE читающая сторона собирает QUALIFIER. TRIPLE, прочитанный без QUALIFIER, может быть предложением без уточнения (например, «глава исполнительной власти» без указания времени).

## Неизвестно и отсутствует {#알-수-없음과-없음}

Маркер места на позиции Object — не значение, а утверждение о предложении.

| Object | Смысл | Логика |
|---|---|---|
| значение v | Одно из значений Predicate для Subject — v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | Значение есть. Какое именно, неизвестно (`somevalue` в Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | Значения нет (`novalue` в Wikidata) | `¬∃x. P(s, x)` |
| нет TRIPLE | Ничего не утверждается (открытый мир) | |

- **Читается внутри уточняющих условий.** Область `∃` и `¬∃` задают QUALIFIER, указывающие на этот TRIPLE. Если QUALIFIER прикреплены, утверждение замыкается только в этой области. «В 1811~1816 годах центрального банка не было» записывается как TRIPLE с NO-VALUE и QUALIFIER P580·P582. Это не противоречит TRIPLE со значениями того же Predicate в другие периоды.
- **rank применяется так же.** При выборе представительного значения (truthy) TRIPLE с UNKNOWN-VALUE·NO-VALUE тоже входят в кандидаты. Если есть preferred, остаётся только preferred.
- **Два UNKNOWN-VALUE не равны друг другу.** UNKNOWN-VALUE не равен и не не-равен никакому значению (результат сравнения не определён), и два UNKNOWN-VALUE между собой тоже не считаются одним значением. Каждое появление — независимая квантификация существования. Поэтому два TRIPLE с UNKNOWN-VALUE, совпадающие по байтам, не являются дубликатами и не сливаются (детей может быть и двое, и один).
- Если для одного Subject·Predicate·rank TRIPLE с NO-VALUE и TRIPLE со значением (или UNKNOWN-VALUE) присутствуют вместе без различимых уточняющих условий, это противоречие. Проверяющий предупреждает, но не отклоняет (такое состояние есть и в Wikidata).
- Значение, которое не удалось перенести (в первоисточнике значение есть), как UNKNOWN-VALUE не записывается.

## Пример (не нормативно) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. TAG — `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (США) P1304 (центральный банк) NO-VALUE, normal. В 1811~1816 годах центрального банка не было (QUALIFIER P580·P582 — в примере [QUALIFIER](0x0ABL-qualifier.md)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. TAG — `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- «Нет детей (P40)» — это `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Открытые проблемы {#열린-문제}

- scope (контекст утверждения: мир, точка зрения): определяется, когда появится применение.
- Сокращённая форма, сворачивающая TRIPLE и QUALIFIER в одну запись: после появления объявления повторяющихся полей (открытые проблемы [DECLARE](0x0BBL-declare.md)).

## Связанные страницы {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [маркер места](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000AA0/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
