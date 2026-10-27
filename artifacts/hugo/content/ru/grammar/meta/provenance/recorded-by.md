---
title: "RECORDED-BY"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-BY -- это Meta происхождения, которая записывает через Reference того, кто записал документ (git committer)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает того, кто записал документ (git committer).

## Раскладка

```
TAG WORD          0001 1LLL L010 0100      Codec 0x24
[Length-расширенный TAG]
Payload           одна запись Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL и т. п.)
```

- Codec: Meta `0x24`, класс происхождения (`010`)
- Payload: встроенный Reference
- Количество: не более одного

## Интерпретация и валидность

- Reference не ограничен по Codec. Это может быть человек, организация, модель или движок правил ([EXTERNAL-ISSUER](/ru/grammar/reference/external-issuer/), [GEUL](/ru/grammar/reference/geul/), [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/), [LOCAL](/ru/grammar/reference/local/) и т. п.).
- В опубликованных документах geul.org нет Reference, указывающих на физических лиц ([Issuer и публикация](/ru/grammar/issuer/#публикация-через-geulorg)). Указываются организации и Issuer. В порядке исключения указывать физическое лицо через [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/) разрешено.
- Если это LOCAL, этот объект описывается в BODY.
