---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER — Edge-высказывание, прикрепляющее одно условие, уточняющее предложение, содержащееся в другом Edge (в основном TRIPLE)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `QUALIFIER` (BIND документа спецификации `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| Документ спецификации | `0x00000000/codecs/0x00000AB0/` (цель DECLARE `0AB0`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 11 |
| Kind | Edge · семейство: высказывание, группа: предложение |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Одно условие, уточняющее предложение другого Edge. Property, Target (Edge Id), Value (значение либо маркер UNKNOWN-VALUE·NO-VALUE). Часть предложения |
| Сторона Hugo | `edge/qualifier.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id у Edge не объявляется через FIELD.

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | запись | любая запись (кроме маркера места) |  |
| 2 | `target` | #3 | запись | `0050` LOCAL |  |
| 3 | `value` | #4 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference), `060F` весь раздел 3 (шаблон, Value), `080F` весь раздел 4 (шаблон, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER — Edge-высказывание, прикрепляющее одно условие, уточняющее предложение, содержащееся в другом Edge (в основном [TRIPLE](0x0AAL-triple.md)). Codec `0x0ABL`.

Соответствует одному qualifier (snak) Wikidata: одно свойство и одно значение.

## Раскладка {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length, расширяющий TAG]
Edge Id           запись LOCAL Reference
Property          запись Reference (WIKIDATA-PID и т. п.)
Target            запись LOCAL Reference (Edge Id уточняемого Edge)
Value             запись Reference или Value, либо маркер места 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- Порядок компонентов тот же, что у TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Декодер читает их тем же путём. Роли задаёт Codec.

## Интерпретация и действительность {#해석과-유효성}

- Property и Target — ровно одна полная запись Reference, причём Target — LOCAL Reference. В документах спецификации geul.org для Target задан [CODEC](0x0BEL-codec.md) LOCAL (`0050`). Value — ровно одна полная запись Reference или Value либо 1 WORD [маркера места](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) или `0x0020` (NO-VALUE). В документе спецификации для Value заданы CODEC `000F`, `020F`, `040F` (любая Reference), `060F`, `080F` (любое Value), `0010`, `0020`. ABSENT (`0x0000`) не принимается. Property и Target маркеры места не принимают. Курсор после чтения Value должен совпасть с концом Edge.
- Target — Edge Id внутри того же документа. QUALIFIER размещается в том же документе, что и уточняемый Edge.
- Если Target — [SOURCE](0x0C0L-source.md#문서-전체의-출처) в HEAD (первоисточник всего документа), то QUALIFIER тоже размещается в HEAD, после этого SOURCE. Остальные QUALIFIER размещаются в BODY. Если QUALIFIER с Target в виде HEAD SOURCE находится в BODY, это invalid.
- Target может быть не только TRIPLE, но и другим Edge. QUALIFIER, прикреплённый к [SOURCE](0x0C0L-source.md), уточняет акт цитирования (дата обращения, место внутри первоисточника и т. п.). Смысл SOURCE — тоже совокупность всех QUALIFIER, указывающих на него.
- **QUALIFIER — часть предложения.** Это не отдельное утверждение о предложении, а уточнение условий, при которых предложение истинно. Смысл целевого TRIPLE — совокупность всех указывающих на него QUALIFIER.
  - Происхождение предложения записывается как [SOURCE](0x0C0L-source.md). Свойства узла первоисточника (название, автор и т. п.) записываются как TRIPLE с первоисточником в роли Subject.
- Для одного Target может быть несколько QUALIFIER с одним Property. Порядок QUALIFIER с одним Target — это порядок в документе (исключение, при котором порядок Edge имеет смысл).

## Неизвестно и отсутствует {#알-수-없음과-없음}

Если Value в QUALIFIER — маркер места, смысл этого уточнения меняется. В качестве примера возьмём момент окончания (P582).

| Прикреплено к целевому TRIPLE | Смысл | Действует ли предложение сейчас |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Закончилось в 1974 году | Нет |
| `QUALIFIER P582 #n UNKNOWN` | Закончилось. Когда именно, неизвестно (`somevalue` в Wikidata) | Нет |
| `QUALIFIER P582 #n NONE` | Утверждается, что не закончилось (`novalue` в Wikidata) | Да |
| нет QUALIFIER P582 | Неизвестно, закончилось ли (открытый мир) | Неизвестно |

- Если отбросить `somevalue` и `novalue` у qualifier Wikidata, предложение расширяется. TRIPLE границы с отброшенным somevalue момента окончания читался бы как «граница, действующая и сейчас». Поэтому при переносе их записывают как маркеры.
- Два UNKNOWN-VALUE не считаются одним значением. Результат сравнения не определён.

## Пример (не нормативно) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value — [EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Граница (P47) Q30 (США) и Q34266 (Российская империя), момент окончания неизвестен. Edge Id `2060`·`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (раздел 5): Edge, Codec `0x0ABL`, 8 WORD. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + маркер 1.

К TRIPLE `#3161` с NO-VALUE для центрального банка Q30 (P1304) прикрепляется период. Его не было только в 1811~1816 годах.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Связанные страницы {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [маркер места](../slot-marker.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000AB0/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
