---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS هو Value ثابت العرض يحمل قيمة عنوان IEEE 802 MAC بعرض 48-bit."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS هو Value ثابت العرض يحمل قيمة عنوان IEEE 802 MAC بعرض 48-bit. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x0000000D` IEEE، رقم Codec `0x0000C000`، العائلة BINARY. Payload هو 3 WORD بالضبط (6 octet، أي 48bit).

## التخطيط {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  الإجمالي 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
رقم Codec         2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## التفسير والصلاحية {#해석과-유효성}

- تبقى octets الست لعنوان MAC بعرض 48-bit على ترتيب octet نفسه في السلسلة المكتوبة وفي نقل LAN. وتُجمَّع octet 0–1 وoctet 2–3 وoctet 4–5 كلٌّ في WORD بترتيب octet الأعلى ثم octet الأدنى.
- في وسائط IEEE 802 يُرسَل least-significant bit من كل octet أولًا، لكن لا تُقلَب bits داخل octet لهذا السبب. يبقى I/G وU/L في least-significant bit من octet 0 وفي bit الذي يليه كما هما.
- I/G=0 عنوان فردي (individual) يُستخدم عند الوجهة كـ unicast، وI/G=1 عنوان جماعي (group) يُستخدم كـ multicast أو broadcast. وU/L=0 عنوان مُدار عالميًّا (universally administered)، وU/L=1 عنوان مُدار محليًّا (locally administered).
- لا يوجد pattern مستبعد بنيويًّا بسبب قيمة I/G أو U/L. فالعناوين المُدارة عالميًّا/محليًّا والفردية/الجماعية كلها قابلة للتمثيل، ويمكن تمثيل عناوين MAC المُدارة محليًّا والعشوائية (randomized) والمنتحلة (spoofed) والافتراضية (virtual) بقيمة 48bit.
- تحفظ هذه القيمة 48bit من العنوان الذي رُصد أو قُدِّم فقط. ولا تضمن عنوانًا دائمًا لجهاز بعينه، ولا تفرّدًا عالميًّا، ولا مصادقة الجهاز أو المستخدم، ولا الملكية، ولا ارتباطًا مستمرًّا بالجهاز نفسه.
- تتناول هذه الصيغة عناوين IEEE 802 MAC بعرض 48bit بالضبط فقط. ولا تحمل EUI-64 ولا عناوين MAC الأخرى بعرض 64-bit. يصف IEEE RA المصطلح التاريخي `MAC-48` بأنه obsolete، لكن لا يمكن تسمية كل عنوان MAC بعرض 48-bit بـ EUI-48، لذا لا تُطابَق هذه الصيغة تلقائيًّا مع EUI-48.
- يُرفض إن لم يكن Payload 3 WORD بالضبط.

## المرجع القياسي {#표준-근거}

- يصف [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) من IEEE Registration Authority أن عنوان LAN MAC بعرض 48-bit يُكتب على هيئة ست octets بترتيب النقل، وأن كل octet يُرسَل بدءًا من least-significant bit، وأن I/G وU/L هما أدنى bitين في octet الأول. وتحفظ هذه الصيغة مواضع octet وbit كما هي.
- يعرّف [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) من IEEE Registration Authority أن I/G=0/1 هو individual/group وأن U/L=0/1 هو universal/local administration، ويبيّن أن العنوان المحلي ليس فريدًا عالميًّا. كما يشرح العلاقة التاريخية بين المصطلحين `MAC-48` وEUI-48 والفرق بينهما.
- يبيّن [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) أن EUI-48 وEUI-64 يمكن استخدامهما كعناوين MAC وغيرها. وهذا لا يعني وضع EUI-64 في هذا السجل ذي 48-bit.
- يسجّل [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) و[RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) أن الأجهزة الفعلية قد تولّد عناوين MAC مُدارة محليًّا عشوائيًّا وتغيّرها. لذلك لا تُستنتج هوية جهاز دائمة (identity) من قيمة MAC وحدها.
- إن TAG وتخصيص Issuer والطول المباشر وتأطير WORD بعرض 16bit في GEUL ليست جزءًا من IEEE 802 ولا من المراجع أعلاه، بل قواعد تضيفها هذه الصيغة.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 3 WORD، أي 8 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=0111`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 3 WORD بالضبط.

## مثال {#예시}

عنوان فردي (unicast) مُدار محليًّا `02:00:5e:10:00:00` (I/G=0 وU/L=1 في octet الأول `0x02`):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
