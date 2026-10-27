---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION هو Meta سياسة يكتب مدة احتفاظ المستند بقيمة وقت انتهاء أو مدة."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب مدة احتفاظ المستند.

## التخطيط

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length ممتد TAG]
Payload           وقت الانتهاء (GREGORIAN-DATE وغيره) أو المدة (DURATION-SECONDS)
```

- Codec: Meta `0x53`، فئة السياسة (`101`)
- Payload: Value مضمّنة (عائلة TIME: [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) وغيره، أو [DURATION-SECONDS](/ar/grammar/value/time/duration-seconds/))
- العدد: واحد على الأكثر

## التفسير والصلاحية

- إذا كانت مدة فتُحسب من [RECORDED-AT](/ar/grammar/meta/provenance/recorded-at/).
