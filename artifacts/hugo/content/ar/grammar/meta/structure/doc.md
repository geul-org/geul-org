---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD وDOC-2WORD وDOC-4WORD هي Meta بنية تفتح المستند بتحديد العدد الكلي لـ WORD فيه."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هو السجل الذي يفتح المستند. ويحدد في Payload العدد الكلي لـ WORD في المستند. تُعالج هذه الصفحة معاً `DOC-1WORD` (`0x00`) و`DOC-2WORD` (`0x01`) و`DOC-4WORD` (`0x02`).

## التخطيط

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length ممتد TAG]
Payload           العدد الكلي لـ WORD. يحدد Codec العرض: DOC-1WORD 1، وDOC-2WORD 2، وDOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`، فئة البنية (`000`)
- Payload: قيمة خام (العدد الكلي لـ WORD في المستند، unsigned)
- العدد: واحد لكل مستند، في المقدمة

## التفسير والصلاحية

- الطول من بداية السجل الفاتح إلى نهاية [END](/ar/grammar/meta/structure/end/).
- يُستخدم أضيق عرض تتسع له القيمة. والترميز بعرض أوسع يُرفض بوصفه ترميزاً غير قياسي.
- يجب أن يساوي الطول المدخل كله. المستند الواحد مدخل واحد.
- يستطيع المفكك بهذا الطول أن يتخطى المستند كله. ولا يوجد Codec يفتح دون معرفة الطول.
- عند حساب تجزئة المحتوى يُعاد كتابته بالطول بعد طرح Meta فئة التحقق وبالعرض المناسب له ([تجزئة المحتوى](/ar/grammar/document/#تجزئة-المحتوى)).

## أمثلة

- `0x1880 0x0017`: DOC-1WORD، والمجموع 23 WORD
