---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF قيمة Value تحمل سلسلة بايتات ASCII وفق نحو relative-ref في RFC 3986. تستخدم رقم الصيغة 0x8000/0x8001 تحت Issuer الخاص بـ IETF."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF قيمة Value تحمل سلسلة بايتات ASCII وفق نحو `relative-ref` في RFC 3986. لا يوضع base URI ولا النتيجة بعد الحل (resolve) في Payload.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0020` IETF، ورقم الصيغة `0x8000` (عدد بايتات زوجي) و`0x8001` (عدد بايتات فردي). العائلة TEXT.
- يُحدد عدد البايتات بأقل بت في رقم الصيغة وبعدد WORD في Payload: `2 × عدد WORD في Payload − أقل بت`، ولا يوجد Byte Count ([Value](/ar/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0020 (IETF)
رقم الصيغة        1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## التفسير والصلاحية

- يجب أن تطابق سلسلة البايتات نحو `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` في RFC 3986.
- المحارف الطرفية (terminal) في نحو URI هي محارف US-ASCII. تُخزَّن محارف ASCII المسموح بها كما هي، وعند ترميز octet بالنسبة المئوية (percent-encoding) تُستخدم الصيغة `pct-encoded = "%" HEXDIG HEXDIG`. لا يجوز وضع محارف غير ASCII مباشرة كـ literal byte.
- بما أن `relative-part` قد يكون `path-empty` فإن سلسلة البايتات الفارغة أيضاً `relative-ref` صالح نحوياً.
- base URI وسياق الحل (resolution context) ونتيجة الحل من سياق خارج هذه الصيغة.
- في WORD يأتي byte الأعلى أولاً. إذا كان عدد البايتات فردياً (رمز فردي) فيجب أن يكون byte الأدنى غير المستخدم في آخر WORD هو `00`.
- عدد WORD في Payload هو `ceil(عدد البايتات/2)`. يُرفض ما كان الرمز فيه فردياً لكن byte الأدنى في آخر WORD ليس `00`.

## السند المعياري

- نحو `relative-ref` ومحارف URI والترميز بالنسبة المئوية يتبع [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- زوج الرموز زوجي/فردي وzero padding وتوزيع TAG/Length في GEUL على WORD ذات 16 بت هي قواعد framing في هذه الصيغة. base URI ونتيجة حل المرجع من سياق RFC لكنها لا توضع في Payload.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).
- 0 byte هو `relative-ref` فارغ مسموح دلالياً وليس فيه WORD في Payload. أما تخطيطه الفيزيائي فهو المسألة المفتوحة أدناه.

## أمثلة

- `a/b?x=1` هو 7 bytes (فردي) فرقم الصيغة `0x8001` وPayload هو `612f 623f 783d 3100`. المجموع 7 WORD فـ `LLLL=0110`. السجل الكامل هو `0B7C 0020 8001 612f 623f 783d 3100`.

## مسائل مفتوحة

- التخطيط الفيزيائي لـ `relative-ref` الفارغ (0 byte). لم يتحدد بعد لأن سجلاً بلا Payload لا يتفق مع قاعدة "Payload لا يقل عن 1 WORD".
