---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM هو Meta نسب يكتب المستند أو المادة من نسب آخر التي اشتُق منها هذا المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب أن هذا المستند اشتُق من مستند أو مادة في نسب آخر.

## التخطيط

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length ممتد TAG]
Payload           Reference، أو SHA-256-DIGEST (تجزئة المحتوى)، أو قيمة URI
```

- Codec: Meta `0x31`، فئة النسب (`011`)
- Payload: Reference أو Value مضمّنة
- العدد: يمكن أكثر من واحد

## التفسير والصلاحية

- إذا كان الاشتقاق من مستند GEUL فتوضع تجزئة محتواه ([SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/))، وإن كان من مادة خارجية فتوضع [URI](/ar/grammar/value/text/uri/). ولتثبيت إصدار المادة الخارجية بالتجزئة تُلحق QUALIFIER لتجزئة النص الأصلي (P4092) بـ [SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) في HEAD.
- المصدر على مستوى السجل من شأن Edge الدليل [SOURCE](/ar/grammar/edge/source/)، والسجل القديم قبل النقل والتقسيم والدمج من شأن QUALIFIER P1365 في Edge الهدف (قيمتها Edge Id القديم).
