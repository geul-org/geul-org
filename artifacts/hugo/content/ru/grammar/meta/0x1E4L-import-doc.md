---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Импортирует внешний документ под IMPORT ID."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `IMPORT-DOC` (BIND документа спецификации `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| Документ спецификации | `0x00000000/codecs/0x00001E40/` (цель DECLARE `1E40`) |
| Раздел | 15 `1111` (Meta), смещение в разделе C = 4 |
| Kind | Meta · класс: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Импортирует внешний документ под IMPORT ID. Встроенный Reference `DOC-POINTER` (для документа Codec — `CODEC-POINTER`) + IMPORT ID |
| Сторона Hugo | `meta/import/import-doc.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | запись | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

Импортирует внешний документ под IMPORT ID. Импортируемый документ указывает [DOC-POINTER](../reference/0x041L-doc-pointer.md), он же несёт ширину Issuer.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[Length — расширяющий TAG]
Документ          запись Reference DOC-POINTER (Issuer, ID документа, ID версии. Если версия 0 — последняя). Для документа Codec — CODEC-POINTER
IMPORT ID         всё оставшееся. unsigned наименьшей ширины
```

- Codec: Meta `0x1E4L`, класс IMPORT
- Payload: встроенный Reference `DOC-POINTER` (Issuer, ID документа, ID версии) + простое значение IMPORT ID
- Количество: может быть несколько (по одному на IMPORT ID)

## Интерпретация и валидность {#해석과-유효성}

- Документ — ровно одна запись DOC-POINTER. При импорте документа Codec — запись [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID версии). Она заканчивается своим Length, а остаток — это IMPORT ID.
- IMPORT ID занимает 1 WORD или более, наименьшей ширины. Ширина IMPORT ID здесь определяется длиной записи, а в [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) — Codec.
- В одном документе один и тот же IMPORT ID дважды не назначается.
- Если указан ID версии, привязка идёт к этой редакции, если `0` — к последней на момент интерпретации (или к действовавшей на указанный момент) редакции ([Редакция](../document.md#개정)).
- [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) в BODY указывает на LOCAL документа, импортированного под IMPORT ID. Сам импортированный документ указывается через DOC-POINTER.
- HEAD импортированного документа не импортируется. Объекты этого документа интерпретируются по его собственным объявлениям.
- По IMPORT ID нельзя искать между документами. Хранилище, загружающее несколько документов, разворачивает IMPORT ID в полный путь (Issuer, ID документа, ID версии, LOCAL ID) и хранит его.

## Пример {#예시}

- IMPORT ID 1, Issuer `0x00000002`, документ `0x…0002`, последняя версия: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001E40/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
