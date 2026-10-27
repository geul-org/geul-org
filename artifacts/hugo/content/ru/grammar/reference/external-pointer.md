---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER — Reference-указатель на LOCAL ID документа, импортированного через IMPORT-DOC в HEAD."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER — Reference-указатель на LOCAL ID документа, импортированного через [IMPORT-DOC](/ru/grammar/meta/import/import-doc/) в HEAD.

## Раскладка

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length extension TAG]
IMPORT ID         ширина, заданная WW (00=1, 01=2, 10=4, 11=8 WORD)
ID объекта        всё остальное. LOCAL ID импортированного документа, наименьшей ширины
```

| CCCC | Имя | Ширина IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- Используется самый узкий Codec, в который помещается значение IMPORT ID.
- IMPORT ID — значение, назначенное `IMPORT-DOC` этого документа, и действует только внутри этого документа. В EXTERNAL-POINTER Issuer не записывается. Issuer и ID документа берутся из этого `IMPORT-DOC`. Версию тоже задаёт этот `IMPORT-DOC` (фиксированная или последняя).
- Один и тот же LOCAL ID импортированного документа обозначает один и тот же объект, независимо от того, записан ли он как LOCAL внутри того документа или здесь как EXTERNAL-POINTER.
- Variable — это LOCAL-переменная импортированного документа.

## Допустимость

- Если в этом документе нет `IMPORT-DOC`, назначившего этот IMPORT ID, запись invalid.
- Если IMPORT ID помещается в более узкий Codec, а использован более широкий, запись отклоняется как non-minimal.
- Если ID объекта равен `0`, запись invalid. На сам импортированный документ указывает [DOC-POINTER](/ru/grammar/reference/doc-pointer/).
- Ведущий WORD `0x0000` в ID объекта запрещён.

## Пример

| Объект | WORD sequence |
|---|---|
| LOCAL 5 у IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 у IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 у IMPORT ID 70000 | `01C8 0001 1170 0005` |

## Связанные страницы

- [Reference](/ru/grammar/reference/), [LOCAL](/ru/grammar/reference/local/), [EXTERNAL-ISSUER](/ru/grammar/reference/external-issuer/), [DOC-POINTER](/ru/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/ru/grammar/meta/import/import-doc/)
