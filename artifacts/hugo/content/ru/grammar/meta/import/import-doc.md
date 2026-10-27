---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC -- это Meta IMPORT, которая указывает внешний документ через DOC-POINTER и назначает ему IMPORT ID."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Импортирует внешний документ под IMPORT ID. Импортируемый документ указывает [DOC-POINTER](/ru/grammar/reference/doc-pointer/), он же содержит ширину Issuer.

## Раскладка

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length-расширенный TAG]
Документ          запись Reference DOC-POINTER (Issuer, ID документа, ID версии. Версия 0 -- последняя)
IMPORT ID         весь остаток. unsigned наименьшей ширины
```

- Codec: Meta `0x60`, класс IMPORT (`110`)
- Payload: встроенный Reference `DOC-POINTER` (Issuer, ID документа, ID версии) + сырое значение IMPORT ID
- Количество: может быть несколько (по одному на каждый IMPORT ID)

## Интерпретация и валидность

- Документ -- это ровно одна запись DOC-POINTER. Она заканчивается по собственной Length, остаток -- IMPORT ID.
- IMPORT ID занимает не менее 1 WORD и имеет наименьшую ширину. Ширина IMPORT ID определяется здесь длиной записи, а в [EXTERNAL-POINTER-*](/ru/grammar/reference/external-pointer/) -- Codec. IMPORT ID действует только внутри этого документа.
- В одном документе один и тот же IMPORT ID не назначается дважды.
- Если указан ID версии, привязка идёт к этой редакции, а при `0` -- к последней редакции на момент интерпретации (или к редакции, действовавшей на указанный момент) ([Редакция](/ru/grammar/document/#редакции)).
- [EXTERNAL-POINTER-*](/ru/grammar/reference/external-pointer/) в BODY указывает на LOCAL документа, импортированного по IMPORT ID. Сам импортированный документ указывается через DOC-POINTER.
- HEAD импортированного документа не импортируется. Объекты этого документа интерпретируются по его собственным объявлениям.
- По IMPORT ID нельзя искать между документами. Хранилище, в которое загружено много документов, раскрывает IMPORT ID в полный путь (Issuer, ID документа, ID версии, LOCAL ID) и хранит его.

## Пример

- IMPORT ID 1, Issuer `0x0001`, документ `0x…0002`, последняя версия: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (TAG Meta 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
