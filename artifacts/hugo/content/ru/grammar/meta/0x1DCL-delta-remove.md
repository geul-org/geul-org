---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Указывает в diff (DELTA-BASE) LOCAL ID (Edge Id) записей, которые нужно убрать из BODY базового снимка («статья X удалена»)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `DELTA-REMOVE` (BIND документа спецификации `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| Документ спецификации | `0x00000000/codecs/0x00001DC0/` (цель DECLARE `1DC0`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 28 |
| Kind | Meta · класс: родословная |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Список LOCAL ID (Edge Id), которые нужно убрать из базового BODY в diff |
| Сторона Hugo | `meta/lineage/delta-remove.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

Указывает в diff ([DELTA-BASE](0x1DBL-delta-base.md)) LOCAL ID (Edge Id) записей, которые нужно убрать из BODY базового снимка («статья X удалена»).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[Length — расширяющий TAG]
Удаляемые LOCAL ID    запись LOCAL Reference × 1 и более
```

- Codec: Meta `0x1DCL`, класс родословной
- Payload: одна или несколько записей [LOCAL](../reference/0x005L-local.md) Reference
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Ставится только в документе с `DELTA-BASE`.
- Каждый LOCAL ID должен быть Edge Id, присутствующим в BODY базового снимка. Если нет — invalid. Двукратное указание одного и того же ID — invalid.
- Повторное указание того же Edge Id в BODY того же diff — invalid (удаление и редакцию одновременно выполнить нельзя).
- Удалённый LOCAL ID в последующих версиях другому объекту не назначается ([Редакция](../document.md#개정)).
- Отсутствие записи в BODY diff означает «не изменилось». Поэтому удаление выражается только этой Meta.
- HEAD Edge ([SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) для всего документа и его QUALIFIER) не записываются. HEAD целиком заменяется HEAD из diff ([Хранение diff](../document.md#diff-저장)).

## Пример {#예시}

Удаление LOCAL `#7` и `#12`:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4` (Meta `0x1DCL`, `LLLL=0100`, 5 WORD), LOCAL Reference `0051 0007`, `0051 000C`.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001DC0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
