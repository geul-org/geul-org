---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER — Reference-указатель-декларация, указывающий на сам Issuer. Payload — только один Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER — Reference-указатель-декларация, указывающий на сам Issuer. Он становится объектом `BIND` и `LABEL` имени Issuer и Edge вердикта.

## Раскладка

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length extension TAG]
Issuer            1/2/4/16 WORD
```

- Ширина Issuer — весь Payload. Codec ширину не делит. Если ширина не равна 1, 2, 4 или 16 WORD или если значение Issuer помещается в более узкую ширину, запись invalid (нормальная форма Issuer).
- Если Issuer — 16 WORD, в сумме выходит 17 WORD, поэтому добавляется Length extension в 1 WORD.
- Используется только Quantifier `000` (Identified). Другие значения invalid.
- Значение Issuer следует назначению в [Issuer](/ru/grammar/issuer/).
- Применение: Subject у BIND в индексе имён Issuer `issuers.geul` ([Адрес публикации и список версий](/ru/grammar/publishing/#имя-issuer)), LABEL отображаемого имени Issuer, вердикт об Issuer, подписант и другие места, где объектом является сам Issuer.
- Формат для указания на сам Issuer — только ISSUER-POINTER. Указывать на Issuer через `EXTERNAL-ISSUER-*` с ID документа `0` и ID объекта `0` — invalid.

## Пример

| Issuer | WORD sequence |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## Связанные страницы

- [Reference](/ru/grammar/reference/), [DOC-POINTER](/ru/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/ru/grammar/reference/external-issuer/), [Issuer и публикация](/ru/grammar/issuer/)
