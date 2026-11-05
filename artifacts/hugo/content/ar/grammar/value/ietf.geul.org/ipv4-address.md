---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS هو Value ثابت العرض يحمل قيمة 32bit لعنوان IPv4."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS هو Value ثابت العرض يحمل قيمة 32bit لعنوان IPv4. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000007` IETF، رقم Codec `0x0000C001`، العائلة BINARY. Payload هو 2 WORD بالضبط (32bit).

## التخطيط {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  الإجمالي 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
رقم Codec         2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## التفسير والصلاحية {#해석과-유효성}

- تبقى octets العنوان بترتيب network byte order كما هي. في كل WORD يكون octet الأول هو الـ 8bit العليا وoctet التالي هو الـ 8bit الدنيا.
- يحمل Payload الـ 32bit لعنوان واحد فقط. ولا يحمل CIDR prefix length ولا port ولا transport protocol.
- يمكن تمثيل كل أنماط الـ 32bit. أما المعنى التشغيلي وإمكان استخدام أنماط مثل unspecified والخاصة والمحجوزة والـ multicast فيُحكم عليهما بسياق خارجي ولا تُقيِّد الصلاحية البنيوية.
- IPV4-ADDRESS وIPV6-ADDRESS صيغتان منفصلتان. ولا يُحوَّل عنوان IPv6 من نوع IPv4-mapped تلقائيًّا إلى هذه الصيغة ولا يُطبَّع إلى القيمة نفسها.
- يمكن استخدام هذا Value مكوّنًا من مكوّنات المعرِّف في Reference، لكن سياسة المرجع وعمره لا يتضمنهما نمط bits للعنوان.
- يُرفض إن لم يكن Payload 2 WORD بالضبط.

## المرجع القياسي {#표준-근거}

- يعرّف [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) عنوان IPv4 بطول ثابت هو 4 octet (32bit)، ويعرّف Source Address وDestination Address كلاً منهما حقلًا بعرض 32bit. ويحفظ Payload ترتيب إرسال octet في Appendix B وقاعدة most-significant-bit-first لكل octet.
- إن TAG وتخصيص Issuer وتجميع WORD بعرض 16bit وLength في GEUL ليست جزءًا من RFC 791، بل قواعد framing تضيفها هذه الصيغة.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 2 WORD، أي 7 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 2 WORD بالضبط.

## مثال {#예시}

عنوان IPv4 `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
