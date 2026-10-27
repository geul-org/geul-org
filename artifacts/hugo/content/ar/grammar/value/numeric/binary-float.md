---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT قيمة Value تحمل سلسلة بتات التبادل IEEE 754 binary16/32/64/128 كما هي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT قيمة Value تمثل scalar ثنائياً للتبادل وفق IEEE 754. الرمز المباشر في Value هو `0x03` والعائلة NUMERIC. إذا كان Payload من 1/2/4/8 WORD فهو binary16/32/64/128 على التوالي. تُحفظ سلسلة بتات التبادل كما هي، ولا يُسمح بأحجام Payload أخرى.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st  (أعلى WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (أدنى WORD)   IEEE Binary Interchange Nth
```

## التفسير

- تُوصل WORD الـ Payload بترتيب big-endian وتُقرأ كسلسلة بتات تبادل ثنائية وفق IEEE 754 بالعرض المناسب.
- تُحفظ أنماط بتات التبادل بما فيها NaN payload وsigned zero.
- لا يجوز للمفكك أن يستبدل NaN بـ NaN قياسي واحد اعتباطي، ولا أن يمحو إشارة signed zero.
- طريقة التقريب والسلوك الحسابي لا تحددهما صيغة التسلسل هذه.

## الطول

المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload ([السجل وTAG WORD](/ar/grammar/record/)).

| الصيغة | Payload | رمز Length | Length ممتد TAG | الطول الكلي |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | لا يوجد | 2 WORD |
| binary32 | 2 WORD | `0010` | لا يوجد | 3 WORD |
| binary64 | 4 WORD | `0100` | لا يوجد | 5 WORD |
| binary128 | 8 WORD | `1000` | لا يوجد | 9 WORD |

binary128 أيضاً ضمن النطاق المباشر 1~14 WORD فلا يستخدم Length ممتد TAG.

## الصلاحية

- Payload هو بالضبط واحد من 1 أو 2 أو 4 أو 8 WORD.
- يجب أن يطابق كل حجم Payload تمثيل Length في الجدول أعلاه تماماً.
- لا يُسمح بإعادة الترميز بتغيير العرض ولا بـ WORD حشو قبل Payload أو بعده.

## أمثلة

| الصيغة | TAG | Length ممتد TAG | مثال Payload | الحكم |
|---|---|---|---|---|
| binary16 | `0883` | لا يوجد | `0000` | قياسي |
| binary32 | `0903` | لا يوجد | `0000 0000` | قياسي |
| binary64 | `0A03` | لا يوجد | `0000 0000 0000 0000` | قياسي |
| binary128 | `0C03` | لا يوجد | سلسلة بتات من 8 WORD | قياسي |
| أي | الحجم لا يطابق ما يدل عليه Length | أي | أي | invalid |

## السند المعياري

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): تُطبَّق ترميزات التبادل binary16 وbinary32 وbinary64 وbinary128. لا يضيف GEUL إلى سلسلة البتات تلك سوى TAG وframing بـ WORD ذات 16 بت وفق big-endian.
