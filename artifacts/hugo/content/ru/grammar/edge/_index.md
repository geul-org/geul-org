---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge -- запись, которая связывает Reference, Value и другие Edge в одно утверждение. Первый компонент всегда Edge Id, а два старших бита Codec задают семейство (описание, основание, исполнение, TOULMIN)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge -- запись, которая связывает другие записи в одно утверждение. Утверждения вроде «Q42 -- человек» или «английское имя Q42 -- Douglas Adams» -- это по одному Edge.

## Раскладка

```
TAG WORD          0001 0LLL LCCC CCCC
[Length extension TAG]
[TAG расширения Codec]  для формата Issuer
Edge Id           запись LOCAL Reference
компоненты        в порядке, заданном Codec
```

- `LLLL` -- общее число WORD вместе с TAG WORD, минус 1. Декодер переходит к следующей записи только по Length, не зная Codec.
- **Первый компонент всегда Edge Id (LOCAL Reference).** Это LOCAL Reference (`0088` + ID, Quantifier `000`), поэтому Edge Id читается и без знания кодека.
- Каждый компонент находит свою границу по собственному Length. Позиция после чтения последнего компонента должна точно совпасть с концом Edge.
- Состав (Payload) компонентов задаёт документ каждого Edge Codec.
- У Codec с подформатами (WORLD, TIMELINE, SCENE) подформат задаёт 1 WORD TAG, свой у каждого Codec.
- Порядок между записями Edge не несёт смысла (кроме случаев, когда Codec задаёт его отдельно; например, документ [TOULMIN](/ru/grammar/edge/toulmin/)).
- На другие Edge указывают через Edge Id. Edge этого документа -- через LOCAL, Edge другого документа -- через указывающий Reference (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Семейства

| Старшие 2 бита | Семейство | Прямой код | Что делает |
|---|---|---|---|
| `00` | описание | `0x00`~`0x1F` | Строит содержимое о мире и событиях |
| `01` | основание | `0x20`~`0x3F` | Откуда взялись запись и документ ([SOURCE](/ru/grammar/edge/source/)) |
| `10` | исполнение | `0x40`~`0x5F` | Структура исполняемой программы (AST) |
| `11` | [TOULMIN](/ru/grammar/edge/toulmin/) | `0x60`~`0x7B` | Граф аргументации: утверждения, возражения, исключения, отношения атаки, исполнение, результат вердикта |

## Описательные Edge

| Codec | Название | Компоненты |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/ru/grammar/edge/reference-node/) | Направленная привязка: Subject (Reference) указывает на Object |
| `0x01` | [SAME-NODE](/ru/grammar/edge/same-node/) | Два Reference указывают на один и тот же объект |
| `0x02` | [DIFFERENT-NODE](/ru/grammar/edge/different-node/) | Два Reference указывают на разные объекты |
| `0x03` | [BIND](/ru/grammar/edge/bind/) | Привязывает к Subject машинное имя (UTF8-TEXT) |
| `0x04` | [LABEL](/ru/grammar/edge/label/) | Имя Subject на конкретном языке (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/ru/grammar/edge/alias/) | Другое имя Subject. Раскладка та же, что у LABEL |
| `0x06` | [DESCRIPTION](/ru/grammar/edge/description/) | Описание Subject на конкретном языке. Раскладка та же, что у LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | Описание глагола |
| `0x0A` | [TRIPLE](/ru/grammar/edge/triple/) | Одно высказывание (Predicate, Subject, Object) и rank |
| `0x0B` | [QUALIFIER](/ru/grammar/edge/qualifier/) | Одно условие, уточняющее высказывание другого Edge |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | Картина мира, порядок событий, структура сцены |
| `0x18`~`0x1A` | [PUBLICATION](/ru/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | Публикация версии документа, рекомендация прекратить использование, удаление ([адрес публикации и список версий](/ru/grammar/publishing/#список-версий)) |
| `0x1B`~`0x1E` | [DECLARE](/ru/grammar/edge/declare/) / [FIELD](/ru/grammar/edge/field/) / [ENUM](/ru/grammar/edge/enum/) / [CODEC](/ru/grammar/edge/codec/) | Словарь для записи спецификации Codec ([документ спецификации Codec](/ru/grammar/codec-spec/)) |

- Формы `-SHORT` и обычная образуют пару чётный-нечётный код (VERB-SHORT `0x08` / VERB `0x09`). LABEL принимает язык как языковую запись внутри Object (UTF8-LANGUAGE-TEXT), поэтому ему достаточно одного кода `0x04`.
- PUBLICATION, DEPRECATION и TOMBSTONE пишет документ списка версий. Список версий нужно читать без кодбука, поэтому они встроены в декодер (слой 0 в разделе [адрес публикации и список версий](/ru/grammar/publishing/#уровни)).
- DECLARE, FIELD, ENUM и CODEC -- словарь для записи спецификации Codec. Спецификацию нужно читать без кодбука, поэтому раскладка встроена в декодер (слой 0). Каждый документ спецификации Codec, написанный этим словарём, -- обычный документ.

### TRIPLE

Подробнее: [TRIPLE](/ru/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length extension TAG]
Edge Id           LOCAL Reference
Predicate         Reference (свойство Wikidata и т. п.)
Subject           Reference
Object            Reference или Value
Rank              1 WORD
```

| Rank | Название | Смысл |
|---|---|---|
| `0` | normal | По умолчанию |
| `1` | preferred | Текущее, наиболее авторитетное значение |
| `2` | deprecated | Значение, признанное неверным или устаревшим, но оставленное в записи |

- Rank совпадает со statement rank в Wikidata. Источник, который не ставит rank, использует `0`.
- **Смысл TRIPLE -- это совокупность всех QUALIFIER, указывающих на его Edge Id.** Перед интерпретацией TRIPLE читающая сторона собирает QUALIFIER.

Пример: Q42 -- P31 (instance of) -- Q5 (human), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

Подробнее: [QUALIFIER](/ru/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id уточняемого Edge)
Value             Reference или Value
```

- QUALIFIER -- часть высказывания. Это не отдельное утверждение о высказывании, а условие, при котором оно истинно (время начала и конца, область применения и т. п.).
- Отдельное утверждение о высказывании (например, кто его выдвинул) записывается как TRIPLE.
- Target -- Edge того же документа. Порядок QUALIFIER с одним Target -- порядок в документе.

Пример: Q42 -- P69 (educated at) -- Q691283, начало (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

Подробнее: [LABEL](/ru/grammar/edge/label/), [ALIAS](/ru/grammar/edge/alias/), [DESCRIPTION](/ru/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length extension TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Имя и язык хранятся в одном Object (UTF8-LANGUAGE-TEXT).
- LABEL с одним Subject и языком -- не более одного. Другие имена записываются как ALIAS.
- Машинное имя без языка записывается как BIND. У LABEL язык обязателен.

### BIND

Подробнее: [BIND](/ru/grammar/edge/bind/)

- Привязывает к Subject имя (UTF8-TEXT), по которому его находит машина. Языка нет, нормализации нет. Имена совпадают только при совпадении байтов.
- Область имени -- документ, содержащий BIND. В одном документе одно и то же имя не привязывают к разным Subject.
- Другие записи указывают не на имя, а на LOCAL ID. Имя служит для сопоставления с внешним миром (функции хоста, ввод адреса, человек).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

Подробнее: [SAME-NODE](/ru/grammar/edge/same-node/), [DIFFERENT-NODE](/ru/grammar/edge/different-node/), [REFERENCE-NODE](/ru/grammar/edge/reference-node/)

- SAME-NODE -- тождество: два Reference указывают на один и тот же объект. Рефлексивно, симметрично, транзитивно.
- DIFFERENT-NODE -- нетождество: два Reference указывают на разные объекты.
- REFERENCE-NODE -- направленная привязка, определяющая через Object, чем является Subject (Reference). Это не утверждение тождества. Пример: определяет URI, на который указывает узел LOCAL.

## Edge оснований

К отдельным записям в BODY или ко всему документу (HEAD) прикрепляют основание. Единственный прямой код семейства оснований -- [SOURCE](/ru/grammar/edge/source/) (`0x20`).

| Codec | Название | Компоненты |
|---|---|---|
| `0x20` | [SOURCE](/ru/grammar/edge/source/) | Target (Edge Id Edge из BODY, к которому прикрепляется основание; в HEAD `0` = весь документ), Origin (Reference первоисточника, ABSENT или UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- Свойства самого первоисточника (URL, название, автор, дата выпуска …) записываются как TRIPLE с первоисточником в роли Subject, а свойства цитирования (дата обращения, место внутри первоисточника …) -- как QUALIFIER с Edge Id SOURCE в роли Target.
- Первоисточник всего документа записывается в HEAD как SOURCE с Target `0`, а QUALIFIER, у которых он Target, тоже помещаются в HEAD. В HEAD допустимы только эти два Edge, а Edge Id в HEAD и BODY используют одно пространство номеров ([Источник всего документа](/ru/grammar/edge/source/#источник-всего-документа)).
- Прочие основания (диапазон в исходном тексте, создавший субъект, достоверность, срок действия по статьям, прежние записи) записываются как QUALIFIER, а версия, в которой запись появилась впервые, вычисляется по истории версий ([SOURCE](/ru/grammar/edge/source/#представление-других-оснований)).
- Результат вердикта по записи ведёт TOULMIN `VERDICT`.

### SOURCE

Подробнее: [SOURCE](/ru/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length extension TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id Edge из BODY, к которому прикрепляется основание; в HEAD 0 = весь документ)
Origin            Reference или маркер слота 0x0000 ABSENT, 0x0001 UNKNOWN-VALUE
```

Пример: источник TRIPLE `#178` для Q42 P19 -- Britannica (Q5375741), идентификатор внутри неё P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Исполняемые Edge

Структура программы, не привязанная к конкретному языку программирования. Компоненты указываются через LOCAL ID этого документа.

| Группа | Codec |
|---|---|
| Объявления | FUNCTION-DECLARE, TYPE-DECLARE |
| Выражения | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| Операторы | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| Ошибки | RAISE, TRY |

- Это не формат для хранения кода внешнего языка как есть. Код внешнего языка хранится в формате Issuer.
- Компоненты указываются через LOCAL ID (REF) этого документа. На месте выражения стоит Edge выражения или символ. REF `0` означает «нет».
- Выражение даёт значение, оператор -- нет. Выражение можно поставить на место оператора в BLOCK (значение отбрасывается).
- `for` в стиле C записывается как BLOCK (инициализация, WHILE), а `else if` -- как IF на месте ложной ветви.
- Символ -- это LOCAL ID, а имя привязывается через BIND. Другие записи указывают на символ не по имени, а по LOCAL ID. Если имена совпадают, но LOCAL ID разные, это разные символы.
- Чем является символ (переменная, параметр, функция, тип), определяет запись, которая на него указывает. Символ без определения в документе предоставляет внешний мир (хост); если он цель CALL, это функция хоста.

Открытые вопросы: коды операторов, представление типов, раскладка Payload каждого Codec.

## Edge TOULMIN

Подробнее: [TOULMIN](/ru/grammar/edge/toulmin/)

Граф вердиктов и исполнения записывается по модели аргументации Тулмина. Это ключевое семейство, с помощью которого GEUL описывает собственные правила на GEUL и сам их исправляет.

| Группа | Codec |
|---|---|
| Объявления | CASE-DECLARE (случай), [PREDICATE-DECLARE](/ru/grammar/edge/toulmin/expr/) (предикат), SPEC-DECLARE (критерий оценки), RULE-DECLARE (утверждение), COUNTER-DECLARE (возражение), EXCEPT-DECLARE (исключение) -- [NODE](/ru/grammar/edge/toulmin/node/) |
| Отношения | ATTACKS (атака), SUPERSEDES (вытеснение) -- [LINK](/ru/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (цепочка приоритетов, раскладка не определена) |
| Исполнение | RUN, DO, DO-ONCE, UNDO, CHECKING -- [LINK](/ru/grammar/edge/toulmin/link/), ENTRY, TRIGGER -- [NODE](/ru/grammar/edge/toulmin/node/) |
| Результат | VERDICT (результат вердикта: Pass, Review, Fail), EVIDENCE (доказательство вердикта) -- раскладка не определена |

- Исходный текст, разделы, вспомогательные узлы и отношения -- это формат ISSUER (`0xC000`~`0xC029`) GEUL Issuer ([SOURCE и разделы](/ru/grammar/edge/toulmin/source/)).
- Результат вердикта помещается в документ, отличный от оцениваемого. Документ результата импортирует документ-цель и указывает на него. Поэтому вердикт не меняет хеш содержимого документа-цели.

## Edge формата Issuer

Issuer может определять и использовать собственные форматы Edge (Codec `0x7C`~`0x7F`). Прямые коды `0x7C`~`0x7F` лежат внутри диапазона TOULMIN, но это общие коды ISSUER; семейство определяется двумя старшими битами номера формата.

| Issuer | Номер формата | Название | Семейство |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/ru/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/ru/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/ru/grammar/edge/toulmin/link/) | TOULMIN |
