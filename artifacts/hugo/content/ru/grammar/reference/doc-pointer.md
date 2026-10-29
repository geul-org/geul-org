---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER — Reference-указатель-декларация, указывающий на одну версию документа, опубликованного Issuer. ID версии 0 означает последнюю версию."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER — Reference-указатель-декларация, указывающий на одну версию документа, опубликованного Issuer. Он становится объектом публикации, deprecate и удаления документа, цитируемой версии и утверждений о документе.

## Раскладка

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length extension TAG]
Issuer            1/2/4/16 WORD
ID документа      4 WORD
ID версии         2 WORD
```

## Интерпретация и допустимость

- Ширина Issuer — это остаток Payload за вычетом 6 WORD (ID документа и ID версии). Codec ширину не делит. Если ширина не равна 1, 2, 4 или 16 WORD или если значение Issuer помещается в более узкую ширину, запись invalid (нормальная форма Issuer).
- ID версии не опускается. Если разрешить его опускать, ширину Issuer нельзя будет определить по одной длине Payload (Issuer 4 WORD без версии и Issuer 2 WORD с версией дают одинаковые 8 WORD).
- ID версии `0` — последняя версия. Привязывается к действующей версии на момент интерпретации. Остальные значения фиксируются на этой версии ([PUBLICATION](/ru/grammar/edge/publication/)).
- ID документа `0` — индексный документ определений терминов Issuer. На сам Issuer указывает [ISSUER-POINTER](/ru/grammar/reference/issuer-pointer/).
- Quantifier — только `000` (Identified). Другие значения invalid.
- Формат для указания на документы Issuer — только DOC-POINTER. Указывать на документ через `EXTERNAL-ISSUER-*` (Issuer, ID документа, ID объекта `0`) или `EXTERNAL-POINTER-*` (IMPORT ID, ID объекта `0`) — invalid.
- Где используется: Meta [DOC-ID](/ru/grammar/meta/declaration/doc-id/)·[IMPORT-DOC](/ru/grammar/meta/import/import-doc/), PUBLICATION·DEPRECATION·TOMBSTONE в списке версий и Subject у BIND, Subject у BIND в индексе имён `documents.geul`.

## Пример

Документ `0xffff000000000001` Issuer GEUL `0x0000`.

| Версия | WORD sequence |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| последняя (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + ID документа 4 + ID версии 2 = 8 WORD, `LLLL=0111`. TAG — `0000 0 0111 0111 000` = `03B8`.

## Связанные страницы

- [Reference](/ru/grammar/reference/), [ISSUER-POINTER](/ru/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/ru/grammar/reference/external-issuer/), [PUBLICATION](/ru/grammar/edge/publication/)
- [Issuer и публикация](/ru/grammar/issuer/)
