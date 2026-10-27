---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT قيمة Value تحمل سلسلة UTF-8 بلا لغة. تستخدم زوج الرموز الزوجي/الفردي 0x40/0x41."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT قيمة Value تحمل سلسلة بايتات UTF-8 صالحة وفق RFC 3629. تُستخدم للسلاسل التي لا لغة لها مثل المعرّفات والرموز وأسماء الملفات.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x40` (عدد بايتات زوجي) و`0x41` (عدد بايتات فردي). العائلة TEXT.
- يُحدد عدد البايتات بأقل بت في Codec وبعدد WORD في Payload: `2 × عدد WORD في Payload − أقل بت`، ولا يوجد Byte Count ([Value](/ar/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## التفسير والصلاحية

- يجب أن تكون سلسلة البايتات UTF-8 سليمة التكوين وبأقصر صيغة (shortest-form) وفق نحو RFC 3629. ولا تتضمن نتيجة فك الترميز إلا Unicode scalar value ضمن النطاق `U+0000..U+10FFFF`، ولا تتضمن نطاق surrogate `U+D800..U+DFFF`.
- يصف RFC 3629 معالجة signature في بداية النص U+FEFF بحسب السياق. ويحظر profile القياسي في GEUL فوق ذلك سلسلة بايتات UTF-8 BOM `EF BB BF` في بداية Payload. أما U+FEFF في موضع آخر فهو محرف لا BOM فلا تحظره هذه القاعدة.
- لا يُفرض تطبيع Unicode. يُحفظ تسلسل scalar الأصلي بعد فك الترميز كما هو.
- تُوضع سلسلة بايتات UTF-8 الصالحة في Payload دون تحويل. في WORD يأتي byte الأعلى أولاً. إذا كان عدد البايتات فردياً (رمز فردي) فيجب أن يكون byte الأدنى غير المستخدم في آخر WORD هو `00`.
- عدد WORD في Payload هو `ceil(عدد البايتات/2)`. يُرفض ما كان الرمز فيه فردياً لكن byte الأدنى في آخر WORD ليس `00`.

## السند المعياري

- نطاق scalar في UTF-8 وسلاسل البايتات سليمة التكوين ومعنى معالجة BOM تتبع [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- حظر BOM وزوج الرموز زوجي/فردي وzero padding وتوزيع TAG/Length في GEUL على WORD ذات 16 بت هي قواعد canonical framing في هذه الصيغة.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).
- السلسلة ذات 0 byte تُكتب كسجل من 1 WORD برمز زوجي (TAG WORD فقط) ([Value](/ar/grammar/value/)).

## أمثلة

- `A` (`41`) هو 1 byte (فردي) فيكون `UTF8-TEXT-ODD` (`0x41`) وPayload هو `4100` والمجموع 2 WORD و`LLLL=0001`. السجل الكامل هو `08C1 4100`.
- السلسلة الفارغة هي `0840` (`UTF8-TEXT-EVEN`، TAG WORD فقط) أي 1 WORD.
