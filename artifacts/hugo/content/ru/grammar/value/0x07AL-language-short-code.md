---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE — сжатый языковой код GEUL, который в 1 WORD хранит один тег BCP 47 с номером в GEUL Language Registry."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `LANGUAGE-SHORT-CODE` (BIND в документе спецификации `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| Документ спецификации | `0x00000000/codecs/0x000007A0/` (цель DECLARE `07A0`) |
| Раздел | 3 `0011` (Value), смещение C внутри раздела = 26 |
| Kind | Value · семейство: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Тег BCP 47, записанный номером GEUL Language Registry (Payload 1 WORD) |
| Сторона Hugo | `value/text/language-short-code.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | простое значение, 1 WORD |  | ENUM: 8678 шт. Примеры: `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE — сжатый языковой код GEUL, который в 1 WORD хранит один тег BCP 47 с номером в GEUL Language Registry. Payload — ровно 1 WORD.

## Раскладка {#레이아웃}

- Код: прямой код Value `0x07AL`. Семейство TEXT.
- Payload — ровно 1 WORD, беззнаковый 16-битный код.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  всего 2 WORD
Payload WORD 1st (16 бит)           номер GEUL Language Registry (uint16)
```

## Интерпретация и действительность {#해석과-유효성}

- Payload 1 WORD читается как беззнаковое 16-битное целое.
- Это значение — один тег, назначенный GEUL Language Registry. Каноническое представление реестра — документ спецификации этого Codec `0x00000000/codecs/0x000007A0`. Для каждого значения кода в FIELD `code` есть один [ENUM](../edge/0x0BDL-enum.md), а имя, привязанное через [BIND](../edge/0x0A3L-bind.md) к Edge Id этого ENUM, — тег BCP 47 в каноническом регистре.
- Реестр — закрытый список. Значение, для которого в документе спецификации нет ENUM, — invalid. Правило этого Codec важнее общего правила ENUM («необъявленное значение кода не является ошибкой»).
- Назначаются следующие три группы.
  - Записи `Type: language` из IANA Language Subtag Registry, за исключением `Scope: private-use` (`qaa..qtz`). collection, macrolanguage и special (`mul`, `und`, `zxx`, `mis`) не исключаются.
  - Теги, зарегистрированные IANA целиком: grandfathered и redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan` и др.).
  - Действительные составные теги, наблюдаемые в открытых источниках CC0 (`pt-BR`, `en-GB`, `be-tarask` и др.). Это теги, состоящие только из подтегов language, extlang, script, region, variant. Теги с extension (`-u-`, `-t-`) и private-use (`-x-`) не принимаются.
- Тег без номера в этом формате записать нельзя. Он записывается как [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Внутри SHORT-CODE пути escape нет.
- `0x0000` и `0xFFFF` не назначаются никогда. В этом Value оба — invalid. Ни один из них не используется в смысле `null`, `unknown` или `und`.
- Диапазоны значений — договорённость о назначении. Декодер не выводит вид тега из диапазона значения. Смысл значения берётся только из документа спецификации.

| Диапазон | Назначение |
|---|---|
| `0x0000` | не назначен (invalid) |
| `0x0001`–`0x3FFF` | теги из одного подтега language |
| `0x4000`–`0x7FFF` | теги из двух и более подтегов (теги IANA целиком, наблюдаемые составные теги) |
| `0x8000`–`0xFFFE` | переполнение. Когда указанные блоки заполнены, назначение продолжается здесь |
| `0xFFFF` | не назначен (invalid) |

- Первая редакция выдаёт номера внутри блока в порядке ASCII тегов в нижнем регистре. В блоке `0x4000` сначала идут теги IANA целиком (grandfathered и redundant вперемешку, в порядке ASCII), затем наблюдаемые составные теги (в порядке ASCII). Физический порядок файла IANA и частота использования правилом нумерации не являются.
- Назначение только дополняется (append-only). Новый тег добавляется в конец блока, а когда блок заполнен — в диапазон переполнения. Тег (без учёта регистра), которому номер уже выдан, не меняется, не удаляется и номер не используется повторно.
- Новые теги вносятся в новой версии документа спецификации добавлением ENUM и BIND. Существующие ENUM и BIND не меняются. Поэтому любая версия — надмножество предыдущей.
- Когда заполнятся все 65 534 номера, дальнейших назначений не будет. Новые теги после этого записываются как LANGUAGE-BCP47-CODE. Выразительность не уменьшается, пропадает только выигрыш в сжатии.
- Тот же язык: SHORT-CODE `n` и LANGUAGE-BCP47-CODE тега, связанного в реестре с `n` (без учёта регистра), обозначают один язык.
- Редакция реестра — это версия документа спецификации. Каждая редакция записывает файл реестра IANA, на который опирается (File-Date, SHA-256), как [SOURCE](../edge/0x0C0L-source.md) в HEAD документа спецификации. Если нужно указать редакцию, по которой интерпретировано значение, вместе с ним сохраняется эта версия ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, `0x000007A0`, ID версии `n`)).
- Спецификация Codec может хранить тот же 1-WORD код как поле простого значения без TAG ([CODEC](../codec-spec.md#codec) поля простого значения). Это правило данной спецификации Codec, а wire form самостоятельного Value всегда — TAG 1 WORD + Payload 1 WORD.

## Основание в стандартах {#표준-근거}

- Смысл тега и действительность подтегов соответствуют [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) и [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA и IETF передают права на реестры протоколов под CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Номера реестра (назначение append-only в порядке ASCII, состав блоков, неназначенные `0x0000` и `0xFFFF`, закрытый список), то, что ENUM документа спецификации является каноническим представлением, и отличие от встраивания в поле простого значения без TAG — правила GEUL.

## Длина {#길이}

- Всего — ровно 2 WORD: TAG 1 WORD и Payload 1 WORD; используется прямая длина `LLLL=0001`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 1 WORD, значение отвергается.

## Примеры {#예시}

Номера реестра v2 (документ спецификации `0x00000000/codecs/0x000007A0`, версия 2, IANA File-Date 2026-09-17). Назначено 8 678 (language 8 275, grandfathered 26, redundant 67, наблюдаемых составных 310).

| tag | Код | Всего WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- В документе спецификации `en` — это `ENUM #2 0x0784` и `BIND "en"`, привязанный к его Edge Id.
- У `de-x-formal` (private-use) и `nl-u-sd-bebru` (extension) номеров нет, поэтому они записываются как LANGUAGE-BCP47-CODE.

## Открытые проблемы {#열린-문제}

- Интерпретация между редакциями: если читающая сторона встречает номер новее своей редакции, отбрасывать его как invalid или сохранять исходное значение и считать «неизвестным кодом». Благодаря append-only одной последней редакции всегда достаточно, но для офлайн-декодеров нужно правило.
- Каноническая форма: должен ли тег с номером записываться как SHORT-CODE (SHOULD/MUST). При MUST запись единственна, но после выхода новой редакции ранее записанные документы перестают быть каноническими.
- Способ выразить в документе спецификации deprecated теги и Preferred-Value (в нынешней редакции его нет).
- Порядок добавления наблюдаемых составных тегов (источник, нижняя граница наблюдений).

## Связанные страницы {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [документ спецификации Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000007A0/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные цифры заглавные).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (ENUM и BIND, 17346 строк, опущены)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
