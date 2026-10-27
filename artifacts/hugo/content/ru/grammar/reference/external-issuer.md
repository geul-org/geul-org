---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER — Reference-указатель-декларация, цитирующий LOCAL ID документа, опубликованного Issuer, одной записью, без IMPORT."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER — Reference-указатель-декларация, цитирующий LOCAL ID документа, опубликованного Issuer, без IMPORT. Смысл завершён одной записью, и она следует последней версии.

## Раскладка

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length extension TAG]
Issuer            ширина, заданная WW (00=1, 01=2, 10=4, 11=16 WORD)
ID документа      4 WORD
ID объекта        всё остальное. LOCAL ID этого документа, наименьшей ширины
```

| CCCC | Имя | Ширина Issuer |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (назначается geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (регистрируется в geul.org, подтверждение домена) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (регистрируется в geul.org, без подтверждения) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (вычисляется из открытого ключа) |

- Issuer ID — целочисленное значение. Одинаковые значения — один и тот же Issuer. Issuer записывается наименьшей шириной, в которую помещается значение, и выбирается Codec этой ширины (2 WORD — только если значение превышает `0xFFFF`, 4 WORD — только если оно не меньше `2^32`, 16 WORD — только если не меньше `2^64`). Запись в более широкой форме invalid ([Issuer](/ru/grammar/issuer/)).
- Регистрацию и управление Issuer ведёт geul.org.
- Версия не записывается, запись следует последней версии. Чтобы зафиксировать версию, используются [IMPORT-DOC](/ru/grammar/meta/import/import-doc/) и [EXTERNAL-POINTER](/ru/grammar/reference/external-pointer/).
- Расположение находится по правилам адреса публикации ([Адрес публикации и список версий](/ru/grammar/publishing/)).
- Один и тот же LOCAL ID этого документа обозначает один и тот же объект, независимо от того, записан ли он как LOCAL внутри документа, как EXTERNAL-ISSUER в другом документе (или как EXTERNAL-POINTER после IMPORT).
- Указывает только на LOCAL документа. На сам документ указывает [DOC-POINTER](/ru/grammar/reference/doc-pointer/), на сам Issuer — [ISSUER-POINTER](/ru/grammar/reference/issuer-pointer/). Поэтому ID объекта не равен `0`. ID документа `0` — индексный документ определений терминов Issuer.

## Допустимость

- Если ширина Issuer не соответствует Codec или значение помещается в более узкую ширину, запись invalid.
- Если ID объекта равен `0`, запись invalid. ID объекта `0` (сам документ) принадлежит DOC-POINTER.
- Ведущий WORD `0x0000` в ID объекта запрещён.

## Пример

| Объект | WORD sequence |
|---|---|
| Issuer `0x0001`, документ `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, документ `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## Связанные страницы

- [Reference](/ru/grammar/reference/), [DOC-POINTER](/ru/grammar/reference/doc-pointer/), [ISSUER-POINTER](/ru/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/ru/grammar/reference/external-pointer/)
- [Issuer и публикация](/ru/grammar/issuer/)
