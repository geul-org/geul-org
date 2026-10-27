---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS صيغة Issuer من IETF ثابتة من 5 WORD تحمل 32 بت من عنوان IPv4 بترتيب network byte order كما هو."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS قيمة Value ثابتة العرض تحمل القيمة ذات 32 بت لعنوان IPv4. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0020` IETF، ورقم الصيغة `0xC001`، والعائلة BINARY. Payload هو 2 WORD (32bit) تماماً.

## التخطيط

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  المجموع 5 WORD
Issuer            1 WORD  0x0020 (IETF)
رقم الصيغة        1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## التفسير والصلاحية

- تُترك octets العنوان بترتيب network byte order كما هي. في كل WORD يكون octet الأول هو أعلى 8bit والتالي هو أدنى 8bit.
- يحمل Payload 32bit لعنوان واحد فقط. لا يحمل CIDR prefix length ولا port ولا transport protocol.
- يمكن تمثيل كل نمط من 32bit. المعنى التشغيلي لأنماط مثل unspecified والخاصة والمحجوزة والبث المتعدد، وإمكانية استخدامها، يُحكم فيهما من السياق الخارجي ولا يقيّدان الصلاحية البنيوية.
- IPV4-ADDRESS وIPV6-ADDRESS صيغتان منفصلتان. لا يُحوَّل عنوان IPv6 من نوع IPv4-mapped تلقائياً إلى هذه الصيغة ولا يُطبَّع إلى القيمة نفسها.
- يمكن استخدام هذا Value مكوّناً من مكوّنات المعرّف في Reference، لكن سياسة الإشارة وعمرها غير موجودين في نمط بتات العنوان.
- يُرفض ما لا يكون Payload فيه 2 WORD تماماً.

## السند المعياري

- يعرّف [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) عنوان IPv4 بطول ثابت 4 octet (32bit)، ويعرّف Source Address وDestination Address كحقل 32bit لكل منهما. يُحفظ في Payload ترتيب إرسال octet في Appendix B وقاعدة most-significant-bit-first لكل octet.
- قواعد TAG وتخصيص Issuer وتجميع WORD ذات 16bit وLength في GEUL ليست جزءاً من RFC 791 بل قواعد framing تضيفها هذه الصيغة.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (2 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 2 WORD تماماً.

## أمثلة

عنوان IPv4 `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
