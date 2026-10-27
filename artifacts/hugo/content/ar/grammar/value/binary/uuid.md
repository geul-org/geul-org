---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID قيمة Value ثابتة من 9 WORD تحمل القيمة ذات 128bit لـ UUID وفق RFC 9562 في 16 octet قياسية كما هي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID قيمة Value ثابتة العرض تحمل القيمة ذات 128bit لـ UUID وفق RFC 9562. الرمز المباشر في Value هو `0x60` والعائلة BINARY. Payload هو 8 WORD (16 octet، 128bit) تماماً.

## التخطيط

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  المجموع 9 WORD
Payload           8 WORD (128 بت)  UUID octet 0 → octet 15
```

## التفسير والصلاحية

- تُجمَّع octet القياسية لـ UUID في RFC 9562 من octet 0 إلى octet 15 بالترتيب، كل اثنين معاً. octet الأول هو أعلى 8bit في WORD. لا تُعاد ترتيب حقول UUID ولا version bit ولا variant bit ولا يُعاد ترميزها.
- السلسلة hex-and-dash بصيغة `8-4-4-4-12` تمثيل للإدخال والإخراج فقط. لا تدخل الحالة (كبيرة/صغيرة) ولا dash في Payload، ويُخزَّن ناتج التحليل، أي 16 octet، فقط.
- يحفظ هذا UUID Value نمط 128bit دون فقد. في variant `10xx` من RFC 9562 تكون version 1 و3 و4 و5 و6 و7 تخطيطات قياسية، وversion 8 صيغة UUID مخصصة (custom). version 2 محجوزة لـ DCE Security ولم تحدد RFC تخطيطها، وversion 0 غير مستخدمة (unused)، وversion 9–15 محجوزة لتعريفات مستقبلية. وvariants الأخرى أيضاً محجوزة للتوافق أو للتعريف المستقبلي.
- Nil UUID قيمة خاصة كل بتاتها الـ 128 أصفار، وMax UUID قيمة خاصة كل بتاتها الـ 128 واحدات. لا يُستبعد بنيوياً أي نمط من 128bit بما فيه version/variant المحجوزة وغير المستخدمة، ويُحكم في معنى النمط وإمكانية التشغيل البيني من المعيار المطبَّق ومن السياق الخارجي.
- يُحكم بتطابق UUID بتساوي قيمة 128bit في Payload. وكون القيمتين متساويتين لا يضمن مصادقة الهدف ولا ملكيته ولا وجوده الحالي ولا إمكانية حله ولا صلاحية الوصول إليه.
- عند تخزين Microsoft COM GUID لا يُنسخ تمثيله في الذاكرة أو تسلسله mixed-endian كما هو. يُحوَّل أولاً إلى 16 octet بترتيب حقول/octet القياسي في RFC 9562.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## السند المعياري

- يعرّف [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) UUID بأنه 16 octet (128bit)، ويرمّز الحقول بترتيب most-significant-byte-first بحيث تُوصل بترتيب حقول big-endian في الصيغة الثنائية. variant في أعلى بتات octet 8 وversion في أعلى 4bit من octet 6، وتحفظ هذه الصيغة هذين الموضعين كما هما.
- تميّز الأقسام 4.1–5.10 من RFC 9562 بين variant وversion 1–8 وNil وMax والنطاقات المحجوزة. وبما أن RFC 9562 حلّت محل RFC 4122، فالمرجع المعياري الحالي لهذه الصيغة هو RFC 9562.
- ABNF بصيغة hex-and-dash في RFC 9562 تمثيل نصي، وتوضح RFC أيضاً محاذير COM GUID بترتيب little-endian. لا يضع GEUL في Payload إلا الـ 16 octet القياسية في RFC لـ UUID.
- قواعد TAG وLength المباشر وframing بـ WORD ذات 16bit في GEUL ليست جزءاً من RFC 9562 بل قواعد تضيفها هذه الصيغة.

## الطول

- المجموع هو TAG (1 WORD) وPayload (8 WORD)، أي 9 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1000`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## أمثلة

متجه الاختبار UUIDv7 في RFC 9562 Appendix A.6 هو `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG هو `0c60`، وPayload هو `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
