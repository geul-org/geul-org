---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge — запись, которая описывает утверждение, связывая другие записи как компоненты."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge — запись, которая описывает утверждение, связывая другие записи как компоненты. Утверждения вроде «Q42 — человек» или «Английское имя Q42 — Douglas Adams» — это по одному Edge.

## Раскладка {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      разделы 5~13 (0x0A0L~0x1BFL)
[Length, расширяющий TAG]
[Codec, расширяющий TAG]  в формате Issuer
Edge Id           запись LOCAL Reference
компоненты        в порядке, заданном Codec
```

- `LLLL` — число всех WORD, включая TAG WORD, минус 1. Декодер переходит к следующей записи по одному лишь Length, не зная Codec.
- **Первый компонент всегда Edge Id (LOCAL Reference).** Это LOCAL Reference (`0051` + ID, Identified `0x005L`), поэтому Edge Id читается без знания Codec.
- Каждый компонент находит свою границу по собственному Length. Позиция после чтения последнего компонента должна точно совпадать с концом Edge.
- Состав компонентов (Payload) задаёт документ каждого Edge Codec.
- Codec с подформатами (WORLD, TIMELINE, SCENE) указывает подформат одним TAG из 1 WORD для данного Codec.
- Порядок между записями Edge значения не имеет (кроме случаев, когда его отдельно задаёт Codec. Например, документ [TOULMIN](../toulmin/_index.md)).
- На другие Edge ссылаются через Edge Id. Edge этого документа — через LOCAL, Edge другого документа — через указывающие Reference (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Семейства {#계열}

Область Edge — `0x0A0L~0x1BFL`. Семейство прямого кода — `(код − 0xA0) >> 5` (код — первые три цифры TAG ID). Семейства идут по 32 позиции и равны значению раздела `w >> 9` минус 5. Edge занимает разделы 5~13.

| Раздел | Семейство | Прямой код | Назначение |
|---|---|---|---|
| 5 | высказывание | `0x0A0L~0x0BFL` | Строит содержание о мире и событиях |
| 6 | основание | `0x0C0L~0x0DFL` | Откуда взяты записи и документы ([SOURCE](0x0C0L-source.md)) |
| 7 | исполнение | `0x0E0L~0x0FFL` | Исполняемая структура программы (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | Граф аргументации: утверждения, возражения, исключения, отношения атаки, исполнение, результаты вердикта |
| 9 | формат [TOULMIN](../toulmin/_index.md) | `0x120L~0x134L` | Исходный текст, членение, вспомогательные узлы документа TOULMIN и их отношения |

- Назначенные прямые коды — эти пять семейств. `0x11CL~0x11FL` — Reserved, `0x135L~0x1BCL` — Reserved (разделы 10~12 целиком Reserved).
- `0x1BDL~0x1BFL` (последние три позиции раздела 13) — EDGE-ISSUER (см. ниже Edge формата Issuer). У формата Issuer правила семейств нет.

## Edge-высказывание {#서술-edge}

| Codec | Имя | Компоненты |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | Направленная привязка: Subject (Reference) указывает на Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | Две Reference указывают на один и тот же объект |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | Две Reference указывают на разные объекты |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | Привязывает к Subject машинное имя (UTF8-TEXT) |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | Имя Subject на конкретном языке (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | Другое имя Subject. Раскладка та же, что у LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | Описание Subject на конкретном языке. Раскладка та же, что у LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | Высказывание с глаголом |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | Одно предложение (Predicate, Subject, Object) и rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | Одно условие, уточняющее предложение другого Edge |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | Картина мира, порядок событий, структура сцены |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | Публикация, рекомендация об отзыве и удаление версии документа ([адрес публикации и список версий](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | Словарь для записи спецификации Codec ([документ спецификации Codec](../codec-spec.md)) |

- `-SHORT` и обычная форма образуют пару чётный·нечётный (VERB-SHORT `0x0A8L`/VERB `0x0A9L`). LABEL принимает язык как языковую запись внутри Object (UTF8-LANGUAGE-TEXT), поэтому используется только один `0x0A4L`.
- PUBLICATION, DEPRECATION и TOMBSTONE использует документ списка версий. Список версий нужно читать без кодовой книги, поэтому они встроены в декодер (слой 0 в разделе [адрес публикации и список версий](../publishing.md#층)).
- DECLARE, FIELD, ENUM и CODEC — словарь для записи спецификации Codec. Документ спецификации нужно читать без кодовой книги, поэтому их раскладка встроена в декодер (слой 0). Каждый документ спецификации Codec, записанный этим словарём, — обычный документ.

### TRIPLE {#triple}

Подробнее: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length, расширяющий TAG]
Edge Id           LOCAL Reference
Predicate         Reference (свойство Wikidata и т. п.)
Subject           Reference
Object            Reference или Value
Rank              1 WORD
```

| Rank | Имя | Смысл |
|---|---|---|
| `0` | normal | по умолчанию |
| `1` | preferred | текущее значение, наиболее авторитетное значение |
| `2` | deprecated | значение, признанное ошибочным или устаревшим, но оставленное как запись |

- Rank совпадает с рангом утверждения (statement rank) Wikidata. Для источников, не ставящих rank, используется `0`.
- **Смысл TRIPLE — это совокупность всех QUALIFIER, указывающих на его Edge Id.** Перед интерпретацией TRIPLE читающая сторона собирает QUALIFIER.

Пример: Q42 — P31 (instance of) — Q5 (человек), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

Подробнее: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length, расширяющий TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id уточняемого Edge)
Value             Reference или Value
```

- QUALIFIER — часть предложения. Это не отдельное утверждение о предложении, а уточнение условий, при которых предложение истинно (момент начала и окончания, область применения и т. п.).
- Отдельное утверждение о предложении (например, кто это утверждал) записывается как TRIPLE.
- Target — Edge того же документа. Порядок QUALIFIER с одним Target — это порядок в документе.

Пример: Q42 — P69 (educated at) — Q691283, начало (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

Подробнее: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length, расширяющий TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Имя и язык хранятся в одном Object (UTF8-LANGUAGE-TEXT).
- LABEL с одним Subject и языком — не более одного. Другие имена записываются как ALIAS.
- Машинное имя без языка записывается как BIND. У LABEL язык обязателен.

### BIND {#bind}

Подробнее: [BIND](0x0A3L-bind.md)

- Привязывает к Subject имя (UTF8-TEXT), с которым сверяется машина. Языка нет, нормализации нет. Имена одинаковы, только если совпадают байты.
- Область имени — документ, содержащий BIND. В одном документе одно имя не привязывают к разным Subject.
- Другие записи указывают не на имя, а на LOCAL ID. Имя служит для сопоставления с внешним миром (функции хоста, ввод адреса, человек).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

Подробнее: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE — тождество: две Reference указывают на один и тот же объект. Рефлексивно, симметрично и транзитивно.
- DIFFERENT-NODE — нетождество: две Reference указывают на разные объекты.
- REFERENCE-NODE — направленная привязка, определяющая через Object, что такое Subject (Reference). Это не утверждение о тождестве. Например, определяет URI, на который указывает узел LOCAL.

## Edge основания {#근거-edge}

К отдельным записям внутри BODY или ко всему документу (HEAD) прикрепляется основание. Единственный прямой код семейства основания — [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | Имя | Компоненты |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id Edge из BODY, к которому прикрепляется основание; в HEAD `0` = весь документ), Origin (Reference первоисточника, ABSENT или UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- Свойства самого первоисточника (URL, название, автор, дата выхода …) записываются как TRIPLE с первоисточником в роли Subject, а свойства цитирования (дата обращения, место внутри первоисточника …) — как QUALIFIER с Edge Id из SOURCE в роли Target.
- Первоисточник всего документа записывается в HEAD как SOURCE с Target `0`, и QUALIFIER с ним в роли Target тоже кладётся в HEAD. В HEAD допускаются только эти два Edge, а Edge Id в HEAD и BODY используют одно пространство номеров ([происхождение всего документа](0x0C0L-source.md#문서-전체의-출처)).
- Прочие основания (диапазон исходного текста, создавший субъект, достоверность, срок действия по статьям, прежние записи) записываются как QUALIFIER, а первая включившая версия вычисляется по истории версий ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- Результат вердикта для отдельной записи ведёт TOULMIN `VERDICT`.

### SOURCE {#source}

Подробнее: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length, расширяющий TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id Edge из BODY, к которому прикрепляется основание; в HEAD 0 = весь документ)
Origin            Reference или маркер места 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

Пример: первоисточник TRIPLE `#178` для Q42 P19 — Британника (Q5375741), идентификатор внутри неё P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Исполняемый Edge {#실행-edge}

Структура программы, не привязанная к конкретному языку программирования. Компоненты указываются через LOCAL ID этого документа.

| Группа | Codec |
|---|---|
| объявление | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| выражение | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| оператор | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| ошибка | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- Это не формат, хранящий код внешнего языка как есть. Код внешнего языка помещается в формат Issuer.
- Компоненты указываются через LOCAL ID этого документа (REF). На месте выражения стоит Edge-выражение или символ. REF `0` означает «нет».
- Выражение даёт значение, оператор — нет. Выражение можно поставить на место оператора в BLOCK (значение отбрасывается).
- Цикл `for` в стиле C записывается как BLOCK (инициализация, WHILE), а `else if` — как IF на месте ложной ветви.
- Символ — это LOCAL ID, а имя привязывается через BIND. Другие записи указывают на символ не по имени, а по LOCAL ID. Если имена совпадают, но LOCAL ID различаются, это разные символы.
- Чем является символ (переменная, параметр, функция, тип), определяет запись, указывающая на этот символ. Символ, определения которого в документе нет, предоставляет внешняя сторона (хост); если он цель CALL, это функция хоста.

Открытые проблемы: коды операторов, представление типов, раскладка Payload каждого Codec.

## Edge TOULMIN {#toulmin-edge}

Граф вердиктов и исполнения записывается по модели аргументации Тулмина. Прямые коды — `0x100L~0x11BL`, вспомогательные записи — семейство формата TOULMIN `0x120L~0x134L`. Подробнее: [TOULMIN](../toulmin/_index.md)

## Edge формата Issuer {#issuer-형식-edge}

Issuer может определять и использовать собственные форматы Edge ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [4WORD](0x1BEL-edge-issuer-4word.md), [16WORD](0x1BFL-edge-issuer-16word.md), Codec `0x1BDL`~`0x1BFL`). Это последние три позиции области Edge. В расширяющем TAG Codec помещаются Issuer и номер Codec — 2 WORD. Edge Id — первый элемент Payload после них (TAG, Issuer, номер Codec, Edge Id, остальной Payload). Номер Codec задаёт Issuer, правила семейств нет. Независимо от Kind он не повторяется внутри `codecs/` этого Issuer. Документ Codec лежит под `codecs/` этого Issuer по номеру Codec записи ([адрес публикации и список версий](../publishing.md)).

- Зарегистрированных сейчас Edge формата ISSUER нет.
