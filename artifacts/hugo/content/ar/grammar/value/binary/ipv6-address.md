---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS صيغة Issuer من IETF ثابتة من 11 WORD تحمل 128 بت من عنوان IPv6 بترتيبها كما هو."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS قيمة Value ثابتة العرض تحمل القيمة ذات 128bit لعنوان IPv6. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0020` IETF، ورقم الصيغة `0xC002`، والعائلة BINARY. Payload هو 8 WORD (128bit) تماماً.

## التخطيط

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  المجموع 11 WORD
Issuer            1 WORD  0x0020 (IETF)
رقم الصيغة        1 WORD  0xC002
Payload           8 WORD (128 بت)  IPv6 address, high-order bit → low-order bit
```

## التفسير والصلاحية

- تُوصل WORD الثمانية في Payload بدءاً من أعلى WORD، فتُقرأ 128bit لحقل عنوان IPv6 بترتيبها كما هو. في كل WORD يكون octet الأول هو أعلى 8bit.
- يحمل Payload 128bit لعنوان واحد فقط. لا يحمل CIDR prefix length ولا port ولا transport protocol.
- لا يُوضع zone identifier في Payload لأنه ليس ضمن 128bit للعنوان. العنوان ذو النطاق الذي يحتاج إلى zone يُعطى بسياق خارجي مثل interface أو Edge أو Reference أو Profile.
- يمكن تمثيل كل نمط من 128bit. المعنى التشغيلي لأنماط unspecified وloopback وmulticast والخاصة والمحجوزة، وإمكانية استخدامها، يُحكم فيهما من السياق الخارجي ولا يقيّدان الصلاحية البنيوية.
- IPV4-ADDRESS وIPV6-ADDRESS صيغتان منفصلتان. عنوان IPv6 من نوع IPv4-mapped أيضاً يُحفظ كقيمة IPv6 ذات 128bit، ولا يُعامل تلقائياً كمطابق لـ IPV4-ADDRESS ولا يُطبَّع أحدهما إلى الآخر.
- يمكن استخدام هذا Value مكوّناً من مكوّنات المعرّف في Reference، لكن النطاق وسياسة الإشارة غير موجودين في نمط بتات العنوان.

## السند المعياري

- يعرّف [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) عنوان IPv6 كمعرّف من 128bit ويحدد صيغة بتات العناوين بما فيها unicast وanycast وmulticast وIPv4-mapped IPv6. تحفظ هذه الصيغة تلك الـ 128bit دون إعادة تفسير.
- يعرّف [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) Source Address وDestination Address في حزمة IPv6 كحقل 128bit لكل منهما. تحفظ WORD في Payload ترتيب حقل العنوان من high-order bit إلى low-order bit.
- يوضح [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) أن zone العنوان غير العام لا يُرمَّز في العنوان نفسه بل يحدده السياق. لذلك يُترك zone identifier خارج Payload.
- يمكن استخدام التمثيل النصي في RFC 4291 للشرح وللإدخال والإخراج فقط. لا يحدد [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) صيغة التخزين الداخلية، فلا يُستخدم توحيد السلسلة النصية فيه توحيداً لهذا السجل الثنائي.
- قواعد TAG وتخصيص Issuer وLength المباشر وframing بـ WORD ذات 16bit في GEUL ليست جزءاً من هذه RFC بل قواعد تضيفها هذه الصيغة.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## أمثلة

عنوان IPv6 `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- الاختصار في الكتابة النصية لا يؤثر في Payload.
