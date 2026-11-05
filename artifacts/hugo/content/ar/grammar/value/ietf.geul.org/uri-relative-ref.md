---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF هو Value يحمل سلسلة bytes بترميز ASCII وفق قواعد relative-ref في RFC 3986."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF هو Value يحمل سلسلة bytes بترميز ASCII وفق قواعد `relative-ref` في RFC 3986. ولا يوضع base URI ولا الناتج بعد resolve في Payload.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000007` IETF، رقم Codec `0x00008000` (عدد زوجي من bytes) و`0x00008001` (عدد فردي من bytes). العائلة TEXT.
- يُحدَّد عدد bytes بأدنى bit في رقم Codec وعدد WORD في Payload، وهو `2 × عدد WORD في Payload − أدنى bit`، ولا يوجد Byte Count ([Value](../_index.md)).

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length TAG ممتد] عندما يكون الإجمالي 15 WORD فأكثر
Issuer            2 WORD  0x00000007 (IETF)
رقم Codec         2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## التفسير والصلاحية {#해석과-유효성}

- يجب أن تطابق سلسلة bytes قواعد RFC 3986 `relative-ref = relative-part [ "?" query ] [ "#" fragment ]`.
- terminal في قواعد URI هي محارف US-ASCII. تُخزَّن محارف ASCII المسموح بها كما هي، وعند percent-encoding لـ octet يُستخدم الشكل `pct-encoded = "%" HEXDIG HEXDIG`. ولا يجوز وضع محارف غير ASCII مباشرة كـ literal byte.
- يمكن أن يكون `relative-part` هو `path-empty`، لذا فسلسلة bytes الفارغة أيضًا `relative-ref` صالح نحويًّا.
- base URI وسياق الـ resolution وناتج resolve سياق خارج هذه الصيغة.
- داخل WORD يأتي byte الأعلى أولًا. وإذا كان عدد bytes فرديًّا (الرمز الفردي) فيجب أن يكون byte الأدنى غير المستخدم في آخر WORD هو `00`.
- عدد WORD في Payload هو `ceil(عدد bytes/2)`. يُرفض إن كان الرمز فرديًّا وbyte الأدنى في آخر WORD ليس `00`.

## المرجع القياسي {#표준-근거}

- تتبع قواعد `relative-ref` ومحارف URI وpercent-encoding المرجع [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- إن زوج الرمزين الزوجي/الفردي وzero padding وTAG/Length في GEUL وتوزيع WORD بعرض 16bit هي قواعد framing لهذه الصيغة. أما base URI وناتج تفسير المرجع فهما من سياق RFC لكنهما لا يوضعان في Payload.

## الطول {#길이}

- الإجمالي هو عدد WORD في TAG بمقدار 1 WORD، وLength TAG ممتد (إن وُجد)، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload. ما كان 14 WORD فأقل يستخدم الطول المباشر، وما كان 15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل Length TAG الممتد في العدد الكلي ([Length](../../record.md)).
- 0 byte هو `relative-ref` فارغ مسموح به دلاليًّا ولا يحتوي على Payload WORD. أما تخطيطه الفيزيائي فهو مسألة مفتوحة أدناه.

## مثال {#예시}

- `a/b?x=1` هو 7 bytes (فردي)، لذا رقم Codec هو `0x00008001` وPayload هو `612F 623F 783D 3100`. والإجمالي 9 WORD فيكون `LLLL=1000`. والسجل كله `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## مسائل مفتوحة {#열린-문제}

- التخطيط الفيزيائي لـ `relative-ref` الفارغ (0 byte). لم يُحدَّد بعدُ لأن سجلًا بلا Payload لا يتفق مع قاعدة «الحد الأدنى لـ Payload هو 1 WORD».
