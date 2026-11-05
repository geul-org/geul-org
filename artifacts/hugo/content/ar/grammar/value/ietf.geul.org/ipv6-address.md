---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS هو Value ثابت العرض يحمل قيمة 128bit لعنوان IPv6."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS هو Value ثابت العرض يحمل قيمة 128bit لعنوان IPv6. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000007` IETF، رقم Codec `0x0000C002`، العائلة BINARY. Payload هو 8 WORD بالضبط (128bit).

## التخطيط {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  الإجمالي 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
رقم Codec         2 WORD  0x0000C002
Payload           8 WORD (128bit)  IPv6 address, high-order bit → low-order bit
```

## التفسير والصلاحية {#해석과-유효성}

- تُوصَل WORD الثماني في Payload بدءًا من WORD الأعلى، وتُقرأ الـ 128bit في حقل عنوان IPv6 بترتيبها كما هي. في كل WORD يكون octet الأول هو الـ 8bit العليا.
- يحمل Payload الـ 128bit لعنوان واحد فقط. ولا يحمل CIDR prefix length ولا port ولا transport protocol.
- لا يدخل zone identifier ضمن الـ 128bit للعنوان، فلا يوضع في Payload. أما scoped address الذي يحتاج zone فيُعطى بسياق خارجي مثل interface أو Edge أو Reference أو Profile.
- يمكن تمثيل كل أنماط الـ 128bit. أما المعنى التشغيلي وإمكان استخدام أنماط unspecified وloopback وmulticast والخاصة والمحجوزة فيُحكم عليهما بسياق خارجي ولا تُقيِّد الصلاحية البنيوية.
- IPV4-ADDRESS وIPV6-ADDRESS صيغتان منفصلتان. ويُحفظ عنوان IPv6 من نوع IPv4-mapped أيضًا كقيمة IPv6 بعرض 128bit، ولا يُطابَق تلقائيًّا مع IPV4-ADDRESS ولا يُطبَّع أحدهما إلى الآخر.
- يمكن استخدام هذا Value مكوّنًا من مكوّنات المعرِّف في Reference، لكن scope وسياسة المرجع لا يتضمنهما نمط bits للعنوان.

## المرجع القياسي {#표준-근거}

- يعرّف [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) عنوان IPv6 بأنه identifier بعرض 128bit، ويحدّد صيغة bits للعناوين بما فيها unicast وanycast وmulticast وIPv4-mapped IPv6. وتحفظ هذه الصيغة تلك الـ 128bit دون إعادة تفسير.
- يعرّف [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) Source Address وDestination Address في حزمة IPv6 كلاً منهما حقلًا بعرض 128bit. وتحفظ WORD الخاصة بـ Payload ترتيب ذلك الحقل من high-order bit إلى low-order bit.
- يبيّن [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) أن zone للعنوان غير العام (non-global) لا يُرمَّز في العنوان نفسه بل يُحدَّد بالسياق (context). لذلك يوضع zone identifier خارج Payload.
- يمكن استخدام التدوين النصي في RFC 4291 للشرح والإدخال/الإخراج فقط. ولا يحدّد [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) صيغة التخزين الداخلية، فلا يُستخدم توحيده القانوني للنص (canonicalization) توحيدًا قانونيًّا لهذا السجل الثنائي.
- إن TAG وتخصيص Issuer والطول المباشر وتأطير WORD بعرض 16bit في GEUL ليست جزءًا من هذه الـ RFC، بل قواعد تضيفها هذه الصيغة.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 8 WORD، أي 13 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1100`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## مثال {#예시}

عنوان IPv6 `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- لا يؤثر الاختصار في كتابة النص على Payload.
