---
title: "Meta — البنية"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "فئة البنية في Meta (أعلى 3 بتات `000`، من `0x00` إلى `0x0F`) تحدد حدود المستند وطوله. يُفتح بـ DOC-1WORD/2WORD/4WORD وينتهي HEAD بـ BODY ويُغلق بـ END."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

فئة البنية في Meta (أعلى 3 بتات `000`، وCodec `0x00`~`0x0F`) تحدد حدود المستند وطوله. وحدة بيانات GEUL هي مستند واحد.

```
DOC-*                  ← بداية HEAD
  Meta للتعريف والمصدر والنسب والتحقق والسياسة وIMPORT
  SOURCE للمستند كله وQUALIFIER الخاصة به
BODY                   ← بداية BODY
  Reference وValue وEdge
END                    ← إغلاق المستند
```

- يُفتح كل مستند بـ `DOC-1WORD/2WORD/4WORD` الذي يحدد الطول الكلي. ويستطيع المفكك بهذا الطول أن يتخطى المستند كله دفعة واحدة.
- `BODY` و`END` سجلان من 1 WORD بلا Payload. و`END` إلزامي.
- لا تتداخل المستندات. ويُشار إلى مستند آخر بـ IMPORT.
- إذا كان HEAD (Meta وSOURCE للمستند كله وQUALIFIER الخاصة به) فارغاً يُحذف `BODY`. ولا يوضع `BODY` إلا مرة واحدة لكل مستند.

بنية المستند كاملة في [المستند](/ar/grammar/document/).
