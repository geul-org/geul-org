---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS صيغة Issuer من IEEE ثابتة من 6 WORD تحمل عنوان IEEE 802 MAC ذا 48bit بترتيب octet كما هو."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS قيمة Value ثابتة العرض تحمل قيمة عنوان IEEE 802 MAC ذي 48-bit. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0040` IEEE، ورقم الصيغة `0xC000`، والعائلة BINARY. Payload هو 3 WORD (6 octet، 48bit) تماماً.

## التخطيط

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  المجموع 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
رقم الصيغة        1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## التفسير والصلاحية

- تُترك octets الستة لعنوان MAC ذي 48-bit بترتيب octet نفسه في السلسلة المكتوبة وفي إرسال LAN. تُجمَّع octet 0–1 و2–3 و4–5 في WORD، من octet الأعلى إلى octet الأدنى.
- في وسائط IEEE 802 يُرسَل least-significant bit في كل octet أولاً، لكن لا تُعكس البتات داخل octet لهذا السبب. يبقى I/G وU/L في least-significant bit في octet 0 والبت الذي يليه.
- I/G=0 عنوان individual يُستخدم في الوجهة unicast، وI/G=1 عنوان group يُستخدم multicast أو broadcast. U/L=0 عنوان universally administered، وU/L=1 عنوان locally administered.
- لا يُستبعد بنيوياً أي نمط بسبب قيمة I/G أو U/L. تُمثَّل عناوين universally/locally administered وindividual/group كلها، ويمكن تمثيل عناوين MAC من نوع locally administered وrandomized وspoofed وvirtual كقيمة 48bit.
- تحفظ هذه القيمة 48bit فقط من العنوان المرصود أو المقدَّم. لا تضمن العنوان الدائم لجهاز بعينه ولا التفرد عالمياً ولا مصادقة الجهاز أو المستخدم ولا الملكية ولا الارتباط المستمر بالجهاز نفسه.
- تتناول هذه الصيغة عنوان IEEE 802 MAC ذا 48bit تماماً فقط. لا تحمل EUI-64 ولا عناوين MAC الأخرى ذات 64-bit. يصف IEEE RA المصطلح التاريخي `MAC-48` بأنه obsolete، لكن ليس كل عنوان MAC ذي 48-bit يمكن تسميته EUI-48، فلا تُطابَق هذه الصيغة مع EUI-48 تلقائياً.
- يُرفض ما لا يكون Payload فيه 3 WORD تماماً.

## السند المعياري

- يكتب [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) من IEEE Registration Authority عنوان LAN MAC ذا 48-bit كستة octet بترتيب الإرسال، ويوضح أن كل octet يُرسل بدءاً من least-significant bit وأن I/G وU/L هما أقل بتين أهمية في أول octet. تحفظ هذه الصيغة مواضع octet والبتات كما هي.
- يعرّف [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) من IEEE Registration Authority أن I/G=0/1 هو individual/group وU/L=0/1 هو إدارة universal/local، ويوضح أن العنوان local ليس فريداً عالمياً. ويشرح أيضاً العلاقة التاريخية والفرق بين المصطلح `MAC-48` وEUI-48.
- يوضح [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) أن EUI-48 وEUI-64 يمكن استخدامهما كعنوان MAC وغيره. هذا لا يعني وضع EUI-64 في هذا السجل ذي 48-bit.
- يسجل [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) و[RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) أن الأجهزة الفعلية قد تولّد عناوين MAC من نوع locally administered عشوائياً وتغيّرها. لذلك لا يُستنتج من قيمة MAC وحدها identity دائمة للجهاز.
- قواعد TAG وتخصيص Issuer وLength المباشر وframing بـ WORD ذات 16bit في GEUL ليست جزءاً من IEEE 802 ولا من المواد أعلاه بل قواعد تضيفها هذه الصيغة.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (3 WORD)، أي 6 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0101`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 3 WORD تماماً.

## أمثلة

عنوان locally administered individual (unicast) `02:00:5e:10:00:00` (في octet الأول `0x02`: I/G=0 وU/L=1):

```
0afc 0040 c000 0200 5e10 0000
```
