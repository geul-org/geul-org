---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER — описательный Edge, который прикрепляет одно условие, уточняющее высказывание другого Edge (главным образом TRIPLE) (Codec 0x0B). Вместо значения в Value можно поставить «неизвестно» (UNKNOWN-VALUE) или «нет» (NO-VALUE)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER — описательный Edge, который прикрепляет одно условие, уточняющее высказывание, содержащееся в другом Edge (главным образом в [TRIPLE](/ru/grammar/edge/triple/)). Codec `0x0B`.

Он равен одному qualifier (snak) в Wikidata: одно свойство и одно значение.

## Раскладка

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           запись LOCAL Reference
Property          запись Reference (WIKIDATA-PID и т. п.)
Target            запись LOCAL Reference (Edge Id уточняемого Edge)
Value             запись Reference или Value, либо маркер слота 0x0001 UNKNOWN-VALUE, 0x0002 NO-VALUE
```

- Порядок компонентов такой же, как у TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Декодер читает по тому же пути. Роли задаёт Codec.

## Интерпретация и допустимость

- Property и Target — каждая ровно одна полная запись Reference, а Target — LOCAL Reference. Документ спецификации geul.org ставит на Target [CODEC](/ru/grammar/edge/codec/) LOCAL (`0008`). Value — ровно одна полная запись Reference или Value, либо 1 WORD [маркера слота](/ru/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE), `0x0002` (NO-VALUE). Для Value документ спецификации ставит CODEC `0780`, `0F80`, `0001`, `0002`. ABSENT (`0x0000`) не принимается. Property и Target маркеры слота не принимают. Позиция после чтения Value должна совпасть с концом Edge.
- Target — Edge Id внутри того же документа. QUALIFIER помещают в тот же документ, что и уточняемый Edge.
- Если Target — [SOURCE](/ru/grammar/edge/source/#источник-всего-документа) в HEAD (первоисточник всего документа), то QUALIFIER тоже помещается в HEAD, после этого SOURCE. Остальные QUALIFIER помещаются в BODY. QUALIFIER, у которого Target — HEAD SOURCE, в BODY — invalid.
- Target может быть не только TRIPLE, но и другим Edge. QUALIFIER, прикреплённый к [SOURCE](/ru/grammar/edge/source/), уточняет акт цитирования (дату обращения, место внутри первоисточника и т. п.). Смысл SOURCE тоже есть совокупность всех QUALIFIER, указывающих на него.
- **QUALIFIER — часть высказывания.** Это не отдельное утверждение о высказывании, а уточнение условия, при котором оно истинно. Смысл целевого TRIPLE — совокупность всех QUALIFIER, указывающих на него.
  - Источник высказывания записывают как [SOURCE](/ru/grammar/edge/source/). Свойства узла первоисточника (название, автор и т. п.) записывают как TRIPLE с первоисточником в роли Subject.
- К одному Target можно прикрепить несколько QUALIFIER с одним Property. Порядок QUALIFIER с одним Target — порядок в документе (исключение, когда порядок Edge несёт смысл).

## Неизвестно и нет

Если Value в QUALIFIER — маркер слота, смысл уточнения меняется. Возьмём время окончания (P582).

| Прикреплено к целевому TRIPLE | Смысл | Остаётся ли высказывание действительным сейчас |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Закончилось в 1974 году | Нет |
| `QUALIFIER P582 #n UNKNOWN` | Закончилось. Когда — неизвестно (Wikidata `somevalue`) | Нет |
| `QUALIFIER P582 #n NONE` | Утверждается, что не закончилось (Wikidata `novalue`) | Да |
| Нет QUALIFIER P582 | Неизвестно, закончилось ли (открытый мир) | Неизвестно |

- Если отбросить `somevalue` и `novalue` у qualifier Wikidata, высказывание расширяется. TRIPLE границы без somevalue времени окончания читается как «граница, действующая и сейчас». Поэтому при переносе их переносят маркером.
- Два UNKNOWN-VALUE не считаются одним и тем же значением. Результат сравнения не определён.

## Пример (ненормативный)

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value — [EDTF](/ru/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Граница (P47) между Q30 (США) и Q34266 (Российская империя), время окончания неизвестно. Edge Id `2060` и `3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge, 8 WORD, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + маркер 1.

К TRIPLE `#3161` с NO-VALUE о центральном банке Q30 (P1304) прикрепляется период. Центрального банка не было только в 1811~1816 годах.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Связанные страницы

- [Edge](/ru/grammar/edge/), [TRIPLE](/ru/grammar/edge/triple/), [SOURCE](/ru/grammar/edge/source/), [WIKIDATA-PID](/ru/grammar/reference/wikidata-pid/), [EDTF](/ru/grammar/value/time/edtf/), [маркер слота](/ru/grammar/reference/slot-marker/)
